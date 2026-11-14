// Power-cut test: a damaged database is set aside and the newest backup is restored automatically on start.
import { spawn } from 'node:child_process'; import fs from 'node:fs'; import os from 'node:os'; import path from 'node:path'; import assert from 'node:assert/strict';
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'eddyr-')); const wait = (ms) => new Promise((r) => setTimeout(r, ms));
const port = 3900 + Math.floor(Math.random() * 90); let pass = 0; const ok = (c, m) => { assert.ok(c, m); pass++; console.log('  ok  ' + m); };
const run = () => { const s = spawn('node', ['--disable-warning=ExperimentalWarning', new URL('../server.js', import.meta.url).pathname], { env: { ...process.env, PORT: port, DATA_DIR: dir, STORE_ID: 'rc', SEED_DEMO: '1', BACKUP_DIR: dir + '/bk' } }); let out = ''; s.stdout.on('data', (d) => (out += d)); s.stderr.on('data', (d) => (out += d)); return { s, get out() { return out; } }; };
const up = async (r) => { for (let n = 0; n < 50; n++) { await wait(150); try { const x = await fetch(`http://localhost:${port}/api/settings`); if (x.ok) return (await x.json()); } catch { /* not yet */ } } throw new Error('no start\n' + r.out); };
let a, b;
try {
  a = run(); await up(a); ok(fs.readdirSync(dir + '/bk').some((n) => n.endsWith('.db')), 'a backup exists after the first start');
  a.s.kill('SIGTERM'); await wait(500);
  fs.writeFileSync(path.join(dir, 'rc.db'), Buffer.alloc(8192, 0x7a)); for (const x of ['-wal', '-shm']) fs.rmSync(path.join(dir, 'rc.db' + x), { force: true }); // simulate damage
  b = run(); const set = await up(b);
  ok(set.store_name && fs.readdirSync(dir).some((n) => n.includes('.corrupt-')), 'damaged database set aside and the app starts again');
  ok(/Restored backup/.test(b.out), 'newest backup restored automatically');
  console.log(`\n${pass} recovery checks passed`);
} catch (e) { console.error('\nFAILED:', e.message); process.exitCode = 1; } finally { a?.s.kill(); b?.s.kill(); fs.rmSync(dir, { recursive: true, force: true }); }
