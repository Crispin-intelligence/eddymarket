// Customer price screen: scan, speak or type. Public and read-only: it never shows cost or stock.
(() => {
  const I = window.I18N, t = (k, v) => I.t(k, v);
  const $ = (s) => document.querySelector(s);
  const esc = (s) => String(s ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
  let store = 'Eddy Market', resetTimer, rec = null, stream = null, camTimer = null;
  const FILLER = new Set(['how', 'much', 'is', 'the', 'price', 'of', 'for', 'a', 'an', 'what', 'whats', "what's", 'does', 'cost', 'costs', 'do', 'you', 'have', 'i', 'want', 'need', 'please', 'are', 'this', 'that', 'كم', 'سعر', 'بكم', 'شو', 'ما', 'هو', 'هل', 'عندكم', 'عندك', 'بدي', 'لو', 'سمحت', 'ثمن', 'تمن', 'قديش', 'أريد', 'اريد', 'هذا', 'هاد', 'هيدا']);
  const stripFiller = (s) => { const w = s.split(/\s+/).filter((x) => !FILLER.has(x.toLowerCase())); return w.length ? w.join(' ') : s; };
  const pic = (i) => i.has_image ? `<img src="/img/${i.id}?v=${encodeURIComponent(i.v)}" alt="">` : I.catIcon(i.category);

  function paint() {
    $('#kstore').textContent = store;
    $('#klang').textContent = I.lang === 'ar' ? 'English' : 'العربية';
    $('#kq').placeholder = t('search_kiosk');
    $('#kmic').innerHTML = `🎤 ${t('say_item')}`;
    $('#kcam').innerHTML = `📷 ${t('scan_cam')}`;
  }
  function idle() {
    clearTimeout(resetTimer);
    $('#stage').innerHTML = `<div class="k-idle"><div class="k-hang"></div><span class="tag" style="font-size:clamp(34px,6vw,70px)">${esc(store)}</span><h1 style="margin-top:28px">${t('kiosk_title')}</h1><p>${t('kiosk_hint')}</p><div class="k-try" id="ktry"></div></div>`;
    fetch('/api/kiosk/featured').then((r) => r.json()).then((list) => { const box = $('#ktry'); if (!box || !Array.isArray(list)) return; box.innerHTML = list.map((i) => `<button type="button" data-id="${i.id}"><span class="th">${pic(i)}</span><span>${esc(I.itemName(i))}</span></button>`).join(''); box.querySelectorAll('button').forEach((b) => b.addEventListener('click', () => showItem(list.find((x) => x.id === +b.dataset.id)))); }).catch(() => {});
  }
  const armReset = () => { clearTimeout(resetTimer); resetTimer = setTimeout(idle, 25000); };
  function showItem(i) {
    const per = i.unit === 'kg' ? `<small>/${t('kg')}</small>` : '';
    $('#stage').innerHTML = `<div class="k-result"><div class="k-pic">${pic(i)}</div><div class="k-info"><div class="cat">${esc(I.catIcon(i.category))} ${esc(I.catName(i.category))}</div>
      <h2>${esc(I.itemName(i))}</h2><div class="alt">${esc(I.itemName2(i))}</div>
      <span class="tag stack"><span class="usd num">${I.usd(i.price_cents)}${per}</span><span class="lbp num">${I.ll(i.price_ll)}${per}</span></span></div></div>`;
    armReset();
  }
  function showList(list) {
    $('#stage').innerHTML = `<div class="k-list"><h3>${t('choose')}</h3>${list.map((i) => `<button data-id="${i.id}"><span>${esc(I.catIcon(i.category))} ${esc(I.itemName(i))}</span><span class="tag"><span class="num">${I.usd(i.price_cents)}</span></span></button>`).join('')}</div>`;
    $('#stage').querySelectorAll('button').forEach((b) => b.addEventListener('click', () => showItem(list.find((x) => x.id === +b.dataset.id))));
    armReset();
  }
  function message(key) { $('#stage').innerHTML = `<div class="k-msg" role="alert">${t(key)}</div>`; armReset(); }

  async function lookup(raw) {
    let v = String(raw || '').trim(); if (!v) return;
    v = v.replace(/[٠-٩]/g, (d) => '٠١٢٣٤٥٦٧٨٩'.indexOf(d));
    try {
      if (/^\d{6,}$/.test(v)) {
        const r = await fetch('/api/kiosk/lookup?barcode=' + encodeURIComponent(v));
        if (r.ok) return showItem(await r.json());
        return message('no_match');
      }
      const r = await fetch('/api/kiosk/search?q=' + encodeURIComponent(stripFiller(v)));
      const list = await r.json();
      if (!list.length) return message('no_match');
      list.length === 1 ? showItem(list[0]) : showList(list);
    } catch { message('offline'); }
  }

  // ---- voice ----
  function stopMic() { if (rec) { try { rec.stop(); } catch { /* already stopped */ } } rec = null; $('#kmic').classList.remove('live'); $('#kmic').innerHTML = `🎤 ${t('say_item')}`; }
  function startMic() {
    const SR = window.SpeechRecognition || window.webkitSpeechRecognition;
    if (!SR) return message('mic_unsupported');
    if (rec) return stopMic();
    rec = new SR(); rec.lang = I.lang === 'ar' ? 'ar-LB' : 'en-US'; rec.interimResults = false; rec.maxAlternatives = 3;
    let got = false;
    rec.onresult = (e) => { got = true; const txt = e.results[0][0].transcript; $('#kq').value = txt; lookup(txt); };
    rec.onerror = () => { if (!got) message('not_heard'); };
    rec.onend = () => { if (!got && rec) message('not_heard'); stopMic(); };
    $('#kmic').classList.add('live'); $('#kmic').innerHTML = `🔴 ${t('listening')}`;
    try { rec.start(); } catch { stopMic(); }
  }

  // ---- camera barcode ----
  function closeCam() { clearInterval(camTimer); if (stream) stream.getTracks().forEach((x) => x.stop()); stream = null; $('#camlayer').innerHTML = ''; }
  async function openCam() {
    if (!('BarcodeDetector' in window) || !navigator.mediaDevices?.getUserMedia) return message('cam_unsupported');
    $('#camlayer').innerHTML = `<div class="cam"><div class="in"><div class="frame"><video id="cv" playsinline muted></video></div><div class="k-msg" style="font-size:22px">${t('point_cam')}</div><button class="btn" id="cclose">${t('close')}</button></div></div>`;
    $('#cclose').addEventListener('click', closeCam);
    try {
      stream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' } });
      const v = $('#cv'); v.srcObject = stream; await v.play();
      const det = new BarcodeDetector({ formats: ['ean_13', 'ean_8', 'upc_a', 'upc_e', 'code_128', 'code_39'] });
      camTimer = setInterval(async () => {
        try { const found = await det.detect(v); if (found[0]) { const code = found[0].rawValue; closeCam(); $('#kq').value = code; lookup(code); } } catch { /* frame not ready */ }
      }, 250);
    } catch { closeCam(); message('cam_denied'); }
  }

  // ---- wiring ----
  $('#kform').addEventListener('submit', (e) => { e.preventDefault(); const v = $('#kq').value; lookup(v); $('#kq').select(); });
  $('#kmic').addEventListener('click', startMic);
  $('#kcam').addEventListener('click', openCam);
  $('#klang').addEventListener('click', () => { I.setLang(I.lang === 'ar' ? 'en' : 'ar'); stopMic(); paint(); idle(); });
  // a hardware scanner types into the page: always route it to the box
  document.addEventListener('keydown', (e) => { if (e.key === 'Escape') { closeCam(); idle(); return; } if (e.target.id !== 'kq' && e.key.length === 1 && !e.ctrlKey && !e.metaKey) $('#kq').focus(); });
  fetch('/api/settings').then((r) => r.json()).then((s) => { store = s.store_name; paint(); idle(); }).catch(() => { paint(); idle(); });
  paint(); idle(); $('#kq').focus();
})();
