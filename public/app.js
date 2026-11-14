(() => {
  const I = window.I18N, t = (k, v) => I.t(k, v);
  const $ = (s, el = document) => el.querySelector(s);
  const esc = (s) => String(s ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
  const SS = { get: (k) => { try { return sessionStorage.getItem(k); } catch { return null; } }, set: (k, v) => { try { sessionStorage.setItem(k, v); } catch { /* storage may be blocked */ } }, del: (k) => { try { sessionStorage.removeItem(k); } catch { /* ignore */ } } };
  const S = { token: SS.get('tok') || '', user: null, set: { store_name: 'Eddy Market', rate: 90000, tz: 'Asia/Beirut' }, view: 'sell',
    cart: [], cat: '', q: '', items: [], total: 0, cats: [], seq: 0, pay: null, itemQ: '', pinUser: null, pin: '' };
  const isOwner = () => S.user?.role === 'owner';
  const toLL = (c) => Math.round((c / 100) * S.set.rate / 1000) * 1000;
  const lineCents = (l) => Math.round(l.qty * l.price_cents);
  const cartCents = () => S.cart.reduce((a, l) => a + lineCents(l), 0);
  const num = (v) => { const n = Number(v); return Number.isFinite(n) ? n : 0; };

  // ---------- plumbing ----------
  async function api(path, o = {}) {
    let r;
    try {
      r = await fetch(path, { method: o.method || 'GET', headers: { 'Content-Type': 'application/json', ...(S.token ? { Authorization: 'Bearer ' + S.token } : {}) }, body: o.body ? JSON.stringify(o.body) : undefined });
    } catch { throw new Error(t('offline')); }
    if (r.status === 401 && S.token && path !== '/api/login') { signedOut(); throw new Error('auth'); }
    const j = await r.json().catch(() => ({}));
    if (!r.ok) { const e = new Error(j.error || t('error')); e.code = r.status; throw e; }
    return j;
  }
  let toastTimer;
  function toast(msg, err) {
    document.querySelectorAll('.toast').forEach((x) => x.remove());
    const d = document.createElement('div'); d.className = 'toast' + (err ? ' err' : ''); d.textContent = msg; d.setAttribute('role', 'status');
    document.body.appendChild(d); clearTimeout(toastTimer); toastTimer = setTimeout(() => d.remove(), 3200);
  }
  const fail = (e) => { if (e.message !== 'auth') toast(t(e.message), true); };
  function beep() {
    try {
      const c = beep.c || (beep.c = new (window.AudioContext || window.webkitAudioContext)()); const o = c.createOscillator(), g = c.createGain();
      o.frequency.value = 1040; g.gain.value = 0.06; o.connect(g); g.connect(c.destination); o.start(); o.stop(c.currentTime + 0.07);
    } catch { /* sound is optional */ }
  }
  function modal(html, wide) {
    $('#modal').innerHTML = `<div class="modal-bg"><div class="modal${wide ? ' wide' : ''}" role="dialog" aria-modal="true">${html}</div></div>`;
    const f = $('#modal input:not([type=file]), #modal button.pri'); if (f) f.focus();
  }
  const closeModal = () => { $('#modal').innerHTML = ''; if (S.view === 'sell') $('#q')?.focus(); };
  const dateFmt = (iso) => new Date(iso).toLocaleString(I.lang === 'ar' ? 'ar-LB-u-nu-latn' : 'en-GB', { timeZone: S.set.tz, dateStyle: 'medium', timeStyle: 'short' });
  const tagHtml = (cents, cls = '') => `<span class="tag ${cls}"><span class="num">${I.usd(cents)}</span></span>`;
  const IC = {
    sell: '<path d="M3 4h2.2l2.3 10.2h9.4l2.1-7.6H6.3"/><circle cx="9" cy="19" r="1.4"/><circle cx="17" cy="19" r="1.4"/>',
    items: '<path d="M3.5 7.5 12 3l8.5 4.5v9L12 21l-8.5-4.5z"/><path d="M3.5 7.5 12 12l8.5-4.5M12 12v9"/>',
    sales: '<path d="M6 3h12v18l-3-2-3 2-3-2-3 2z"/><path d="M9 8h6M9 12h6"/>',
    dashboard: '<path d="M4 20V10M10 20V4M16 20v-7M22 20H2"/>',
    settings: '<circle cx="12" cy="12" r="3"/><path d="M12 2v3M12 19v3M2 12h3M19 12h3M5 5l2 2M17 17l2 2M19 5l-2 2M7 17l-2 2"/>',
    kiosk: '<rect x="3" y="4" width="18" height="12" rx="2"/><path d="M8 20h8M12 16v4"/>',
    lang: '<circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3c3 3 3 15 0 18M12 3c-3 3-3 15 0 18"/>',
    out: '<path d="M9 4H5v16h4M16 8l4 4-4 4M20 12H9"/>',
  };
  const icon = (n) => `<svg viewBox="0 0 24 24" aria-hidden="true">${IC[n]}</svg>`;

  // ---------- login ----------
  async function renderLogin() {
    $('#root').innerHTML = `<div class="login"><div class="lang"><button data-act="lang">${I.lang === 'ar' ? 'English' : 'العربية'}</button></div><div class="box" id="lbox"></div></div>`;
    try {
      const [users, set] = await Promise.all([api('/api/users'), api('/api/settings')]);
      S.set = set; S.users = users; drawLogin();
    } catch (e) { $('#lbox').innerHTML = `<h1>${esc(e.message)}</h1>`; }
  }
  function drawLogin(err) {
    const head = `<span class="tag">${esc(S.set.store_name)}</span>`;
    if (!S.pinUser) {
      $('#lbox').innerHTML = `${head}<h1>${t('login_title')}</h1><div class="users">${S.users.map((u) => `<button data-act="pickuser" data-id="${u.id}">${esc(u.name)}</button>`).join('')}</div><div class="by">${t('powered')}</div>`;
      return;
    }
    const dots = Array.from({ length: Math.max(4, S.pin.length) }, (_, n) => `<i class="${n < S.pin.length ? 'f' : ''}"></i>`).join('');
    $('#lbox').innerHTML = `${head}<h1>${esc(S.pinUser.name)}</h1><div class="dots" aria-hidden="true">${dots}</div><div class="err" role="alert">${esc(err || '')}</div>
      <div class="pad">${[1, 2, 3, 4, 5, 6, 7, 8, 9].map((n) => `<button data-act="pin" data-d="${n}">${n}</button>`).join('')}<button data-act="pinback" aria-label="Back">⌫</button><button data-act="pin" data-d="0">0</button><button data-act="pinok" aria-label="OK">✓</button></div>
      <button class="lnk" data-act="changeuser">${t('login_title')}</button>`;
  }
  async function submitPin() {
    if (S.pin.length < 4) return;
    try {
      const r = await api('/api/login', { method: 'POST', body: { user_id: S.pinUser.id, pin: S.pin } });
      S.token = r.token; S.user = r.user; SS.set('tok', r.token); S.pin = ''; S.pinUser = null; S.view = 'sell'; S.cart = [];
      S.set = await api('/api/settings'); render();
    } catch (e) { S.pin = ''; drawLogin(e.code === 429 ? t('locked') : t('wrong_pin')); }
  }
  function signedOut() { S.token = ''; S.user = null; SS.del('tok'); S.cart = []; S.pin = ''; S.pinUser = null; renderLogin(); }

  // ---------- shell ----------
  function render() { if (!S.user) return renderLogin(); renderShell(); }
  function renderShell() {
    const nav = [['sell', 'sell'], ['items', 'items'], ['sales', 'sales']];
    if (isOwner()) nav.push(['dashboard', 'dashboard'], ['settings', 'settings']);
    $('#root').innerHTML = `<div id="app"><nav class="rail" aria-label="Main">
      <div class="brand"><span class="tag">E</span></div>
      ${nav.map(([v, ic]) => `<button data-act="nav" data-v="${v}" class="${S.view === v ? 'on' : ''}">${icon(ic)}<span>${t(v)}</span></button>`).join('')}
      <a href="/kiosk" target="_blank" rel="noopener">${icon('kiosk')}<span>${t('kiosk')}</span></a>
      <span class="grow"></span>
      <button data-act="lang">${icon('lang')}<span>${I.lang === 'ar' ? 'EN' : 'عربي'}</span></button>
      <button data-act="logout">${icon('out')}<span>${t('logout')}</span></button></nav>
      <main class="main" id="view"></main></div>`;
    renderView();
  }
  function renderView() {
    ({ sell: viewSell, items: viewItems, sales: viewSales, dashboard: viewDash, settings: viewSettings }[S.view] || viewSell)();
  }

  // ---------- sell ----------
  async function viewSell() {
    $('#view').innerHTML = `<div class="sell"><section class="catalog">
      <div class="topbar"><h1>${t('sell')}</h1><span class="sp"></span><span class="who">${esc(S.user.name)}</span></div>
      <div class="search"><input id="q" type="search" autocomplete="off" placeholder="${esc(t('search_ph'))}" value="${esc(S.q)}" aria-label="${esc(t('search_ph'))}"></div>
      <div class="chips" id="chips"></div><div class="scroll"><div class="tiles" id="tiles"></div><div id="more"></div></div></section>
      <aside class="receipt" aria-label="${esc(t('cart'))}"><header><h2>${t('cart')}</h2><button class="btn sm" data-act="clear">${t('clear')}</button></header>
      <div class="lines" id="lines"></div><footer id="cfoot"></footer></aside></div>`;
    drawCart();
    try { S.cats = await api('/api/categories'); } catch (e) { fail(e); }
    drawChips(); loadCatalog();
    $('#q').focus();
  }
  function drawChips() {
    $('#chips').innerHTML = `<button class="chip ${S.cat ? '' : 'on'}" data-act="cat" data-c="">${t('all')}</button>` +
      S.cats.map((c) => `<button class="chip ${S.cat === c.category ? 'on' : ''}" data-act="cat" data-c="${esc(c.category)}">${I.catIcon(c.category)} ${esc(I.catName(c.category))}</button>`).join('');
  }
  async function loadCatalog(append) {
    const my = ++S.seq;
    try {
      const p = new URLSearchParams({ q: S.q, category: S.cat, limit: 60, offset: append ? S.items.length : 0 });
      const r = await api('/api/items?' + p);
      if (my !== S.seq) return;
      S.total = r.total; S.items = append ? S.items.concat(r.items) : r.items; drawTiles();
    } catch (e) { fail(e); }
  }
  function pic(i) { return i.has_image ? `<img src="/img/${i.id}?v=${encodeURIComponent(i.v)}" alt="" loading="lazy">` : I.catIcon(i.category); }
  function drawTiles() {
    const el = $('#tiles'); if (!el) return;
    el.innerHTML = S.items.length ? S.items.map((i) => {
      const low = i.min_stock > 0 && i.stock > 0 && i.stock <= i.min_stock ? `<div class="low">${i.stock} ${t('low_label')}</div>` : '';
      return `<button class="tile" data-act="add" data-id="${i.id}"><div class="pic">${pic(i)}</div><div class="nm">${esc(I.itemName(i))}</div>${low}<div class="pr"><span class="tag"><span class="num">${I.usd(i.price_cents)}</span>${i.unit === 'kg' ? `<small>/${t('kg')}</small>` : ''}</span></div></button>`;
    }).join('') : `<div class="empty" style="grid-column:1/-1">${t('no_items')}</div>`;
    $('#more').innerHTML = S.total > S.items.length ? `<button class="btn" data-act="more" style="margin-top:12px">${t('load_more')}</button>` : '';
  }
  function addToCart(i, qty = 1) {
    const l = S.cart.find((x) => x.id === i.id);
    if (l) l.qty = Math.round((l.qty + qty) * 1000) / 1000;
    else S.cart.push({ id: i.id, barcode: i.barcode, name: i.name, name_ar: i.name_ar, price_cents: i.price_cents, unit: i.unit, qty });
    beep(); drawCart();
    const ln = $('#lines'); if (ln) ln.scrollTop = ln.scrollHeight;
  }
  function drawCart() {
    const ln = $('#lines'); if (!ln) return;
    ln.innerHTML = S.cart.length ? S.cart.map((l, n) => `<div class="line"><div><div class="nm">${esc(I.itemName(l))}</div>
      <div class="sub">${I.usd(l.price_cents)}${l.unit === 'kg' ? '/' + t('kg') : ''}</div></div><button class="x" data-act="del" data-n="${n}" aria-label="${esc(t('remove'))}">✕</button>
      <div class="qty"><button data-act="dec" data-n="${n}" aria-label="-">−</button><input type="number" min="0" step="any" inputmode="decimal" value="${l.qty}" data-act="setqty" data-n="${n}" aria-label="${esc(t('qty'))}"><button data-act="inc" data-n="${n}" aria-label="+">+</button></div>
      <div class="amt num">${I.usd(lineCents(l))}</div></div>`).join('') : `<div class="empty">${t('cart_empty')}</div>`;
    const c = cartCents();
    $('#cfoot').innerHTML = `<div class="totalrow"><span>${t('total')}</span>${tagHtml(c)}</div><div class="ll num" style="text-align:end">${I.ll(toLL(c))}</div>
      <button class="btn pri big" data-act="pay" ${S.cart.length ? '' : 'disabled'}>${t('pay')}</button>`;
  }
  async function scanSubmit(v) {
    v = v.trim(); if (!v) return;
    if (/^[\d٠-٩]{6,}$/.test(v)) {
      try {
        const i = await api('/api/items/barcode/' + encodeURIComponent(v.replace(/[٠-٩]/g, (d) => '٠١٢٣٤٥٦٧٨٩'.indexOf(d))));
        addToCart(i); S.q = ''; $('#q').value = ''; loadCatalog(); return;
      } catch (e) { if (e.code === 404) { toast(t('not_found'), true); $('#q').select(); } else fail(e); return; }
    }
    if (S.items.length === 1) { addToCart(S.items[0]); S.q = ''; $('#q').value = ''; loadCatalog(); }
  }

  // ---------- payment + receipt ----------
  function openPay() {
    if (!S.cart.length) return;
    S.pay = { method: 'cash', cur: 'USD', tendered: '' }; drawPay();
  }
  function drawPay() {
    const c = cartCents(), p = S.pay, ll = toLL(c);
    let quick;
    if (p.cur === 'USD') quick = [c / 100, ...[1, 5, 10, 20, 50, 100].filter((v) => v >= c / 100).slice(0, 3)];
    else quick = [ll, ...[50000, 100000, 200000, 500000, 1000000].filter((v) => v >= ll).slice(0, 3)];
    const showQ = p.method === 'cash';
    modal(`<h2>${t('pay')}</h2><div class="totalrow" style="margin-bottom:14px"><span>${t('total')}</span>${tagHtml(c)}</div><div class="ll num" style="text-align:end;margin-top:-8px;margin-bottom:12px">${I.ll(ll)}</div>
      <div class="seg" role="group"><button data-act="pm" data-m="cash" class="${p.method === 'cash' ? 'on' : ''}">${t('cash')}</button><button data-act="pm" data-m="card" class="${p.method === 'card' ? 'on' : ''}">${t('card')}</button></div>
      ${showQ ? `<div class="seg" role="group"><button data-act="pc" data-c="USD" class="${p.cur === 'USD' ? 'on' : ''}">USD $</button><button data-act="pc" data-c="LL" class="${p.cur === 'LL' ? 'on' : ''}">LL</button></div>
      <label class="f">${t('tendered')} (${p.cur === 'USD' ? '$' : 'LL'})<input id="tend" type="number" step="any" min="0" inputmode="decimal" value="${esc(p.tendered)}"></label>
      <div class="quick">${quick.map((v, n) => `<button data-act="qa" data-v="${v}">${n === 0 ? t('exact') : (p.cur === 'USD' ? '$' + v : v.toLocaleString('en-US'))}</button>`).join('')}</div>
      <div class="changebox"><span>${t('change')}</span><b class="num" id="chg"></b></div>` : ''}
      <div class="row"><button class="btn" data-act="closem">${t('cancel')}</button><button class="btn pri" id="done" data-act="done">${t('complete')}</button></div>`);
    updatePay();
  }
  function updatePay() {
    const p = S.pay, c = cartCents(), done = $('#done'); if (!done) return;
    if (p.method === 'card') { done.disabled = false; return; }
    const tend = num(p.tendered);
    const paidCents = p.cur === 'USD' ? Math.round(tend * 100) : Math.round(tend / S.set.rate * 100);
    const ok = tend > 0 && paidCents >= c - (p.cur === 'LL' ? 1 : 0);
    done.disabled = !ok;
    const chg = $('#chg'); if (!chg) return;
    if (!ok) chg.textContent = '—';
    else chg.textContent = p.cur === 'USD' ? `${I.usd(paidCents - c)}  (${I.ll(toLL(Math.max(0, paidCents - c)))})` : I.ll(Math.max(0, tend - toLL(c)));
  }
  async function finishSale() {
    const p = S.pay; const btn = $('#done'); btn.disabled = true;
    try {
      const sale = await api('/api/sales', { method: 'POST', body: { lines: S.cart.map((l) => ({ item_id: l.id, qty: l.qty })), method: p.method, currency: p.cur, tendered: p.method === 'cash' ? num(p.tendered) : undefined } });
      S.cart = []; drawCart(); showReceipt(sale, true); loadCatalog();
    } catch (e) { btn.disabled = false; fail(e); }
  }
  function showReceipt(s, fresh) {
    const ln = s.items.map((l) => `<div class="r"><span>${l.qty !== 1 ? `${l.qty} × ` : ''}${esc(l.name)}</span><span class="num">${I.usd(Math.round(l.qty * l.price_cents))}</span></div>`).join('');
    const paid = s.method === 'card' ? t('card') : `${t('cash')} ${s.currency === 'LL' ? I.ll(s.tendered) : I.usd(s.tendered * 100)}`;
    modal(`<div id="rcpt" class="paper"><div class="c"><b class="big">${esc(S.set.store_name)}</b><br>${t('receipt')} #${s.id}${s.status === 'void' ? ` <span class="stamp">${t('voided')}</span>` : ''}<br><span class="muted">${dateFmt(s.created_at)}</span><br><span class="muted">${t('cashier')}: ${esc(s.user_name)}</span></div><hr>${ln}<hr>
      <div class="r big"><span>${t('total')}</span><span class="num">${I.usd(s.total_cents)}</span></div><div class="r"><span></span><span class="num">${I.ll(s.total_ll)}</span></div>
      <div class="r"><span>${t('paid_by')}</span><span class="num">${paid}</span></div>${s.change_cents ? `<div class="r"><span>${t('change')}</span><span class="num">${I.usd(s.change_cents)}</span></div>` : ''}
      <div class="r muted"><span>${t('rate')}</span><span class="num">$1 = ${s.rate.toLocaleString('en-US')} LL</span></div><hr><div class="c">${esc(S.set.footer || '')}</div></div>
      <div class="row"><button class="btn" data-act="print">${t('print')}</button>${isOwner() && s.status === 'ok' ? `<button class="btn danger" data-act="void" data-id="${s.id}">${t('void')}</button>` : ''}<button class="btn pri" data-act="closem">${fresh ? t('new_sale') : t('close')}</button></div>`);
  }

  // ---------- items ----------
  async function viewItems() {
    $('#view').innerHTML = `<div class="topbar"><h1>${t('items')}</h1><span class="muted" id="icount"></span><span class="sp"></span>
      ${isOwner() ? `<button class="btn" data-act="export">${t('export_csv')}</button><button class="btn" data-act="import">${t('import_csv')}</button><button class="btn pri" data-act="newitem">${t('add_item')}</button><input type="file" id="csv" accept=".csv,text/csv" class="hide">` : ''}</div>
      <div class="search" style="margin-bottom:14px"><input id="iq" type="search" placeholder="${esc(t('search_ph'))}" value="${esc(S.itemQ)}"></div><div id="itbl"></div>`;
    loadItems(); $('#iq').focus();
  }
  async function loadItems(append) {
    const my = ++S.seq;
    try {
      const p = new URLSearchParams({ q: S.itemQ, limit: 60, offset: append ? S.items.length : 0 });
      const r = await api('/api/items?' + p); if (my !== S.seq) return;
      S.total = r.total; S.items = append ? S.items.concat(r.items) : r.items; drawItems();
    } catch (e) { fail(e); }
  }
  function drawItems() {
    $('#icount').textContent = t('items_count', { n: S.total.toLocaleString('en-US') });
    if (!S.items.length) { $('#itbl').innerHTML = `<div class="empty">${t('no_items')}</div>`; return; }
    $('#itbl').innerHTML = `<table class="tbl"><thead><tr><th></th><th>${t('name')}</th><th>${t('barcode')}</th><th>${t('category')}</th><th>${t('price')}</th>${isOwner() ? `<th>${t('cost_usd')}</th>` : ''}<th>${t('stock')}</th></tr></thead><tbody>
      ${S.items.map((i) => `<tr class="${isOwner() ? 'click' : ''}" data-act="${isOwner() ? 'edit' : ''}" data-id="${i.id}"><td><span class="thumb">${pic(i)}</span></td><td><b>${esc(i.name)}</b><div class="muted">${esc(i.name_ar)}</div></td><td class="num">${esc(i.barcode)}</td>
      <td>${esc(I.catName(i.category))}</td><td><span class="num">${I.usd(i.price_cents)}</span><div class="muted num">${I.ll(i.price_ll)}</div></td>${isOwner() ? `<td class="num">${I.usd(i.cost_cents)}</td>` : ''}
      <td>${i.stock < 0 ? `<span class="pill bad num">${i.stock}</span>` : i.min_stock > 0 && i.stock <= i.min_stock ? `<span class="pill warn num">${i.stock}</span>` : `<span class="num">${i.stock}</span>`} ${i.unit === 'kg' ? t('kg') : ''}</td></tr>`).join('')}</tbody></table>
      ${S.total > S.items.length ? `<button class="btn" data-act="moreitems" style="margin-top:12px">${t('load_more')}</button>` : ''}`;
  }
  let imgState = { changed: false, data: null };
  function itemForm(i) {
    imgState = { changed: false, data: null };
    const cats = S.cats.map((c) => `<option value="${esc(c.category)}">`).join('') + Object.keys(I.CATS).map((c) => `<option value="${c}">`).join('');
    modal(`<h2>${i ? t('edit_item') : t('add_item')}</h2><form id="iform" data-id="${i ? i.id : ''}">
      <div class="grid2"><label class="f">${t('barcode')}<input name="barcode" required value="${esc(i?.barcode)}"></label><label class="f">${t('category')}<input name="category" list="cl" value="${esc(i?.category)}"><datalist id="cl">${cats}</datalist></label></div>
      <div class="grid2" style="margin-top:10px"><label class="f">${t('name')}<input name="name" required value="${esc(i?.name)}"></label><label class="f">${t('name_ar')}<input name="name_ar" dir="rtl" value="${esc(i?.name_ar)}"></label></div>
      <div class="grid2" style="margin-top:10px"><label class="f">${t('price_usd')}<input name="price_usd" type="number" step="0.01" min="0" required value="${i ? (i.price_cents / 100).toFixed(2) : ''}"></label><label class="f">${t('cost_usd')}<input name="cost_usd" type="number" step="0.01" min="0" value="${i ? (i.cost_cents / 100).toFixed(2) : ''}"></label></div>
      <div class="grid2" style="margin-top:10px"><label class="f">${t('stock')}<input name="stock" type="number" step="any" value="${i ? i.stock : 0}"></label><label class="f">${t('min_stock')}<input name="min_stock" type="number" step="any" min="0" value="${i ? i.min_stock : 0}"></label></div>
      <div class="grid2" style="margin-top:10px"><label class="f">${t('unit')}<select name="unit"><option value="pc" ${i?.unit !== 'kg' ? 'selected' : ''}>${t('pc')}</option><option value="kg" ${i?.unit === 'kg' ? 'selected' : ''}>${t('kg')}</option></select></label>
      <label class="f">${t('extra_barcodes')}<input name="extra" value="${esc((i?.extra_barcodes || []).join(';'))}"></label></div>
      <div style="margin-top:12px;display:flex;align-items:center;gap:12px"><span class="thumb" id="pv" style="width:64px;height:64px">${i ? pic(i) : '📦'}</span><label class="btn sm" style="cursor:pointer">${t('choose_photo')}<input type="file" id="photo" accept="image/*" class="hide"></label>${i?.has_image ? `<button type="button" class="btn sm danger" data-act="rmphoto">${t('remove_photo')}</button>` : ''}</div>
      <div class="row"><button type="button" class="btn" data-act="closem">${t('cancel')}</button>${i ? `<button type="button" class="btn danger" data-act="rmitem" data-id="${i.id}">${t('remove')}</button>` : ''}<button class="btn pri" type="submit">${t('save')}</button></div></form>`, true);
  }
  function resizeImage(file, max = 360) {
    return new Promise((res, rej) => {
      const url = URL.createObjectURL(file), im = new Image();
      im.onload = () => { const k = Math.min(1, max / Math.max(im.width, im.height)), c = document.createElement('canvas'); c.width = Math.round(im.width * k); c.height = Math.round(im.height * k);
        c.getContext('2d').drawImage(im, 0, 0, c.width, c.height); URL.revokeObjectURL(url); res(c.toDataURL('image/jpeg', 0.82)); };
      im.onerror = () => rej(new Error(t('error'))); im.src = url;
    });
  }
  async function saveItem(form) {
    const f = new FormData(form), id = form.dataset.id;
    const body = { barcode: f.get('barcode'), name: f.get('name'), name_ar: f.get('name_ar'), category: f.get('category'), price_usd: f.get('price_usd'), cost_usd: f.get('cost_usd') || 0, stock: f.get('stock'), min_stock: f.get('min_stock'), unit: f.get('unit'), extra_barcodes: String(f.get('extra')).split(';').map((x) => x.trim()).filter(Boolean) };
    if (imgState.changed) body.image = imgState.data || '';
    try {
      await api(id ? '/api/items/' + id : '/api/items', { method: id ? 'PUT' : 'POST', body });
      closeModal(); toast(t('saved')); S.cats = await api('/api/categories'); loadItems();
    } catch (e) { fail(e); }
  }
  function parseCSV(text) {
    const rows = []; let row = [], cur = '', q = false; text = text.replace(/^﻿/, '');
    for (let n = 0; n < text.length; n++) {
      const ch = text[n];
      if (q) { if (ch === '"') { if (text[n + 1] === '"') { cur += '"'; n++; } else q = false; } else cur += ch; }
      else if (ch === '"') q = true;
      else if (ch === ',') { row.push(cur); cur = ''; }
      else if (ch === '\n' || ch === '\r') { if (ch === '\r' && text[n + 1] === '\n') n++; row.push(cur); cur = ''; if (row.some((x) => x !== '')) rows.push(row); row = []; }
      else cur += ch;
    }
    row.push(cur); if (row.some((x) => x !== '')) rows.push(row);
    const head = rows.shift().map((h) => h.trim().toLowerCase());
    return rows.map((r) => Object.fromEntries(head.map((h, n) => [h, (r[n] ?? '').trim()])));
  }
  async function importCSV(file) {
    try {
      const rows = parseCSV(await file.text()); let c = 0, u = 0, errs = 0;
      for (let n = 0; n < rows.length; n += 2000) { const r = await api('/api/items/import', { method: 'POST', body: { rows: rows.slice(n, n + 2000) } }); c += r.created; u += r.updated; errs += r.errors.length; }
      toast(t('imported', { c, u }) + (errs ? ` · ${t('row_errors', { n: errs })}` : ''), errs > 0); S.cats = await api('/api/categories'); loadItems();
    } catch (e) { fail(e); }
  }
  async function exportCSV() {
    try {
      const r = await fetch('/api/items/export', { headers: { Authorization: 'Bearer ' + S.token } }); const b = await r.blob();
      const a = document.createElement('a'); a.href = URL.createObjectURL(b); a.download = 'items.csv'; a.click(); URL.revokeObjectURL(a.href);
    } catch (e) { fail(e); }
  }

  // ---------- sales ----------
  async function viewSales() {
    $('#view').innerHTML = `<div class="topbar"><h1>${t('sales')}</h1></div><div id="stbl"></div>`;
    try {
      const rows = await api('/api/sales');
      $('#stbl').innerHTML = rows.length ? `<table class="tbl"><thead><tr><th>#</th><th>${t('time')}</th><th>${t('cashier')}</th><th>${t('paid_by')}</th><th>${t('total')}</th><th>${t('status')}</th></tr></thead><tbody>
        ${rows.map((s) => `<tr class="click" data-act="sale" data-id="${s.id}"><td class="num">${s.id}</td><td>${dateFmt(s.created_at)}</td><td>${esc(s.user_name)}</td><td>${s.method === 'card' ? t('card') : t('cash') + ' ' + s.currency}</td>
        <td><b class="num">${I.usd(s.total_cents)}</b><div class="muted num">${I.ll(s.total_ll)}</div></td><td>${s.status === 'void' ? `<span class="pill bad">${t('voided')}</span>` : ''}</td></tr>`).join('')}</tbody></table>` : `<div class="empty">${t('no_sales')}</div>`;
    } catch (e) { fail(e); }
  }

  // ---------- dashboard ----------
  async function viewDash() {
    $('#view').innerHTML = `<div class="topbar"><h1>${t('dashboard')}</h1></div><div id="dash"></div>`;
    try {
      const d = await api('/api/dashboard'), max = Math.max(1, ...d.days.map((x) => x.total_cents)), topMax = Math.max(1, ...d.top_week.map((x) => x.revenue_cents));
      const wd = (k) => new Date(k + 'T12:00:00Z').toLocaleDateString(I.lang === 'ar' ? 'ar-LB' : 'en-GB', { weekday: 'short', timeZone: 'UTC' });
      $('#dash').innerHTML = `${d.negative_stock ? `<div class="note">${d.negative_stock} ${t('neg_stock')}</div>` : ''}
        <div class="kpis"><div class="kpi hero"><span class="k">${t('today')}</span>${tagHtml(d.today.total_cents)}<span class="num" style="color:#b5d3c3">${I.ll(d.today.total_ll)}</span></div>
        <div class="kpi"><span class="k">${t('receipts')}</span><span class="v num">${d.today.count}</span></div><div class="kpi"><span class="k">${t('avg_basket')}</span><span class="v num">${I.usd(d.today.avg_cents)}</span></div>
        <div class="kpi"><span class="k">${t('est_profit')}</span><span class="v num">${I.usd(d.today.profit_cents)}</span></div></div>
        <div class="two"><div class="card"><h2>${t('last7')}</h2><div class="bars">${d.days.map((x, n) => `<div class="bar ${n === 6 ? 'today' : ''}"><b class="num">${x.total_cents ? Math.round(x.total_cents / 100) : ''}</b><i style="height:${Math.round(x.total_cents / max * 140)}px"></i><span>${wd(x.day)}</span></div>`).join('')}</div></div>
        <div class="card"><h2>${t('top_sellers')}</h2><div class="rank">${d.top_week.length ? d.top_week.map((x) => `<div class="rw"><div class="top"><span>${esc(x.name)}</span><span class="num">${I.usd(x.revenue_cents)}</span></div><div class="meter"><i style="width:${Math.round(x.revenue_cents / topMax * 100)}%"></i></div></div>`).join('') : `<div class="muted">${t('no_sales')}</div>`}</div></div></div>
        <div class="card"><h2>${t('low_stock')}</h2>${d.low.length ? `<table class="tbl"><tbody>${d.low.map((x) => `<tr><td>${esc(I.itemName(x))}</td><td style="text-align:end"><span class="pill warn num">${x.stock}</span> <span class="muted">/ ${x.min_stock}</span></td></tr>`).join('')}</tbody></table>` : `<div class="muted">${t('nothing_low')}</div>`}</div>`;
    } catch (e) { fail(e); }
  }

  // ---------- settings ----------
  async function viewSettings() {
    $('#view').innerHTML = `<div class="topbar"><h1>${t('settings')}</h1></div><div class="two"><div class="card"><h2>${t('store_name')}</h2>
      <form id="sform"><label class="f">${t('store_name')}<input name="store_name" value="${esc(S.set.store_name)}" required></label>
      <label class="f" style="margin-top:10px">${t('usd_rate')}<input name="rate" type="number" min="1" step="1" value="${S.set.rate}" required></label>
      <label class="f" style="margin-top:10px">${t('footer')}<input name="footer" value="${esc(S.set.footer)}"></label><div class="row"><button class="btn pri" type="submit">${t('save')}</button></div></form></div>
      <div class="card"><h2>${t('team')}</h2><div id="team"></div><form id="uform" style="margin-top:14px;display:grid;gap:10px"><h2 style="margin:0;font-size:16px">${t('add_member')}</h2>
      <input name="name" placeholder="${esc(t('name'))}" required><div class="grid2"><input name="pin" inputmode="numeric" pattern="\\d{4,8}" placeholder="${esc(t('pin'))}" required>
      <select name="role"><option value="cashier">${t('cashier_role')}</option><option value="owner">${t('owner')}</option></select></div><button class="btn pri" type="submit">${t('add_member')}</button></form></div></div>`;
    drawTeam();
  }
  async function drawTeam() {
    try {
      const us = await api('/api/admin/users');
      $('#team').innerHTML = `<table class="tbl"><tbody>${us.map((u) => `<tr><td><b>${esc(u.name)}</b><div class="muted">${u.role === 'owner' ? t('owner') : t('cashier_role')}${u.active ? '' : ' · ✕'}</div></td>
        <td style="text-align:end;white-space:nowrap"><button class="btn sm" data-act="setpin" data-id="${u.id}" data-name="${esc(u.name)}">${t('set_pin')}</button> ${u.id === S.user.id ? '' : `<button class="btn sm" data-act="toggleuser" data-id="${u.id}" data-on="${u.active ? 0 : 1}">${u.active ? t('deactivate') : t('activate')}</button>`}</td></tr>`).join('')}</tbody></table>`;
    } catch (e) { fail(e); }
  }

  // ---------- events ----------
  const A = {
    lang() { I.setLang(I.lang === 'ar' ? 'en' : 'ar'); S.user ? render() : (S.pinUser ? drawLogin() : renderLogin()); },
    pickuser(b) { S.pinUser = S.users.find((u) => u.id === +b.dataset.id); S.pin = ''; drawLogin(); },
    changeuser() { S.pinUser = null; S.pin = ''; drawLogin(); },
    pin(b) { if (S.pin.length < 8) { S.pin += b.dataset.d; drawLogin(); } },
    pinback() { S.pin = S.pin.slice(0, -1); drawLogin(); },
    pinok: submitPin,
    nav(b) { S.view = b.dataset.v; S.q = ''; S.items = []; renderShell(); },
    logout() { api('/api/logout', { method: 'POST' }).catch(() => {}); signedOut(); },
    cat(b) { S.cat = b.dataset.c; drawChips(); loadCatalog(); $('#q').focus(); },
    add(b) { const i = S.items.find((x) => x.id === +b.dataset.id); if (i) addToCart(i); $('#q')?.focus(); },
    more() { loadCatalog(true); }, moreitems() { loadItems(true); },
    inc(b) { S.cart[+b.dataset.n].qty = Math.round((S.cart[+b.dataset.n].qty + 1) * 1000) / 1000; drawCart(); },
    dec(b) { const l = S.cart[+b.dataset.n]; l.qty = Math.round((l.qty - 1) * 1000) / 1000; if (l.qty <= 0) S.cart.splice(+b.dataset.n, 1); drawCart(); },
    del(b) { S.cart.splice(+b.dataset.n, 1); drawCart(); },
    clear() { S.cart = []; drawCart(); $('#q')?.focus(); },
    pay: openPay, closem: closeModal, done: finishSale, print() { window.print(); },
    pm(b) { S.pay.method = b.dataset.m; drawPay(); }, pc(b) { S.pay.cur = b.dataset.c; S.pay.tendered = ''; drawPay(); },
    qa(b) { S.pay.tendered = String(b.dataset.v); drawPay(); },
    sale(b) { api('/api/sales/' + b.dataset.id).then((s) => showReceipt(s, false)).catch(fail); },
    async void(b) {
      if (!confirm(t('confirm_void'))) return;
      try { const s = await api(`/api/sales/${b.dataset.id}/void`, { method: 'POST' }); showReceipt(s, false); if (S.view === 'sales') viewSales(); } catch (e) { fail(e); }
    },
    newitem() { itemForm(null); }, edit(b) { const i = S.items.find((x) => x.id === +b.dataset.id); if (i) itemForm(i); },
    export: exportCSV, import() { $('#csv').click(); },
    rmphoto() { imgState = { changed: true, data: '' }; $('#pv').textContent = '📦'; },
    async rmitem(b) { if (!confirm(t('confirm_remove'))) return; try { await api('/api/items/' + b.dataset.id, { method: 'DELETE' }); closeModal(); loadItems(); } catch (e) { fail(e); } },
    setpin(b) {
      modal(`<h2>${t('set_pin')}: ${esc(b.dataset.name)}</h2><form id="pform" data-id="${b.dataset.id}"><label class="f">${t('pin')}<input name="pin" inputmode="numeric" pattern="\\d{4,8}" required></label>
        <div class="row"><button type="button" class="btn" data-act="closem">${t('cancel')}</button><button class="btn pri" type="submit">${t('save')}</button></div></form>`);
    },
    async toggleuser(b) { try { await api('/api/admin/users/' + b.dataset.id, { method: 'PUT', body: { active: b.dataset.on === '1' } }); drawTeam(); } catch (e) { fail(e); } },
  };
  document.addEventListener('click', (e) => { const b = e.target.closest('[data-act]'); if (b && b.tagName !== 'INPUT' && A[b.dataset.act]) A[b.dataset.act](b); });
  document.addEventListener('change', (e) => {
    const el = e.target;
    if (el.dataset.act === 'setqty') { const l = S.cart[+el.dataset.n]; const q = num(el.value); if (q > 0) l.qty = q; else S.cart.splice(+el.dataset.n, 1); drawCart(); }
    if (el.id === 'csv' && el.files[0]) { importCSV(el.files[0]); el.value = ''; }
    if (el.id === 'photo' && el.files[0]) resizeImage(el.files[0]).then((d) => { imgState = { changed: true, data: d }; $('#pv').innerHTML = `<img src="${d}" alt="">`; }).catch(fail);
  });
  let deb;
  document.addEventListener('input', (e) => {
    const el = e.target;
    if (el.id === 'q') { clearTimeout(deb); deb = setTimeout(() => { S.q = el.value; loadCatalog(); }, 160); }
    else if (el.id === 'iq') { clearTimeout(deb); deb = setTimeout(() => { S.itemQ = el.value; loadItems(); }, 160); }
    else if (el.id === 'tend') { S.pay.tendered = el.value; updatePay(); }
  });
  document.addEventListener('submit', (e) => {
    e.preventDefault(); const f = e.target;
    if (f.id === 'iform') saveItem(f);
    if (f.id === 'sform') { const d = Object.fromEntries(new FormData(f)); api('/api/settings', { method: 'PUT', body: { ...d, rate: num(d.rate) } }).then((s) => { S.set = s; toast(t('saved')); }).catch(fail); }
    if (f.id === 'uform') { const d = Object.fromEntries(new FormData(f)); api('/api/admin/users', { method: 'POST', body: d }).then(() => { f.reset(); drawTeam(); toast(t('saved')); }).catch(fail); }
    if (f.id === 'pform') { api('/api/admin/users/' + f.dataset.id, { method: 'PUT', body: { pin: new FormData(f).get('pin') } }).then(() => { closeModal(); toast(t('saved')); }).catch(fail); }
  });
  document.addEventListener('keydown', (e) => {
    const modalOpen = !!$('#modal .modal');
    if (e.key === 'Escape' && modalOpen) return closeModal();
    if (!S.user && S.pinUser) { if (/^\d$/.test(e.key)) A.pin({ dataset: { d: e.key } }); else if (e.key === 'Backspace') A.pinback(); else if (e.key === 'Enter') submitPin(); return; }
    if (e.key === 'Enter' && e.target.id === 'q') { e.preventDefault(); scanSubmit(e.target.value); return; }
    if (e.key === 'Enter' && modalOpen && S.pay && $('#done') && !$('#done').disabled && e.target.tagName !== 'BUTTON') { e.preventDefault(); finishSale(); return; }
    // a barcode scanner types fast with no focus: send it to the search box
    if (S.user && S.view === 'sell' && !modalOpen && e.key.length === 1 && !e.ctrlKey && !e.metaKey && !/^(INPUT|TEXTAREA|SELECT)$/.test(e.target.tagName)) $('#q')?.focus();
  });

  // ---------- boot ----------
  (async () => {
    $('#root').innerHTML = '';
    if (S.token) { try { S.user = await api('/api/me'); S.set = await api('/api/settings'); } catch { S.token = ''; } }
    render();
  })();
})();
