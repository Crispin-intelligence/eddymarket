// Eddy OS – web POS server. Zero dependencies (Node 22+ with built-in node:sqlite).
// One SQLite file per store: data/<STORE_ID>.db  -> run one instance per supermarket.
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import net from 'node:net';
import os from 'node:os';
import { execFile } from 'node:child_process';
import { DatabaseSync } from 'node:sqlite';
import { fileURLToPath } from 'node:url';
import { seedDemo } from './seed.js';

const ROOT = path.dirname(fileURLToPath(import.meta.url));
const PORT = +process.env.PORT || 3000;
const STORE = (process.env.STORE_ID || 'eddy').replace(/[^a-z0-9_-]/gi, '') || 'eddy';
const DATA = process.env.DATA_DIR || path.join(ROOT, 'data');
fs.mkdirSync(DATA, { recursive: true });

const db = new DatabaseSync(path.join(DATA, `${STORE}.db`));
db.exec(`
PRAGMA journal_mode=WAL; PRAGMA foreign_keys=ON;
CREATE TABLE IF NOT EXISTS settings(key TEXT PRIMARY KEY, value TEXT);
CREATE TABLE IF NOT EXISTS users(
  id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,
  role TEXT NOT NULL CHECK(role IN ('owner','cashier')),
  salt TEXT NOT NULL, hash TEXT NOT NULL, active INTEGER NOT NULL DEFAULT 1);
CREATE TABLE IF NOT EXISTS items(
  id INTEGER PRIMARY KEY AUTOINCREMENT, barcode TEXT NOT NULL UNIQUE, name TEXT NOT NULL,
  name_ar TEXT NOT NULL DEFAULT '', category TEXT NOT NULL DEFAULT '',
  price_cents INTEGER NOT NULL, cost_cents INTEGER NOT NULL DEFAULT 0,
  stock REAL NOT NULL DEFAULT 0, min_stock REAL NOT NULL DEFAULT 0, unit TEXT NOT NULL DEFAULT 'pc',
  image TEXT, active INTEGER NOT NULL DEFAULT 1, updated_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS item_barcodes(barcode TEXT PRIMARY KEY, item_id INTEGER NOT NULL REFERENCES items(id) ON DELETE CASCADE);
CREATE TABLE IF NOT EXISTS sales(
  id INTEGER PRIMARY KEY AUTOINCREMENT, created_at TEXT NOT NULL, user_id INTEGER, user_name TEXT,
  total_cents INTEGER NOT NULL, cost_cents INTEGER NOT NULL DEFAULT 0, rate INTEGER NOT NULL,
  method TEXT NOT NULL, currency TEXT NOT NULL, tendered REAL, change_cents INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'ok');
CREATE TABLE IF NOT EXISTS sale_items(
  id INTEGER PRIMARY KEY AUTOINCREMENT, sale_id INTEGER NOT NULL REFERENCES sales(id) ON DELETE CASCADE,
  item_id INTEGER, barcode TEXT, name TEXT NOT NULL, qty REAL NOT NULL,
  price_cents INTEGER NOT NULL, cost_cents INTEGER NOT NULL DEFAULT 0);
CREATE INDEX IF NOT EXISTS ix_sales_created ON sales(created_at);
CREATE INDEX IF NOT EXISTS ix_saleitems_sale ON sale_items(sale_id);
CREATE INDEX IF NOT EXISTS ix_saleitems_item ON sale_items(item_id);
`);

// ---------- settings ----------
const DEFAULTS = { store_name: 'Eddy Market', rate: '90000', footer: 'Thank you for shopping with us', tz: 'Asia/Beirut', shop_on: '1', shop_wa: '', shop_card: '1', shop_whish: '', photo_auto: '1' };
const getSetting = (k) => db.prepare('SELECT value FROM settings WHERE key=?').get(k)?.value ?? DEFAULTS[k];
const setSetting = (k, v) => db.prepare('INSERT INTO settings(key,value) VALUES(?,?) ON CONFLICT(key) DO UPDATE SET value=excluded.value').run(k, String(v));
const publicSettings = () => ({ shop_card: getSetting('shop_card') === '1', shop_whish: getSetting('shop_whish'), photo_auto: getSetting('photo_auto') === '1', shop_on: getSetting('shop_on') === '1', shop_wa: getSetting('shop_wa'), store_name: getSetting('store_name'), rate: +getSetting('rate'), footer: getSetting('footer'), tz: getSetting('tz'), store_id: STORE, print_mode: getSetting('print_mode') || 'browser', print_auto: getSetting('print_auto') === '1', print_drawer: getSetting('print_drawer') === '1' });

// ---------- users / auth ----------
const hashPin = (pin, salt) => crypto.scryptSync(String(pin), salt, 32).toString('hex');
function createUser(name, role, pin) {
  const salt = crypto.randomBytes(16).toString('hex');
  return db.prepare('INSERT INTO users(name,role,salt,hash) VALUES(?,?,?,?)').run(name, role, salt, hashPin(pin, salt)).lastInsertRowid;
}
function setPin(id, pin) {
  const salt = crypto.randomBytes(16).toString('hex');
  db.prepare('UPDATE users SET salt=?, hash=? WHERE id=?').run(salt, hashPin(pin, salt), id);
}
const randomPin = () => String(crypto.randomInt(100000, 1000000));
function announceOwnerPin(pin, why) {
  const file = path.join(DATA, `${STORE}.owner-pin.txt`);
  fs.writeFileSync(file, `${pin}\n`, { mode: 0o600 });
  console.log(`\n  ${why}\n  Owner PIN: ${pin}   (also saved in ${file})\n  Change it in Settings after your first login.\n`);
}
if (process.argv.includes('--reset-owner-pin')) {
  const o = db.prepare("SELECT id FROM users WHERE role='owner' ORDER BY id LIMIT 1").get();
  const pin = randomPin();
  if (o) setPin(o.id, pin); else createUser('Owner', 'owner', pin);
  announceOwnerPin(pin, 'Owner PIN reset.');
  process.exit(0);
}
if (!db.prepare("SELECT 1 FROM users WHERE role='owner'").get()) {
  const pin = randomPin();
  createUser('Owner', 'owner', pin);
  announceOwnerPin(pin, `First run for store "${STORE}".`);
}
if ((!db.prepare('SELECT 1 FROM items LIMIT 1').get() && process.env.SEED_DEMO !== '0') || process.env.SEED_DEMO === '1') {
  seedDemo(db);
  console.log('  Demo items loaded (set SEED_DEMO=0 to start empty).');
}

const sessions = new Map(); // token -> {user, exp}
const fails = new Map();    // ip -> {n, until}
const SESSION_MS = 12 * 3600e3;
function authUser(req) {
  const t = (req.headers.authorization || '').replace(/^Bearer /, '');
  const s = sessions.get(t);
  if (!s) return null;
  if (s.exp < Date.now()) { sessions.delete(t); return null; }
  return s.user;
}

// ---------- money + search ----------
const toLL = (cents, rate) => Math.round((cents / 100) * rate / 1000) * 1000;
const AR_DIGITS = '٠١٢٣٤٥٦٧٨٩';
const norm = (s) => String(s ?? '').toLowerCase().replace(/[\u00C0-\u024F]/g, (c) => c.normalize('NFD').replace(/[\u0300-\u036f]/g, ''))
  .replace(/[ً-ْٰـ]/g, '').replace(/[إأآ]/g, 'ا').replace(/ى/g, 'ي').replace(/ة/g, 'ه')
  .replace(/[٠-٩]/g, (d) => AR_DIGITS.indexOf(d)).replace(/\s+/g, ' ').trim();

