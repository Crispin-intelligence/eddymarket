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
const DEFAULTS = { store_name: 'Eddy Market', rate: '90000', footer: 'Thank you for shopping with us', tz: 'Asia/Beirut' };
const getSetting = (k) => db.prepare('SELECT value FROM settings WHERE key=?').get(k)?.value ?? DEFAULTS[k];
const setSetting = (k, v) => db.prepare('INSERT INTO settings(key,value) VALUES(?,?) ON CONFLICT(key) DO UPDATE SET value=excluded.value').run(k, String(v));
const publicSettings = () => ({ store_name: getSetting('store_name'), rate: +getSetting('rate'), footer: getSetting('footer'), tz: getSetting('tz'), store_id: STORE, print_mode: getSetting('print_mode') || 'browser', print_auto: getSetting('print_auto') === '1', print_drawer: getSetting('print_drawer') === '1' });

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
const norm = (s) => String(s ?? '').toLowerCase()
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
  return cache;
}
function search(q, { loose = false, category = '', limit = 60, offset = 0 } = {}) {
  let list = loadCache();
  if (category) list = list.filter((i) => i.category === category);
  const tokens = norm(q).split(' ').filter(Boolean);
  let out = list;
  if (tokens.length) {
    const need = loose ? 1 : tokens.length;
    out = [];
    for (const i of list) {
      const score = tokens.reduce((n, t) => n + (i.h.includes(t) ? 1 : 0), 0);
      if (score >= need) out.push({ i, score });
    }
    out.sort((a, b) => b.score - a.score || a.i.name.length - b.i.name.length);
    out = out.map((x) => x.i);
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

// ---------- static + server ----------
const MIME = { '.html': 'text/html; charset=utf-8', '.js': 'text/javascript; charset=utf-8', '.css': 'text/css; charset=utf-8', '.svg': 'image/svg+xml', '.png': 'image/png', '.ico': 'image/x-icon', '.json': 'application/json', '.webmanifest': 'application/manifest+json' };
const PUB = path.join(ROOT, 'public');
function serveStatic(req, res, pathname) {
  let p = pathname === '/' ? '/index.html' : pathname === '/kiosk' ? '/kiosk.html' : pathname;
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
