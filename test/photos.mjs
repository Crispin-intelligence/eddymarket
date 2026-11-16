// Photo finder test: a fake "open product database" on localhost; checks barcode filtering, matching and storage.
import { spawn, execFileSync } from 'node:child_process';
import { fileURLToPath } from 'node:url'; import http from 'node:http'; import fs from 'node:fs'; import os from 'node:os'; import path from 'node:path'; import assert from 'node:assert/strict';
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'eddyp-')); const wait = (ms) => new Promise((r) => setTimeout(r, ms)); let hits = [];
const mkimg = (col) => execFileSync('convert', ['-size', '900x1100', `gradient:${col}`, '-attenuate', '0.3', '+noise', 'Gaussian', '-quality', '90', 'jpeg:-'], { maxBuffer: 20e6 });
const small = (b) => execFileSync('convert', ['-', '-resize', '240x', 'jpeg:-'], { input: b });
const jpg = mkimg('#2255aa-#99bbee'), handjpg = mkimg('#d9a384-#e8b89a'); // a clean blue pack shot, and a skin-coloured "hand" shot
const fake = http.createServer((q, r) => {
  if (q.url.startsWith('/api/v2/product/')) { const c = q.url.split('/').pop().split('.')[0]; hits.push(c); r.setHeader('content-type', 'application/json'); return r.end(JSON.stringify(c === '5287000107013' ? { status: 1, product: { brands: 'Cedars', product_name: 'Cedars Adim Blue', image_front_url: `http://127.0.0.1:${fake.address().port}/p.jpg` } } : { status: 0 })); }
  if (q.url.startsWith('/cgi/search.pl')) { const s = decodeURIComponent(q.url.split('search_terms=')[1].split('&')[0]); r.setHeader('content-type', 'application/json'); const P = `http://127.0.0.1:${fake.address().port}/p.jpg`, H = `http://127.0.0.1:${fake.address().port}/hand.jpg`;
    const L = s.startsWith('almaza') ? [{ brands: 'Almaza', product_name: 'Almaza Beer Classic', image_front_url: P }, { brands: 'Other', product_name: 'Unrelated juice', image_front_url: P }]
      : s === 'black label' ? [{ brands: 'Hormel', product_name: 'Black Label Bacon', quantity: '16 oz', image_front_url: P }]
      : s.startsWith('johnnie') ? [{ brands: 'Johnnie Walker', product_name: 'Black Label Scotch Whisky', quantity: '750 ml', image_front_url: P }]
      : s.startsWith('hand soap') ? [{ brands: 'Hand', product_name: 'Hand Soap Bar', image_front_url: H }]
      : [{ brands: 'Other', product_name: 'Unrelated juice', image_front_url: P }];
    return r.end(JSON.stringify({ products: L })); }
  if (q.url === '/images') { const P = `http://127.0.0.1:${fake.address().port}/p.jpg`; let b = ''; q.on('data', (d) => (b += d)); return q.on('end', () => { r.setHeader('content-type', 'application/json'); r.end(JSON.stringify({ images: JSON.parse(b).q.startsWith('tiger') ? [{ title: 'Tiger Balm Red 30g', imageUrl: P, imageWidth: 900, imageHeight: 1100, source: 'shop' }] : [] })); }); }
  if (q.url === '/hand.jpg') { r.setHeader('content-type', 'image/jpeg'); return r.end(handjpg); }
  if (q.url === '/p.jpg') { r.setHeader('content-type', 'image/jpeg'); return r.end(jpg); }
  r.statusCode = 404; r.end();
}); await new Promise((r) => fake.listen(0, '127.0.0.1', r));
const port = 3600 + Math.floor(Math.random() * 300);
const srv = spawn(process.execPath, ['--disable-warning=ExperimentalWarning', fileURLToPath(new URL('../server.js', import.meta.url))], { env: { ...process.env, PORT: port, DATA_DIR: dir, STORE_ID: 'ph', SEED_DEMO: '0', BACKUP_DIR: dir + '/bk', SERPER_KEY: 'k', PHOTO_SERPER_BASE: `http://127.0.0.1:${fake.address().port}`, PHOTO_BASE: `http://127.0.0.1:${fake.address().port}`, PHOTO_DELAY: '0', SHOP_WA: '81 852 775' } });
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
  await call('/api/items/import', { method: 'POST', body: { rows: [mk('7771', 'almaza beer classic'), mk('7772', 'zorba falafel mix')] } }, tok);
  await call('/api/admin/photos', { method: 'POST', body: { action: 'start' } }, tok); await wait(1000);
  const al = (await call('/api/items?q=almaza', {}, tok)).j.items[0], zo = (await call('/api/items?q=zorba', {}, tok)).j.items[0];
  ok(al.has_image && !zo.has_image, 'name fallback adds a photo only when name and brand clearly match');
  const need = (await call('/api/admin/photos/needed', {}, tok)).j.items; ok(need.some((x) => x.id === zo.id) && !need.some((x) => x.id === al.id), 'items without photo are listed for quick snapping');
  const up = await call(`/api/items/${zo.id}/photo`, { method: 'POST', body: { image: 'data:image/jpeg;base64,' + small(jpg).toString('base64') } }, tok);
  ok(up.s === 200 && (await call('/api/items?q=zorba', {}, tok)).j.items[0].has_image, 'a snapped photo is saved for the item');
  ok((await call(`/api/items/${zo.id}/photo`, { method: 'POST', body: { image: 'nope' } }, tok)).s === 400, 'bad photo data is rejected');
  const fnd = (await call('/api/admin/photos/found', {}, tok)).j.items; ok(fnd.some((x) => x.id === al.id) && !fnd.some((x) => x.id === zo.id), 'review list shows auto-found photos only');
  ok((await call(`/api/items/${al.id}/photo/reject`, { method: 'POST' }, tok)).s === 200 && !(await call('/api/items?q=almaza', {}, tok)).j.items[0].has_image, 'a rejected photo is removed');
  await call('/api/admin/photos', { method: 'POST', body: { action: 'start' } }, tok); await wait(600); ok(!(await call('/api/items?q=almaza', {}, tok)).j.items[0].has_image, 'a rejected photo is not searched again');
  await call('/api/items/import', { method: 'POST', body: { rows: [mk('8881', 'black label 75cl'), mk('8882', 'johnnie walker black label 75cl'), mk('8883', 'hand soap bar')] } }, tok);
  await call('/api/admin/photos', { method: 'POST', body: { action: 'start' } }, tok); await wait(1500);
  const bl = (await call('/api/items?q=black label 75', {}, tok)).j.items.find((x) => x.name === 'black label 75cl'), jw = (await call('/api/items?q=johnnie', {}, tok)).j.items[0], hs = (await call('/api/items?q=hand soap', {}, tok)).j.items[0];
  ok(!bl.has_image, 'a product with the wrong size and type (bacon 16 oz vs 75cl) is never used');
  ok(jw.has_image, 'the matching product with the same size (750 ml) gets its photo');
  ok(!hs.has_image, 'a photo with a hand in it is rejected');
  const jr = await fetch(`${base}/img/${jw.id}`), jb = Buffer.from(await jr.arrayBuffer()); ok(jr.headers.get('content-type') === 'image/jpeg' && jb.length > 1500, 'stored photo is a clean JPEG');
  await call('/api/items/import', { method: 'POST', body: { rows: [mk('8884', 'tiger balm red 30g')] } }, tok); await call('/api/admin/photos', { method: 'POST', body: { action: 'start' } }, tok); await wait(1200);
  ok((await call('/api/items?q=tiger', {}, tok)).j.items[0].has_image, 'Google Images via Serper (when a key is set) supplies an HD photo that matches the name and size');
  console.log(`\n${pass} photo checks passed`);
} catch (e) { console.error('\nFAILED:', e.message, '\n', out.slice(-500)); process.exitCode = 1; } finally { srv.kill(); fake.close(); fs.rmSync(dir, { recursive: true, force: true }); }