let cache = null;
const invalidate = () => { cache = null; };
function loadCache() {
  if (cache) return cache;
  const extra = new Map();
  for (const r of db.prepare('SELECT barcode,item_id FROM item_barcodes').all()) {
    if (!extra.has(r.item_id)) extra.set(r.item_id, []);
    extra.get(r.item_id).push(r.barcode);
  }
  cache = db.prepare('SELECT id,barcode,name,name_ar,category,price_cents,cost_cents,stock,min_stock,unit,updated_at,(image IS NOT NULL AND image<>\'\') AS has_image FROM items WHERE active=1 ORDER BY name').all()
    .map((i) => ({ ...i, has_image: !!i.has_image, extra: extra.get(i.id) || [], h: norm(`${i.name} ${i.name_ar} ${i.category} ${i.barcode} ${(extra.get(i.id) || []).join(' ')}`) }));
  cache.vocab = new Set(); for (const i of cache) for (const w of i.h.split(' ')) if (w && !/^\d+$/.test(w)) cache.vocab.add(w);
  return cache;
}
// Synonym groups (EN / FR / AR / common misspellings). A query word matches an item if the item contains the word or any synonym.
const SYN = [
  ['cigarette', 'cigarettes', 'cigarete', 'cigarret', 'cigar', 'tobacco', 'tabac', 'دخان', 'سجاير', 'سجائر', 'سيجاره', 'سيجارة', 'تبغ', 'دخّان'],
  ['chocolat', 'chocolate', 'choco', 'choc', 'شوكولا', 'شوكولاته', 'شوكلاته', 'شوكولاتة', 'شوكلا'],
  ['biscuit', 'biscuits', 'cookie', 'cookies', 'بسكويت', 'بسكوت'],
  ['water', 'eau', 'ماء', 'مياه', 'موية'],
  ['juice', 'jus', 'عصير'],
  ['milk', 'lait', 'حليب'],
  ['bread', 'pain', 'خبز'],
  ['coffee', 'cafe', 'قهوه', 'قهوة', 'نسكافيه', 'nescafe'],
  ['cheese', 'fromage', 'جبنه', 'جبنة'],
  ['chips', 'crisps', 'شيبس'],
  ['soda', 'drink', 'drinks', 'boisson', 'مشروب', 'مشروبات'],
  ['mars', 'مارس'], ['cedars', 'cedar', 'cedre', 'سيدرز', 'سيدرس', 'ارز'], ['pepsi', 'بيبسي'], ['cola', 'كولا', 'coca'], ['snickers', 'سنيكرز'], ['twix', 'تويكس'], ['kitkat', 'كيتكات'], ['nutella', 'نوتيلا'],
].map((g) => [...new Set(g.map((w) => norm(w)))]);
const SYNMAP = new Map(); for (const g of SYN) for (const w of g) SYNMAP.set(w, g);
const isWordy = (t) => t.length < 3 && !/^\d+$/.test(t);
const matches = (h, t) => (isWordy(t) ? (' ' + h + ' ').includes(' ' + t + ' ') : h.includes(t));
function editDist(a, b, max) {
  if (Math.abs(a.length - b.length) > max) return max + 1;
  let prev = Array.from({ length: b.length + 1 }, (_, j) => j);
  for (let i = 1; i <= a.length; i++) {
    const cur = [i]; let min = i;
    for (let j = 1; j <= b.length; j++) { cur[j] = Math.min(prev[j] + 1, cur[j - 1] + 1, prev[j - 1] + (a[i - 1] === b[j - 1] ? 0 : 1)); if (cur[j] < min) min = cur[j]; }
    if (min > max) return max + 1; prev = cur;
  }
  return prev[b.length];
}
function expand(t) {
  const alts = new Set([t]);
  for (const w of SYNMAP.get(t) || []) alts.add(w);
  if (t.length >= 8 && t.endsWith('s')) alts.add(t.slice(0, -1));
  return [...alts];
}
function search(q, { loose = false, category = '', limit = 60, offset = 0 } = {}) {
  let list = loadCache();
  if (category) list = list.filter((i) => i.category === category);
  const tokens = norm(q).replace(/[^\p{L}\p{N}\s.]/gu, ' ').replace(/\s+/g, ' ').trim().split(' ').filter(Boolean);
  let out = list;
  if (tokens.length) {
    const terms = tokens.map(expand);
    const col = (alts) => list.map((i) => alts.some((a) => matches(i.h, a)));
    let cols = terms.map(col);
    // A word nothing matches (typo): borrow the closest words from the catalogue's vocabulary.
    cols.forEach((c, k) => {
      if (c.some(Boolean) || tokens[k].length < 4 || /^\d+$/.test(tokens[k])) return;
      const max = tokens[k].length >= 7 ? 2 : 1, near = [];
      for (const w of loadCache().vocab) if (w.length >= 3 && editDist(tokens[k], w, max) <= max) near.push(w);
      if (near.length) { terms[k] = [...terms[k], ...near.slice(0, 12)]; cols[k] = col(terms[k]); }
    });
    const df = cols.map((c) => c.reduce((n, x) => n + (x ? 1 : 0), 0));
    const w = df.map((d) => Math.log((list.length + 1) / (d + 1)) + 0.1);
    const rows = [];
    list.forEach((i, r) => {
      let score = 0, all = true;
      cols.forEach((c, k) => { if (c[r]) score += w[k]; else all = false; });
      if (score > 0) rows.push({ i, score, all });
    });
    const strict = rows.filter((x) => x.all);
    let pick = strict;
    if (loose || !strict.length) pick = rows; // nothing matches every word: show what matches the most distinctive ones
    const first = tokens[0];
    pick.sort((a, b) => (b.all - a.all) || b.score - a.score || (b.i.name.toLowerCase().startsWith(first) - a.i.name.toLowerCase().startsWith(first)) || a.i.name.length - b.i.name.length);
    out = pick.map((x) => x.i);
  }
  return { total: out.length, rows: out.slice(offset, offset + limit) };
}
const findByBarcode = (code) => {
  const c = String(code).trim();
  return loadCache().find((i) => i.barcode === c || i.extra.includes(c)) || null;
};
function view(i, rate, owner) {
  const o = { id: i.id, barcode: i.barcode, name: i.name, name_ar: i.name_ar, category: i.category, price_cents: i.price_cents,
    price_ll: toLL(i.price_cents, rate), stock: i.stock, min_stock: i.min_stock, unit: i.unit, has_image: i.has_image, v: i.updated_at, extra_barcodes: i.extra };
  if (owner) o.cost_cents = i.cost_cents;
  return o;
}
const kioskView = (i, rate) => ({ id: i.id, barcode: i.barcode, name: i.name, name_ar: i.name_ar, category: i.category, unit: i.unit,
  price_cents: i.price_cents, price_ll: toLL(i.price_cents, rate), has_image: i.has_image, v: i.updated_at });

