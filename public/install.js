// "Install app" helper: uses the browser's install prompt when it offers one, otherwise shows how to install on this phone.
(() => {
  const standalone = matchMedia('(display-mode: standalone)').matches || navigator.standalone;
  const LS = { get(k) { try { return localStorage.getItem(k); } catch { return null; } }, set(k, v) { try { localStorage.setItem(k, v); } catch { /* ignore */ } } };
  if (standalone) { LS.set('eddy.installed', '1'); return; }
  if (LS.get('eddy.installed') || LS.get('eddy.noinstall')) return;
  const ar = () => document.documentElement.dir === 'rtl' || document.documentElement.lang === 'ar';
  const TX = { en: { btn: 'Install app', title: 'Install on your phone', ok: 'Got it', hide: 'Do not show again', fallback: 'Open your browser menu and choose “Install app” or “Add to Home screen”.',
      samsung: ['Tap the menu button (≡ or ⋮) at the bottom or top right.', 'Tap “Add page to”, then “Home screen” (or “Install app”).', 'Confirm. The icon appears on your home screen.'],
      android: ['Tap the ⋮ menu at the top right.', 'Tap “Install app” or “Add to Home screen”.', 'Confirm. The icon appears on your home screen.'],
      ios: ['Tap the Share button (square with an arrow).', 'Scroll and tap “Add to Home Screen”.', 'Tap Add.'] },
    ar: { btn: 'ثبّت التطبيق', title: 'ثبّت التطبيق على هاتفك', ok: 'حسناً', hide: 'لا تظهر مجدداً', fallback: 'افتح قائمة المتصفح واختر «تثبيت التطبيق» أو «إضافة إلى الشاشة الرئيسية».',
      samsung: ['اضغط زر القائمة (≡ أو ⋮).', 'اضغط «إضافة الصفحة إلى» ثم «الشاشة الرئيسية» (أو «تثبيت التطبيق»).', 'أكّد. تظهر الأيقونة على شاشتك الرئيسية.'],
      android: ['اضغط قائمة ⋮ أعلى اليمين.', 'اضغط «تثبيت التطبيق» أو «إضافة إلى الشاشة الرئيسية».', 'أكّد. تظهر الأيقونة على شاشتك الرئيسية.'],
      ios: ['اضغط زر المشاركة (مربع وسهم).', 'مرّر واضغط «إضافة إلى الشاشة الرئيسية».', 'اضغط إضافة.'] } };
  const ua = navigator.userAgent, kind = /SamsungBrowser/.test(ua) ? 'samsung' : /iPhone|iPad|iPod/.test(ua) ? 'ios' : /Android/.test(ua) ? 'android' : '';
  const css = document.createElement('style');
  css.textContent = `#instbtn{position:fixed;z-index:90;inset-inline-end:14px;bottom:calc(var(--nav,76px) + 84px + env(safe-area-inset-bottom));display:flex;align-items:center;gap:8px;background:#ffd23f;color:#121733;font:600 15px/1 inherit;border:0;border-radius:99px;padding:12px 16px;box-shadow:0 8px 22px rgba(18,23,51,.35);cursor:pointer}
  #instbtn i{font-style:normal;opacity:.55;padding-inline-start:6px;border-inline-start:1px solid rgba(18,23,51,.25)}
  .isheet{position:fixed;inset:0;z-index:200;background:rgba(10,13,32,.55);display:flex;align-items:flex-end;justify-content:center}
  .isheet div{background:#fff;color:#151a33;width:100%;max-width:520px;border-radius:22px 22px 0 0;padding:22px 20px calc(22px + env(safe-area-inset-bottom));font-family:inherit}
  .isheet h3{margin:0 0 12px;font-size:20px}.isheet ol{margin:0 0 16px;padding-inline-start:22px;line-height:1.7}.isheet button{font:inherit;border:0;border-radius:14px;height:48px;padding:0 20px;cursor:pointer}
  .isheet .ok{background:#121733;color:#fff;width:100%;font-weight:600}.isheet .no{background:none;color:#6b7190;width:100%;margin-top:6px;height:40px}`;
  document.head.appendChild(css);
  let dip = null;
  addEventListener('beforeinstallprompt', (e) => { e.preventDefault(); dip = e; });
  addEventListener('appinstalled', () => { LS.set('eddy.installed', '1'); document.getElementById('instbtn')?.remove(); });
  function sheet() {
    const L = TX[ar() ? 'ar' : 'en'], steps = L[kind];
    const o = document.createElement('div'); o.className = 'isheet'; o.setAttribute('role', 'dialog'); o.dir = ar() ? 'rtl' : 'ltr';
    o.innerHTML = `<div><h3>${L.title}</h3>${steps ? `<ol>${steps.map((s) => `<li>${s}</li>`).join('')}</ol>` : `<p>${L.fallback}</p>`}<button class="ok">${L.ok}</button><button class="no">${L.hide}</button></div>`;
    o.addEventListener('click', (e) => { if (e.target === o || e.target.classList.contains('ok')) o.remove(); else if (e.target.classList.contains('no')) { LS.set('eddy.noinstall', '1'); o.remove(); document.getElementById('instbtn')?.remove(); } });
    document.body.appendChild(o);
  }
  function show() {
    if (document.getElementById('instbtn')) return;
    const b = document.createElement('button'); b.id = 'instbtn'; b.type = 'button'; b.innerHTML = `⬇ ${TX[ar() ? 'ar' : 'en'].btn}`;
    b.addEventListener('click', async () => { if (dip) { try { dip.prompt(); await dip.userChoice; } catch { /* ignore */ } dip = null; } else sheet(); });
    document.body.appendChild(b);
  }
  setTimeout(show, 2500);
})();
