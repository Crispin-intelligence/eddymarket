// Update prompt: tells the person when a new version or new product photos are ready and lets them approve with one tap.
(() => {
  const ar = () => document.documentElement.dir === 'rtl' || document.documentElement.lang === 'ar';
  const TX = { en: { ver: 'A new version of Eddy is ready', ph: (n) => `${n} new photo${n === 1 ? '' : 's'} found`, go: 'Update', later: 'Later' },
    ar: { ver: 'يتوفر إصدار جديد من إيدي', ph: (n) => `تم العثور على ${n} صورة جديدة`, go: 'تحديث', later: 'لاحقاً' } };
  let base = null, shown = '', snooze = 0;
  const css = document.createElement('style');
  css.textContent = `#updbar{position:fixed;z-index:300;inset-inline:12px;top:calc(10px + env(safe-area-inset-top));display:flex;align-items:center;gap:10px;background:#121733;color:#fff;border-radius:16px;padding:10px 10px 10px 16px;box-shadow:0 10px 28px rgba(10,13,32,.45);font:600 15px/1.3 inherit}
  #updbar span{flex:1}#updbar button{font:inherit;border:0;border-radius:12px;height:40px;padding:0 16px;cursor:pointer}#updbar .go{background:#ffd23f;color:#121733}#updbar .no{background:none;color:#aab0d0}`;
  document.head.appendChild(css);
  function bar(msg, key) {
    if (shown === key || Date.now() < snooze) return; shown = key; document.getElementById('updbar')?.remove();
    const L = TX[ar() ? 'ar' : 'en'], d = document.createElement('div'); d.id = 'updbar'; d.setAttribute('role', 'status'); d.dir = ar() ? 'rtl' : 'ltr';
    d.innerHTML = `<span>${msg}</span><button class="no">${L.later}</button><button class="go">${L.go}</button>`;
    d.querySelector('.go').onclick = async () => { try { for (const r of await navigator.serviceWorker.getRegistrations()) await r.update(); const ks = await caches.keys(); await Promise.all(ks.map((k) => caches.delete(k))); } catch { /* ignore */ } location.reload(); };
    d.querySelector('.no').onclick = () => { d.remove(); shown = ''; snooze = Date.now() + 10 * 60e3; };
    document.body.appendChild(d);
  }
  async function check() {
    try {
      const v = await (await fetch('/api/version', { cache: 'no-store' })).json(), L = TX[ar() ? 'ar' : 'en'];
      if (!base) { base = v; return; }
      if (v.build !== base.build) bar(L.ver, 'b' + v.build);
      else if (v.photos > base.photos) bar(L.ph(v.photos - base.photos), 'p' + v.photos);
    } catch { /* offline: try again later */ }
  }
  check(); setInterval(check, 60e3);
  document.addEventListener('visibilitychange', () => { if (!document.hidden) check(); });
})();