// ---------- helpers ----------
const json = (res, code, obj) => { const b = JSON.stringify(obj); res.writeHead(code, { 'Content-Type': 'application/json; charset=utf-8', 'Cache-Control': 'no-store' }); res.end(b); };
class HttpError extends Error { constructor(code, msg) { super(msg); this.code = code; } }
const bad = (msg, code = 400) => { throw new HttpError(code, msg); };
const num = (v, d = 0) => { const n = Number(v); return Number.isFinite(n) ? n : d; };
const cents = (usd) => Math.round(num(usd) * 100);
const dayKey = (iso, tz) => new Intl.DateTimeFormat('en-CA', { timeZone: tz }).format(new Date(iso));
function readBody(req) {
  return new Promise((resolve, reject) => {
    let size = 0; const chunks = [];
    req.on('data', (c) => { size += c.length; if (size > 10e6) { reject(new HttpError(413, 'Request too large')); req.destroy(); } else chunks.push(c); });
    req.on('end', () => { try { resolve(chunks.length ? JSON.parse(Buffer.concat(chunks).toString('utf8')) : {}); } catch { reject(new HttpError(400, 'Invalid JSON')); } });
    req.on('error', reject);
  });
}
function parseItemBody(b, existing) {
  const barcode = String(b.barcode ?? existing?.barcode ?? '').trim();
  const name = String(b.name ?? existing?.name ?? '').trim();
  if (!barcode) bad('Barcode is required');
  if (!name) bad('Name is required');
  const price = b.price_cents ?? (b.price_usd !== undefined ? cents(b.price_usd) : existing?.price_cents);
  if (!Number.isInteger(price) || price < 0) bad('Price must be zero or more');
  return {
    barcode, name, name_ar: String(b.name_ar ?? existing?.name_ar ?? '').trim(), category: String(b.category ?? existing?.category ?? '').trim(),
    price_cents: price, cost_cents: b.cost_cents ?? (b.cost_usd !== undefined ? cents(b.cost_usd) : existing?.cost_cents ?? 0),
    stock: num(b.stock, existing?.stock ?? 0), min_stock: num(b.min_stock, existing?.min_stock ?? 0), unit: String(b.unit ?? existing?.unit ?? 'pc').trim() || 'pc',
  };
}
const now = () => new Date().toISOString();
function saveExtraBarcodes(itemId, list) {
  db.prepare('DELETE FROM item_barcodes WHERE item_id=?').run(itemId);
  for (const c of [...new Set((list || []).map((x) => String(x).trim()).filter(Boolean))]) {
    db.prepare('INSERT OR IGNORE INTO item_barcodes(barcode,item_id) VALUES(?,?)').run(c, itemId);
  }
}
function tx(fn) {
  db.exec('BEGIN IMMEDIATE');
  try { const r = fn(); db.exec('COMMIT'); return r; } catch (e) { db.exec('ROLLBACK'); throw e; }
}
function saleView(id) {
  const s = db.prepare('SELECT * FROM sales WHERE id=?').get(id);
  if (!s) return null;
  s.total_ll = toLL(s.total_cents, s.rate);
  s.items = db.prepare('SELECT item_id,barcode,name,qty,price_cents FROM sale_items WHERE sale_id=? ORDER BY id').all(id);
  return s;
}

// ---------- backups ----------
// Daily snapshot of the whole database (VACUUM INTO is safe while the till is running). BACKUP_DIR can point at a USB drive or cloud-synced folder.
const BK = process.env.BACKUP_DIR || path.join(DATA, 'backups');
fs.mkdirSync(BK, { recursive: true });
const BK_RE = new RegExp(`^${STORE}-\\d{4}-\\d{2}-\\d{2}-\\d{2}-\\d{2}\\.db$`);
function listBackups() {
  return fs.readdirSync(BK).filter((n) => BK_RE.test(n)).map((n) => { const st = fs.statSync(path.join(BK, n)); return { name: n, size: st.size, at: st.mtime.toISOString() }; }).sort((a, b) => (a.name < b.name ? 1 : -1));
}
function makeBackup() {
  const name = `${STORE}-${new Date().toISOString().replace(/[:T]/g, '-').slice(0, 16)}.db`;
  const file = path.join(BK, name);
  if (!fs.existsSync(file)) db.exec(`VACUUM INTO '${file.replace(/'/g, "''")}'`);
  for (const old of listBackups().slice(30)) fs.rmSync(path.join(BK, old.name), { force: true }); // keep the newest 30
  return name;
}
function backupIfDue() {
  try { const last = listBackups()[0]; if (!last || Date.now() - new Date(last.at).getTime() > 20 * 3600e3) console.log('  Backup saved:', makeBackup()); } catch (e) { console.error('  Backup failed:', e.message); }
}
backupIfDue(); setInterval(backupIfDue, 3600e3).unref();

// ---------- receipt printer (ESC/POS) ----------
// The browser draws the receipt as a bitmap (so Arabic shapes correctly) and we send it to the thermal printer over the
// network (port 9100), a shared Windows printer, or a Mac/Linux CUPS queue. The cash drawer opens through the printer.
const PRINT_DEFAULT = { mode: 'browser', host: '', port: '9100', share: '', drawer: '1', auto: '1' };
const printCfg = () => Object.fromEntries(Object.keys(PRINT_DEFAULT).map((k) => [k, getSetting('print_' + k) ?? PRINT_DEFAULT[k]]));
const DRAWER = Buffer.from([0x1b, 0x70, 0x00, 0x19, 0xfa]);
function escpos(raster, drawer) {
  const parts = [Buffer.from([0x1b, 0x40])];
  if (raster) {
    const wb = raster.w / 8;
    for (let y = 0; y < raster.h; y += 128) {
      const hh = Math.min(128, raster.h - y);
      parts.push(Buffer.from([0x1d, 0x76, 0x30, 0x00, wb & 255, wb >> 8, hh & 255, hh >> 8]), raster.buf.subarray(y * wb, (y + hh) * wb));
    }
    parts.push(Buffer.from([0x1b, 0x64, 0x04, 0x1d, 0x56, 0x42, 0x03]));
  }
  if (drawer) parts.push(DRAWER);
  return Buffer.concat(parts);
}
function sendToPrinter(buf) {
  const c = printCfg();
  return new Promise((resolve, reject) => {
    const fail = (m) => reject(new HttpError(502, m));
    if (c.mode === 'lan') {
      if (!c.host) return fail('Printer address is not set');
      const sock = net.connect({ host: c.host, port: +c.port || 9100 });
      let bad = false;
      sock.setTimeout(5000);
      sock.on('timeout', () => { bad = true; sock.destroy(); fail('Printer did not answer'); });
      sock.on('error', () => { bad = true; fail('Printer is not reachable'); });
      sock.on('connect', () => sock.end(buf));
      sock.on('close', () => { if (!bad) resolve(); });
    } else if (c.mode === 'share' || c.mode === 'cups') {
      if (!c.share) return fail('Printer name is not set');
      const file = path.join(os.tmpdir(), `eddy-print-${crypto.randomBytes(6).toString('hex')}.bin`);
      const done = (err) => { fs.rmSync(file, { force: true }); if (err) fail('Could not send to the printer'); else resolve(); };
      if (c.mode === 'share' && process.platform !== 'win32') return fail('Shared-printer mode is for Windows');
      fs.writeFileSync(file, buf);
      if (c.mode === 'share') execFile('cmd.exe', ['/c', 'copy', '/b', file, `\\\\localhost\\${c.share}`], { windowsHide: true, timeout: 8000 }, done);
      else execFile('lp', ['-d', c.share, '-o', 'raw', file], { timeout: 8000 }, done);
    } else fail('Printer is set to browser printing');
  });
}
function parseRaster(r) {
  if (!r) return null;
  const w = Number(r.w), h = Number(r.h);
  if (w !== 576 || !Number.isInteger(h) || h < 1 || h > 6000) bad('Invalid receipt image');
  const buf = Buffer.from(String(r.data || ''), 'base64');
  if (buf.length !== (w / 8) * h) bad('Invalid receipt image');
  return { w, h, buf };
}

