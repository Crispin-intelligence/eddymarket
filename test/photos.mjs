// Photo finder test: a fake "open product database" on localhost; checks barcode filtering, matching and storage.
import { spawn } from 'node:child_process'; import http from 'node:http'; import fs from 'node:fs'; import os from 'node:os'; import path from 'node:path'; import assert from 'node:assert/strict';
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'eddyp-')); const wait = (ms) => new Promise((r) => setTimeout(r, ms)); let hits = [];
const jpg = Buffer.concat([Buffer.from([0xff, 0xd8, 0xff]), Buffer.alloc(3000, 7)]);
const fake = http.createServer((q, r) => {
  if (q.url.startsWith('/api/v2/product/')) { const c = q.url.split('/').pop().split('.')[0]; hits.push(c); r.setHeader('content-type', 'application/json'); return r.end(JSON.stringify(c === '5287000107013' ? { status: 1, product: { image_front_url: `http://127.0.0.1:${fake.address().port}/p.jpg` } } : { status: 0 })); }
  if (q.url === '/p.jpg') { r.setHeader('content-type', 'image/jpeg'); return r.end(jpg); }
  r.statusCode = 404; r.end();
}); await new Promise((r) => fake.listen(0, '127.0.0.1', r));
const port = 3600 + Math.floor(Math.random() * 300);
const srv = spawn('node', ['--disable-warning=ExperimentalWarning', new URL('../server.js', import.meta.url).pathname], { env: { ...process.env, PORT: port, DATA_DIR: dir, STORE_ID: 'ph', SEED_DEMO: '0', BACKUP_DIR: dir + '/bk', PHOTO_BASE: `http://127.0.0.1:${fake.address().port}`, PHOTO_DELAY: '0', SHOP_WA: '81 852 775' } });
let out = ''; srv.stdout.on('data', (d) => (out += d)); srv.stderr.on('data', (d) => (out += d));
const base = `http://localhost:${port}`; const call = async (p, o = {}, t) => { const r = await fetch(base + p, { method: o.method || 'GET', headers: { 'Content-Type': 'application/json', ...(t ? { Authorization: 'Bearer ' + t } : {}) }, body: o.body ? JSON.stringify(o.body) : undefined }); return { s: r.status, j: await r.json().catch(() => ({})) }; };
let pass = 0; const ok = (c, m) => { assert.ok(c, m); pass++; console.log('  ok  ' + m); };
try {
  for (let n = 0; n < 40 && !out.includes('Eddy OS'); n++) await wait(150);
  const pin = fs.readFileSync(path.join(dir, 'ph.owner-pin.txt'), 'utf8').trim(); const u = (await call('/api/users')).j[0];
  const tok = (await call('/api/login', { method: 'POST', body: { user_id: u.id, pin } })).j.token;
  ok((await call('/api/shop/home')).j.wa === '96181852775', 'store WhatsApp number can be preset from the environment');
  const mk = (barcode, name) => ({ barcode, name, category: 'snacks', price_usd: 1, cost_usd: 0.5, stock: 1, min_stock: 0, unit: 'pc' });
  await call('/api/items/import', { method: 'POST', body: { rows: [mk('5287000107013', 'cedars adim blue'), mk('1349', 'internal item'), mk('5287000107014', 'bad checksum'), mk('2000000000017', 'in-store code'), mk('6221134013054', 'valid but unknown')] } }, tok);
  ok((await call('/api/admin/photos', { method: 'POST', body: { action: 'start' } }, tok)).s === 200, 'owner starts the photo finder');
  let st; for (let n = 0; n < 40; n++) { await wait(150); st = (await call('/api/admin/photos', {}, tok)).j; if (!st.running && st.done > 0) break; }
  ok(st.found === 1 && st.with_photo === 1 && st.missing === 4, 'one item got a photo, the rest still have none');
  ok(hits.includes('5287000107013') && hits.includes('6221134013054') && !hits.includes('1349') && !hits.includes('5287000107014') && !hits.includes('2000000000017'), 'only real barcodes with a valid check digit were looked up');
  const it = (await call('/api/items?q=cedars', {}, tok)).j.items[0]; const img = await fetch(`${base}/img/${it.id}`); ok(img.status === 200 && img.headers.get('content-type') === 'image/jpeg', 'the photo is served for the item');
  const n1 = hits.length; await call('/api/admin/photos', { method: 'POST', body: { action: 'start' } }, tok); await wait(500); ok(hits.length === n1, 'items already searched are not searched again');
  await call('/api/admin/photos', { method: 'POST', body: { action: 'retry' } }, tok); await wait(600); ok(hits.length > n1, '"search again" retries the ones with no match');
  console.log(`\n${pass} photo checks passed`);
} catch (e) { console.error('\nFAILED:', e.message, '\n', out.slice(-500)); process.exitCode = 1; } finally { srv.kill(); fake.close(); fs.rmSync(dir, { recursive: true, force: true }); }