// ---------- routes ----------
const routes = [];
const route = (method, pattern, auth, fn) => routes.push({ method, re: new RegExp(`^${pattern}$`), auth, fn });

route('POST', '/api/login', null, ({ body, ip }) => {
  const f = fails.get(ip);
  if (f && f.until > Date.now()) bad('locked', 429);
  const u = db.prepare('SELECT * FROM users WHERE id=? AND active=1').get(num(body.user_id));
  const ok = u && crypto.timingSafeEqual(Buffer.from(hashPin(body.pin ?? '', u.salt), 'hex'), Buffer.from(u.hash, 'hex'));
  if (!ok) {
    const n = (f?.n || 0) + 1;
    fails.set(ip, { n, until: n >= 5 ? Date.now() + 5 * 60e3 : 0 });
    bad('wrong_pin', 401);
  }
  fails.delete(ip);
  const token = crypto.randomBytes(32).toString('hex');
  const user = { id: u.id, name: u.name, role: u.role };
  sessions.set(token, { user, exp: Date.now() + SESSION_MS });
  return { token, user };
});
route('GET', '/api/users', null, () => db.prepare('SELECT id,name,role FROM users WHERE active=1 ORDER BY role DESC,name').all());
route('GET', '/api/settings', null, () => publicSettings());
route('GET', '/api/me', 'any', ({ user }) => user);
route('POST', '/api/logout', 'any', ({ req }) => { sessions.delete((req.headers.authorization || '').replace(/^Bearer /, '')); return { ok: true }; });
route('PUT', '/api/settings', 'owner', ({ body }) => {
  if (body.store_name !== undefined) setSetting('store_name', String(body.store_name).trim().slice(0, 80) || DEFAULTS.store_name);
  if (body.footer !== undefined) setSetting('footer', String(body.footer).slice(0, 200));
  if (body.shop_on !== undefined) setSetting('shop_on', body.shop_on ? '1' : '0');
  if (body.shop_wa !== undefined) setSetting('shop_wa', normPhone(body.shop_wa));
  if (body.shop_card !== undefined) setSetting('shop_card', body.shop_card ? '1' : '0');
  if (body.shop_whish !== undefined) setSetting('shop_whish', normPhone(body.shop_whish));
  if (body.photo_auto !== undefined) setSetting('photo_auto', body.photo_auto ? '1' : '0');
  if (body.rate !== undefined) { const r = Math.round(num(body.rate)); if (r < 1) bad('Rate must be above zero'); setSetting('rate', r); }
  return publicSettings();
});

// items
route('GET', '/api/items', 'any', ({ url, user }) => {
  const rate = +getSetting('rate'); const p = url.searchParams;
  const { total, rows } = search(p.get('q') || '', { category: p.get('category') || '', limit: Math.min(Number(p.get('limit')) || 60, 500), offset: num(p.get('offset')) });
  return { total, items: rows.map((i) => view(i, rate, user.role === 'owner')) };
});
route('GET', '/api/categories', 'any', () => {
  const m = new Map();
  for (const i of loadCache()) m.set(i.category, (m.get(i.category) || 0) + 1);
  return [...m].map(([category, n]) => ({ category, n })).sort((a, b) => b.n - a.n);
});
route('GET', '/api/items/barcode/([^/]+)', 'any', ({ m, user }) => {
  const i = findByBarcode(decodeURIComponent(m[1]));
  if (!i) bad('not_found', 404);
  return view(i, +getSetting('rate'), user.role === 'owner');
});
route('POST', '/api/items', 'owner', ({ body }) => {
  const d = parseItemBody(body);
  if (findByBarcode(d.barcode) || db.prepare('SELECT 1 FROM items WHERE barcode=?').get(d.barcode)) bad('barcode_exists', 409);
  const id = tx(() => {
    const id = db.prepare('INSERT INTO items(barcode,name,name_ar,category,price_cents,cost_cents,stock,min_stock,unit,image,updated_at) VALUES(?,?,?,?,?,?,?,?,?,?,?)')
      .run(d.barcode, d.name, d.name_ar, d.category, d.price_cents, d.cost_cents, d.stock, d.min_stock, d.unit, body.image || null, now()).lastInsertRowid;
    saveExtraBarcodes(id, body.extra_barcodes);
    return id;
  });
  invalidate();
  return view(loadCache().find((i) => i.id === Number(id)), +getSetting('rate'), true);
});
route('PUT', '/api/items/(\\d+)', 'owner', ({ m, body }) => {
  const id = +m[1];
  const ex = db.prepare('SELECT * FROM items WHERE id=?').get(id);
  if (!ex) bad('not_found', 404);
  const d = parseItemBody(body, ex);
  const clash = db.prepare('SELECT id FROM items WHERE barcode=? AND id<>?').get(d.barcode, id);
  if (clash) bad('barcode_exists', 409);
  tx(() => {
    db.prepare('UPDATE items SET barcode=?,name=?,name_ar=?,category=?,price_cents=?,cost_cents=?,stock=?,min_stock=?,unit=?,updated_at=? WHERE id=?')
      .run(d.barcode, d.name, d.name_ar, d.category, d.price_cents, d.cost_cents, d.stock, d.min_stock, d.unit, now(), id);
    if (body.image !== undefined) db.prepare('UPDATE items SET image=? WHERE id=?').run(body.image || null, id);
    if (body.extra_barcodes !== undefined) saveExtraBarcodes(id, body.extra_barcodes);
  });
  invalidate();
  return view(loadCache().find((i) => i.id === id), +getSetting('rate'), true);
});
route('DELETE', '/api/items/(\\d+)', 'owner', ({ m }) => {
  db.prepare("UPDATE items SET active=0, barcode=barcode||'#removed'||id, updated_at=? WHERE id=?").run(now(), +m[1]);
  db.prepare('DELETE FROM item_barcodes WHERE item_id=?').run(+m[1]);
  invalidate();
  return { ok: true };
});
route('POST', '/api/items/import', 'owner', ({ body }) => {
  const rows = Array.isArray(body.rows) ? body.rows : bad('No rows');
  if (rows.length > 20000) bad('Too many rows (max 20,000)');
  let created = 0, updated = 0; const errors = [];
  tx(() => {
    rows.forEach((r, n) => {
      try {
        const barcode = String(r.barcode ?? '').trim();
        const ex = db.prepare('SELECT * FROM items WHERE barcode=?').get(barcode)
          || (db.prepare('SELECT i.* FROM item_barcodes b JOIN items i ON i.id=b.item_id WHERE b.barcode=?').get(barcode));
        const d = parseItemBody({ ...r, barcode: ex ? ex.barcode : barcode }, ex);
        const extra = String(r.extra_barcodes ?? '').split(';').map((s) => s.trim()).filter(Boolean);
        if (ex) {
          db.prepare('UPDATE items SET name=?,name_ar=?,category=?,price_cents=?,cost_cents=?,stock=?,min_stock=?,unit=?,active=1,updated_at=? WHERE id=?')
            .run(d.name, d.name_ar, d.category, d.price_cents, d.cost_cents, d.stock, d.min_stock, d.unit, now(), ex.id);
          if (extra.length) saveExtraBarcodes(ex.id, extra);
          updated++;
        } else {
          const id = db.prepare('INSERT INTO items(barcode,name,name_ar,category,price_cents,cost_cents,stock,min_stock,unit,updated_at) VALUES(?,?,?,?,?,?,?,?,?,?)')
            .run(d.barcode, d.name, d.name_ar, d.category, d.price_cents, d.cost_cents, d.stock, d.min_stock, d.unit, now()).lastInsertRowid;
          if (extra.length) saveExtraBarcodes(id, extra);
          created++;
        }
      } catch (e) { if (errors.length < 20) errors.push({ row: n + 2, error: e.message }); }
    });
  });
  invalidate();
  return { created, updated, errors };
});
route('GET', '/api/items/export', 'owner', ({ res }) => {
  const q = (s) => `"${String(s ?? '').replace(/"/g, '""')}"`;
  const lines = ['barcode,name,name_ar,category,price_usd,cost_usd,stock,min_stock,unit,extra_barcodes'];
  for (const i of loadCache()) lines.push([q(i.barcode), q(i.name), q(i.name_ar), q(i.category), (i.price_cents / 100).toFixed(2), (i.cost_cents / 100).toFixed(2), i.stock, i.min_stock, q(i.unit), q(i.extra.join(';'))].join(','));
  res.writeHead(200, { 'Content-Type': 'text/csv; charset=utf-8', 'Content-Disposition': `attachment; filename="${STORE}-items.csv"` });
  res.end('﻿' + lines.join('\n'));
  return undefined;
});
route('GET', '/api/admin/printer', 'owner', () => printCfg());
route('PUT', '/api/admin/printer', 'owner', ({ body }) => {
  const mode = String(body.mode || 'browser');
  if (!['browser', 'lan', 'share', 'cups'].includes(mode)) bad('Invalid printer mode');
  const host = String(body.host || '').trim(), share = String(body.share || '').trim(), port = String(Math.round(num(body.port, 9100)) || 9100);
  if (host && !/^[A-Za-z0-9.-]{1,100}$/.test(host)) bad('Invalid printer address');
  if (share && !/^[\w .-]{1,60}$/.test(share)) bad('Invalid printer name');
  if (+port < 1 || +port > 65535) bad('Invalid port');
  for (const [k, v] of Object.entries({ mode, host, port, share, drawer: body.drawer ? '1' : '0', auto: body.auto ? '1' : '0' })) setSetting('print_' + k, v);
  return printCfg();
});
route('POST', '/api/print', 'any', async ({ body }) => {
  await sendToPrinter(escpos(parseRaster(body.raster), body.drawer && printCfg().drawer === '1'));
  return { ok: true };
});
route('POST', '/api/drawer', 'any', async () => { await sendToPrinter(escpos(null, true)); return { ok: true }; });
route('GET', '/api/admin/backups', 'owner', () => listBackups().slice(0, 10));
route('POST', '/api/admin/backups', 'owner', () => ({ name: makeBackup() }));
route('GET', '/api/admin/backups/([^/]+)', 'owner', ({ m, res }) => {
  const n = decodeURIComponent(m[1]);
  if (!BK_RE.test(n) || !fs.existsSync(path.join(BK, n))) bad('not_found', 404);
  res.writeHead(200, { 'Content-Type': 'application/octet-stream', 'Content-Disposition': `attachment; filename="${n}"` });
  fs.createReadStream(path.join(BK, n)).pipe(res);
  return undefined;
});
route('GET', '/img/(\\d+)', null, ({ m, res }) => {
  const r = db.prepare('SELECT image FROM items WHERE id=?').get(+m[1]);
  const mm = /^data:(image\/(?:jpeg|png|webp));base64,(.+)$/.exec(r?.image || '');
  if (!mm) bad('not_found', 404);
  res.writeHead(200, { 'Content-Type': mm[1], 'Cache-Control': 'public, max-age=31536000, immutable' });
  res.end(Buffer.from(mm[2], 'base64'));
  return undefined;
});

// sales
route('POST', '/api/sales', 'any', ({ body, user }) => {
  const lines = Array.isArray(body.lines) ? body.lines : [];
  if (!lines.length || lines.length > 200) bad('Add at least one item');
  const method = body.method === 'card' ? 'card' : 'cash';
  const currency = body.currency === 'LL' ? 'LL' : 'USD';
  const rate = +getSetting('rate');
  const id = tx(() => {
    let total = 0, cost = 0; const rows = [];
    for (const l of lines) {
      const it = db.prepare('SELECT * FROM items WHERE id=? AND active=1').get(num(l.item_id));
      const qty = num(l.qty);
      if (!it) bad('An item in the cart no longer exists');
      if (!(qty > 0) || qty > 10000) bad(`Invalid quantity for ${it.name}`);
      total += Math.round(qty * it.price_cents); cost += Math.round(qty * it.cost_cents);
      rows.push({ it, qty });
    }
    let tendered = null, change = 0;
    if (method === 'cash') {
      tendered = num(body.tendered, NaN);
      const paid = currency === 'USD' ? Math.round(tendered * 100) : Math.round((tendered / rate) * 100);
      if (!Number.isFinite(tendered) || paid < total - (currency === 'LL' ? 1 : 0)) bad('Amount received is less than the total');
      change = Math.max(0, paid - total);
    }
    const sid = db.prepare('INSERT INTO sales(created_at,user_id,user_name,total_cents,cost_cents,rate,method,currency,tendered,change_cents) VALUES(?,?,?,?,?,?,?,?,?,?)')
      .run(now(), user.id, user.name, total, cost, rate, method, currency, tendered, change).lastInsertRowid;
    for (const { it, qty } of rows) {
      db.prepare('INSERT INTO sale_items(sale_id,item_id,barcode,name,qty,price_cents,cost_cents) VALUES(?,?,?,?,?,?,?)').run(sid, it.id, it.barcode, it.name, qty, it.price_cents, it.cost_cents);
      db.prepare('UPDATE items SET stock=ROUND(stock-?,3) WHERE id=?').run(qty, it.id);
    }
    return sid;
  });
  invalidate();
  return saleView(Number(id));
});
route('GET', '/api/sales', 'any', ({ url, user }) => {
  const limit = Math.min(Number(url.searchParams.get('limit')) || 100, 500);
  const rows = user.role === 'owner'
    ? db.prepare('SELECT * FROM sales ORDER BY id DESC LIMIT ?').all(limit)
    : db.prepare('SELECT * FROM sales WHERE user_id=? ORDER BY id DESC LIMIT ?').all(user.id, Math.min(limit, 50));
  return rows.map((s) => ({ ...s, total_ll: toLL(s.total_cents, s.rate) }));
});
route('GET', '/api/sales/(\\d+)', 'any', ({ m, user }) => {
  const s = saleView(+m[1]);
  if (!s || (user.role !== 'owner' && s.user_id !== user.id)) bad('not_found', 404);
  return s;
});
route('POST', '/api/sales/(\\d+)/void', 'owner', ({ m }) => {
  const id = +m[1];
  tx(() => {
    const s = db.prepare('SELECT status FROM sales WHERE id=?').get(id);
    if (!s) bad('not_found', 404);
    if (s.status !== 'ok') bad('Already voided');
    for (const l of db.prepare('SELECT item_id,qty FROM sale_items WHERE sale_id=?').all(id)) db.prepare('UPDATE items SET stock=ROUND(stock+?,3) WHERE id=?').run(l.qty, l.item_id);
    db.prepare("UPDATE sales SET status='void' WHERE id=?").run(id);
  });
  invalidate();
  return saleView(id);
});

// dashboard
route('GET', '/api/dashboard', 'owner', () => {
  const tz = getSetting('tz'); const rate = +getSetting('rate');
  const since = new Date(Date.now() - 9 * 86400e3).toISOString();
  const rows = db.prepare("SELECT id,created_at,total_cents,cost_cents FROM sales WHERE status='ok' AND created_at>=? ORDER BY id").all(since);
  const todayKey = dayKey(now(), tz);
  const days = [];
  for (let n = 6; n >= 0; n--) days.push({ day: dayKey(new Date(Date.now() - n * 86400e3).toISOString(), tz), total_cents: 0, count: 0 });
  const byDay = new Map(days.map((d) => [d.day, d]));
  let minToday = Infinity, min7 = Infinity; const t = { total_cents: 0, cost_cents: 0, count: 0 };
  for (const r of rows) {
    const k = dayKey(r.created_at, tz); const d = byDay.get(k);
    if (d) { d.total_cents += r.total_cents; d.count++; min7 = Math.min(min7, r.id); }
    if (k === todayKey) { t.total_cents += r.total_cents; t.cost_cents += r.cost_cents; t.count++; minToday = Math.min(minToday, r.id); }
  }
  const top = (minId) => minId === Infinity ? [] : db.prepare("SELECT si.name, SUM(si.qty) qty, SUM(ROUND(si.qty*si.price_cents)) revenue_cents FROM sale_items si JOIN sales s ON s.id=si.sale_id WHERE s.id>=? AND s.status='ok' AND s.created_at>=? GROUP BY si.item_id ORDER BY revenue_cents DESC LIMIT 8").all(minId, since);
  const low = loadCache().filter((i) => i.min_stock > 0 && i.stock <= i.min_stock).sort((a, b) => a.stock - b.stock).slice(0, 12).map((i) => ({ id: i.id, name: i.name, name_ar: i.name_ar, stock: i.stock, min_stock: i.min_stock, unit: i.unit }));
  return {
    rate, today: { ...t, total_ll: toLL(t.total_cents, rate), avg_cents: t.count ? Math.round(t.total_cents / t.count) : 0, profit_cents: t.total_cents - t.cost_cents },
    days, top_week: top(min7), low, negative_stock: loadCache().filter((i) => i.stock < 0).length,
  };
});

// team
route('GET', '/api/admin/users', 'owner', () => db.prepare('SELECT id,name,role,active FROM users ORDER BY active DESC,role DESC,name').all());
route('POST', '/api/admin/users', 'owner', ({ body }) => {
  const name = String(body.name ?? '').trim(); const pin = String(body.pin ?? '');
  if (!name) bad('Name is required');
  if (!/^\d{4,8}$/.test(pin)) bad('PIN must be 4 to 8 digits');
  return { id: createUser(name, body.role === 'owner' ? 'owner' : 'cashier', pin) };
});
route('PUT', '/api/admin/users/(\\d+)', 'owner', ({ m, body, user }) => {
  const id = +m[1];
  if (!db.prepare('SELECT 1 FROM users WHERE id=?').get(id)) bad('not_found', 404);
  if (body.pin !== undefined) { if (!/^\d{4,8}$/.test(String(body.pin))) bad('PIN must be 4 to 8 digits'); setPin(id, body.pin); }
  if (body.name !== undefined && String(body.name).trim()) db.prepare('UPDATE users SET name=? WHERE id=?').run(String(body.name).trim(), id);
  if (body.active !== undefined) {
    if (id === user.id && !body.active) bad("You can't deactivate yourself");
    db.prepare('UPDATE users SET active=? WHERE id=?').run(body.active ? 1 : 0, id);
  }
  return { ok: true };
});

// kiosk (public, read-only, no cost or stock)
route('GET', '/api/kiosk/lookup', null, ({ url }) => {
  const i = findByBarcode(url.searchParams.get('barcode') || '');
  if (!i) bad('not_found', 404);
  return kioskView(i, +getSetting('rate'));
});
route('GET', '/api/kiosk/featured', null, () => {
  const rate = +getSetting('rate');
  return loadCache().filter((i) => i.has_image).slice(0, 8).map((i) => kioskView(i, rate)); // items with a photo, as tap-to-try examples
});
route('GET', '/api/kiosk/search', null, ({ url }) => {
  const rate = +getSetting('rate');
  const q = url.searchParams.get('q') || '';
  let rows = search(q, { limit: 8 }).rows; // every word must match first, so a specific phrase lands on one item
  if (!rows.length) rows = search(q, { loose: true, limit: 8 }).rows; // then any word, for sloppy voice input
  return rows.map((i) => kioskView(i, rate));
});


// ---------- online shop (customers) ----------
db.exec(`CREATE TABLE IF NOT EXISTS orders(id INTEGER PRIMARY KEY AUTOINCREMENT, code TEXT UNIQUE NOT NULL, created_at TEXT NOT NULL,
  name TEXT NOT NULL, phone TEXT NOT NULL, mode TEXT NOT NULL, address TEXT, note TEXT, total_cents INTEGER NOT NULL, rate INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'new', items TEXT NOT NULL);`);
for (const c of ["pay_method TEXT NOT NULL DEFAULT 'cash'", "pay_status TEXT NOT NULL DEFAULT 'unpaid'"]) { try { db.exec('ALTER TABLE orders ADD COLUMN ' + c); } catch { /* already there */ } }
// Payment methods. All are settled in person today; an online gateway plugs in here (see deploy/README.md, "Adding an online gateway").
const PAYMENTS = { cash: { online: false }, card: { online: false }, whish: { online: false, manual: true } };
const payOptions = () => ({ card: getSetting('shop_card') === '1', whish: getSetting('shop_whish') });
function markPaid(code, ref = '') { // call this from a gateway webhook once a payment is confirmed
  const r = db.prepare("UPDATE orders SET pay_status='paid' WHERE code=?").run(code); if (!r.changes) bad('not_found', 404); return { ok: true, ref };
}
// Lebanese numbers in any common form (03 123 456, +961 3 123456, 71123456) -> 9613123456
function normPhone(s) {
  let d = String(s || '').replace(/\D/g, ''); if (d.startsWith('00')) d = d.slice(2);
  if (d.startsWith('961')) { /* already international */ } else if (d.startsWith('0')) d = '961' + d.slice(1); else if (d.length >= 7 && d.length <= 8) d = '961' + d;
  return d.length >= 10 && d.length <= 15 ? d : '';
}
const SHOP_HIDE = new Set(); // categories to keep off the online shop (empty = everything is sold)
const shopOk = (i) => !SHOP_HIDE.has(i.category) && i.price_cents > 0;
const orderHits = new Map();
function orderLimited(ip) {
  const now = Date.now(), a = (orderHits.get(ip) || []).filter((t) => now - t < 3600e3);
  if (a.length >= 8) { orderHits.set(ip, a); return true; }
  a.push(now); orderHits.set(ip, a); return false;
}
const orderCode = () => Array.from(crypto.randomBytes(6), (b) => 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'[b % 32]).join('');
const orderLines = (o) => JSON.parse(o.items);
const pubOrder = (o) => ({ code: o.code, status: o.status, mode: o.mode, created_at: o.created_at, total_cents: o.total_cents, total_ll: toLL(o.total_cents, o.rate), pay_method: o.pay_method, pay_status: o.pay_status, items: orderLines(o) });
const staffOrder = (o) => ({ id: o.id, ...pubOrder(o), name: o.name, phone: o.phone, address: o.address, note: o.note });

if (process.env.SHOP_WA && !db.prepare("SELECT 1 FROM settings WHERE key='shop_wa'").get()) setSetting('shop_wa', normPhone(process.env.SHOP_WA));
route('GET', '/api/shop/home', null, () => {
  const rate = +getSetting('rate'), all = loadCache().filter(shopOk), counts = new Map();
  for (const i of all) counts.set(i.category, (counts.get(i.category) || 0) + 1);
  const withPic = all.filter((i) => i.has_image);
  return { store_name: getSetting('store_name'), rate, open: getSetting('shop_on') === '1', wa: getSetting('shop_wa'), pay: payOptions(),
    featured: withPic.slice(0, 12).map((i) => kioskView(i, rate)),
    recent: [...withPic].sort((a, b) => String(b.updated_at).localeCompare(String(a.updated_at))).slice(0, 12).map((i) => kioskView(i, rate)),
    cats: [...counts].map(([category, n]) => ({ category, n })).filter((c) => c.category !== 'other').sort((a, b) => b.n - a.n)
      .concat(counts.has('other') ? [{ category: 'other', n: counts.get('other') }] : []) };
});
route('GET', '/api/shop/items', null, ({ url }) => {
  const rate = +getSetting('rate'), q = url.searchParams.get('q') || '', category = url.searchParams.get('category') || '', ids = url.searchParams.get('ids');
  const lim = Math.min(60, +url.searchParams.get('limit') || 24), off = Math.max(0, +url.searchParams.get('offset') || 0);
  let rows;
  if (ids) { const set = new Set(ids.split(',').slice(0, 60).map(Number)); rows = loadCache().filter((i) => set.has(i.id)); } else rows = search(q, { category, limit: 5000 }).rows;
  rows = rows.filter(shopOk);
  if (!q && !ids) rows = [...rows.filter((i) => i.has_image), ...rows.filter((i) => !i.has_image)]; // photos first when browsing
  return { total: rows.length, items: rows.slice(off, off + lim).map((i) => kioskView(i, rate)) };
});
route('POST', '/api/shop/order', null, ({ body, ip }) => {
  if (getSetting('shop_on') !== '1') bad('Online ordering is closed right now', 403);
  const name = String(body.name || '').trim().slice(0, 60); if (name.length < 2) bad('Enter your name');
  const phone = normPhone(body.phone); if (!phone) bad('Enter a valid phone number');
  const mode = body.mode === 'delivery' ? 'delivery' : 'pickup';
  const address = String(body.address || '').trim().slice(0, 200); if (mode === 'delivery' && address.length < 5) bad('Enter your delivery address');
  const note = String(body.note || '').trim().slice(0, 200);
  const po = payOptions(), pay = body.pay === 'card' && po.card ? 'card' : body.pay === 'whish' && po.whish ? 'whish' : 'cash';
  const lines = Array.isArray(body.lines) ? body.lines : []; if (!lines.length || lines.length > 60) bad('Your cart is empty');
  const byId = new Map(loadCache().map((i) => [i.id, i])); let total = 0; const out = [];
  for (const l of lines) {
    const it = byId.get(+l.item_id), qty = Math.round(num(l.qty) * 100) / 100;
    if (!it || !shopOk(it) || !(qty > 0) || qty > 99) bad('One of the items is no longer available');
    total += Math.round(qty * it.price_cents); out.push({ item_id: it.id, name: it.name, name_ar: it.name_ar, qty, price_cents: it.price_cents, unit: it.unit });
  }
  if (orderLimited(ip)) bad('Too many orders from this connection. Try again later.', 429);
  let code; do code = orderCode(); while (db.prepare('SELECT 1 FROM orders WHERE code=?').get(code));
  const rate = +getSetting('rate');
  db.prepare('INSERT INTO orders(code,created_at,name,phone,mode,address,note,total_cents,rate,items,pay_method) VALUES(?,?,?,?,?,?,?,?,?,?,?)')
    .run(code, new Date().toISOString(), name, phone, mode, address, note, total, rate, JSON.stringify(out), pay);
  return { code, status: 'new', pay_method: pay, total_cents: total, total_ll: toLL(total, rate) };
});
route('GET', '/api/shop/orders', null, ({ url }) => {
  const codes = (url.searchParams.get('codes') || '').split(',').filter((c) => /^[A-Z0-9]{6}$/.test(c)).slice(0, 20);
  return codes.map((c) => db.prepare('SELECT * FROM orders WHERE code=?').get(c)).filter(Boolean).map(pubOrder);
});
route('GET', '/api/orders', 'any', () => db.prepare(`SELECT * FROM orders WHERE status IN ('new','accepted','ready') OR created_at>? ORDER BY CASE status WHEN 'new' THEN 0 WHEN 'accepted' THEN 1 WHEN 'ready' THEN 2 ELSE 3 END, id DESC LIMIT 100`)
  .all(new Date(Date.now() - 2 * 864e5).toISOString()).map(staffOrder));
route('PUT', '/api/orders/(\\d+)/paid', 'any', ({ m }) => { const o = db.prepare('SELECT code FROM orders WHERE id=?').get(+m[1]); if (!o) bad('not_found', 404); markPaid(o.code); return staffOrder(db.prepare('SELECT * FROM orders WHERE id=?').get(+m[1])); });
route('PUT', '/api/orders/(\\d+)/status', 'any', ({ m, body }) => {
  if (!['accepted', 'ready', 'done', 'rejected'].includes(body.status)) bad('Unknown status');
  const r = db.prepare('UPDATE orders SET status=? WHERE id=?').run(body.status, +m[1]); if (!r.changes) bad('not_found', 404);
  return staffOrder(db.prepare('SELECT * FROM orders WHERE id=?').get(+m[1]));
});


// ---------- product photo finder: barcode -> free open product databases ----------
db.exec(`CREATE TABLE IF NOT EXISTS photo_tried(item_id INTEGER PRIMARY KEY, at TEXT NOT NULL, found INTEGER NOT NULL DEFAULT 0);`);
const PHOTO_SRC = process.env.PHOTO_BASE ? [process.env.PHOTO_BASE] : ['https://world.openfoodfacts.org', 'https://world.openbeautyfacts.org', 'https://world.openproductsfacts.org'];
const PHOTO_DELAY = process.env.PHOTO_DELAY !== undefined ? +process.env.PHOTO_DELAY : 700; // be polite: under 100 requests a minute
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
function validGtin(c) { // real manufacturer barcodes only: EAN-8 / UPC-A / EAN-13 / GTIN-14 with a correct check digit, not in-store (20-29) codes
  if (!/^\d+$/.test(c) || ![8, 12, 13, 14].includes(c.length) || (c.length === 13 && c[0] === '2')) return false;
  let sum = 0; for (let k = 0; k < c.length - 1; k++) sum += +c[c.length - 2 - k] * (k % 2 === 0 ? 3 : 1);
  return (10 - (sum % 10)) % 10 === +c[c.length - 1];
}
async function fetchPhoto(code) {
  for (const base of PHOTO_SRC) {
    let j;
    try {
      const r = await fetch(`${base}/api/v2/product/${code}.json?fields=image_front_url,image_front_small_url`, { headers: { 'User-Agent': 'EddyOS/1.0 (+https://eddy.ci-ccg.com)' }, signal: AbortSignal.timeout(12000) });
      if (r.status === 429) throw new Error('rate');
      if (!r.ok) continue;
      j = await r.json();
    } catch (e) { throw new Error(e.message === 'rate' ? 'rate' : 'net'); }
    if (j.status !== 1) continue;
    for (const u of [j.product?.image_front_url, j.product?.image_front_small_url]) {
      if (!u) continue;
      try {
        const ir = await fetch(u, { signal: AbortSignal.timeout(15000) }); if (!ir.ok) continue;
        const ct = (ir.headers.get('content-type') || '').split(';')[0], buf = Buffer.from(await ir.arrayBuffer());
        if (/^image\/(jpeg|png|webp)$/.test(ct) && buf.length > 1500 && buf.length <= 60e3) return `data:${ct};base64,${buf.toString('base64')}`;
      } catch { throw new Error('net'); }
    }
  }
  return null;
}
const photo = { running: false, stop: false, done: 0, found: 0, total: 0, error: '' };
async function photoJob() {
  if (photo.running) return; Object.assign(photo, { running: true, stop: false, done: 0, found: 0, error: '' });
  try {
    const todo = db.prepare(`SELECT id,barcode FROM items WHERE active=1 AND (image IS NULL OR image='') AND id NOT IN (SELECT item_id FROM photo_tried) ORDER BY id`).all();
    photo.total = todo.length;
    const extras = db.prepare('SELECT barcode FROM item_barcodes WHERE item_id=?'), mark = db.prepare('INSERT OR REPLACE INTO photo_tried(item_id,at,found) VALUES(?,?,?)');
    for (const it of todo) {
      if (photo.stop) break;
      const codes = [it.barcode, ...extras.all(it.id).map((x) => x.barcode)].filter(validGtin).slice(0, 3); let img = null;
      for (const c of codes) { img = await fetchPhoto(c); await sleep(PHOTO_DELAY); if (img) break; }
      if (img) { db.prepare('UPDATE items SET image=?, updated_at=? WHERE id=?').run(img, now(), it.id); photo.found++; }
      mark.run(it.id, now(), img ? 1 : 0); photo.done++; if (photo.done % 20 === 0) invalidate();
    }
  } catch (e) { photo.error = e.message === 'rate' ? 'The photo database asked us to slow down. It will continue automatically later.' : 'No connection to the photo database. It will try again automatically.'; }
  finally { photo.running = false; invalidate(); }
}
setTimeout(() => { if (getSetting('photo_auto') === '1') photoJob(); }, 20e3);
setInterval(() => { if (getSetting('photo_auto') === '1') photoJob(); }, 3600e3).unref();
route('GET', '/api/admin/photos', 'owner', () => ({ ...photo, missing: db.prepare("SELECT COUNT(*) n FROM items WHERE active=1 AND (image IS NULL OR image='')").get().n,
  with_photo: db.prepare("SELECT COUNT(*) n FROM items WHERE active=1 AND image IS NOT NULL AND image<>''").get().n, no_match: db.prepare('SELECT COUNT(*) n FROM photo_tried WHERE found=0').get().n }));
route('POST', '/api/admin/photos', 'owner', ({ body }) => {
  if (body.action === 'stop') photo.stop = true;
  else { if (body.action === 'retry') db.prepare('DELETE FROM photo_tried WHERE found=0').run(); photoJob(); }
  return { ok: true };
});

// ---------- static + server ----------
const MIME = { '.html': 'text/html; charset=utf-8', '.js': 'text/javascript; charset=utf-8', '.css': 'text/css; charset=utf-8', '.svg': 'image/svg+xml', '.png': 'image/png', '.ico': 'image/x-icon', '.json': 'application/json', '.webmanifest': 'application/manifest+json' };
const PUB = path.join(ROOT, 'public');
function serveStatic(req, res, pathname) {
  let p = pathname === '/' ? '/index.html' : pathname === '/kiosk' ? '/kiosk.html' : pathname === '/shop' || pathname === '/shop/' ? '/shop.html' : pathname;
  const file = path.normalize(path.join(PUB, p));
  if (!file.startsWith(PUB + path.sep) || !fs.existsSync(file) || !fs.statSync(file).isFile()) { res.writeHead(404); return res.end('Not found'); }
  res.writeHead(200, { 'Content-Type': MIME[path.extname(file)] || 'application/octet-stream', 'Cache-Control': 'no-cache' });
  fs.createReadStream(file).pipe(res);
}
const SEC = {
  'X-Content-Type-Options': 'nosniff', 'Referrer-Policy': 'same-origin', 'X-Frame-Options': 'DENY',
  'Permissions-Policy': 'camera=(self), microphone=(self)',
  'Content-Security-Policy': "default-src 'self'; img-src 'self' data: blob:; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src https://fonts.gstatic.com; media-src 'self' blob:; frame-ancestors 'none'",
};
const server = http.createServer(async (req, res) => {
  for (const [k, v] of Object.entries(SEC)) res.setHeader(k, v);
  const url = new URL(req.url, 'http://x');
  const pathname = decodeURIComponent(url.pathname);
  try {
    if (!pathname.startsWith('/api/') && !pathname.startsWith('/img/')) return serveStatic(req, res, pathname);
    for (const r of routes) {
      if (r.method !== req.method) continue;
      const m = r.re.exec(pathname);
      if (!m) continue;
      const user = authUser(req);
      if (r.auth && !user) bad('auth', 401);
      if (r.auth === 'owner' && user.role !== 'owner') bad('forbidden', 403);
      const body = req.method === 'GET' || req.method === 'DELETE' ? {} : await readBody(req);
      const ip = req.headers['cf-connecting-ip'] || req.socket.remoteAddress;
      const out = await r.fn({ req, res, url, m, body, user, ip });
      if (out !== undefined) json(res, 200, out);
      return;
    }
    bad('not_found', 404);
  } catch (e) {
    if (e instanceof HttpError) return json(res, e.code, { error: e.message });
    console.error(e);
    json(res, 500, { error: 'Something went wrong on the server' });
  }
});
server.listen(PORT, () => console.log(`  Eddy OS (${STORE}) -> http://localhost:${PORT}   kiosk -> http://localhost:${PORT}/kiosk`));
