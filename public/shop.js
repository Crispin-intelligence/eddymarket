// Eddy Market customer shop: browse, cart, order for pickup or delivery. Orders land in the till's Orders screen.
(() => {
  const $ = (s, r = document) => r.querySelector(s);
  const LS = { get(k, d) { try { const v = localStorage.getItem('eddyshop.' + k); return v == null ? d : JSON.parse(v); } catch { return d; } }, set(k, v) { try { localStorage.setItem('eddyshop.' + k, JSON.stringify(v)); } catch { /* private mode */ } } };
  const T = {
    en: { store: 'Store', cats: 'Categories', saved: 'Saved', orders: 'Orders', search: 'Search products', open: 'Open', closed: 'Closed', closed_msg: 'Ordering is closed right now. Come back soon.',
      hero: 'Fresh from Eddy Market', hero_sub: 'Order here. Pick up or get it delivered.', rate: 'You can pay in Lebanese pounds', pickup: 'Pickup', delivery: 'Delivery', pickup_sub: 'Ready when you arrive', delivery_sub: 'Brought to your door',
      featured: 'Featured', recent: 'Recently added', shop_cat: 'Shop by category', see_all: 'See all', add: 'Add', add_cart: 'Add to cart', in_cart: 'In your cart', similar: 'Similar products', load_more: 'Show more',
      cart: 'Cart', cart_empty: 'Your cart is empty', cart_empty_sub: 'Add something you like.', keep: 'Keep shopping', total: 'Total', your_details: 'Your details', name: 'Your name', phone: 'Phone number (WhatsApp)', address: 'Delivery address', note: 'Note for the store (optional)',
      place: 'Place order', placing: 'Sending…', pay_note: 'You pay when you pick up or when it arrives.', no_results: 'Nothing found', no_results_sub: 'Try another word or check the spelling.', saved_empty: 'Nothing saved yet', saved_empty_sub: 'Tap the heart on a product to keep it here.',
      buy_again: 'Buy it again', wishlist: 'Wish list', no_orders: 'No orders yet', no_orders_sub: 'Your orders will show here.', order: 'Order', thanks: 'Order sent!', thanks_sub: 'The store will confirm it shortly. Keep this code:', send_wa: 'Send on WhatsApp', track: 'Track my order', again: 'Order again', items: 'items',
      s_new: 'Received', s_accepted: 'Accepted', s_ready: 'Ready', s_done: 'Completed', s_rejected: 'Not available', lang: 'عربي', pc: 'piece', added: 'Added to cart', unavail: 'This item is no longer available',
      wa_hi: 'Hello Eddy Market, my order', cat_dairy: 'Dairy', cat_bakery: 'Bakery', cat_produce: 'Fruits & vegetables', cat_meat: 'Meat & poultry', cat_frozen: 'Frozen', cat_pantry: 'Pantry', cat_snacks: 'Snacks & sweets', cat_drinks: 'Drinks', cat_cleaning: 'Cleaning', cat_personal: 'Personal care', cat_other: 'More products' },
    ar: { store: 'المتجر', cats: 'الأقسام', saved: 'المفضلة', orders: 'طلباتي', search: 'ابحث عن منتج', open: 'مفتوح', closed: 'مغلق', closed_msg: 'الطلبات متوقفة حالياً. عد قريباً.',
      hero: 'طازج من إيدي ماركت', hero_sub: 'اطلب من هنا. استلام أو توصيل.', rate: 'يمكنك الدفع بالليرة اللبنانية', pickup: 'استلام', delivery: 'توصيل', pickup_sub: 'جاهز عند وصولك', delivery_sub: 'يصلك إلى الباب', 
      featured: 'مميزة', recent: 'أضيفت حديثاً', shop_cat: 'تسوّق حسب القسم', see_all: 'عرض الكل', add: 'أضف', add_cart: 'أضف إلى السلة', in_cart: 'في سلتك', similar: 'منتجات مشابهة', load_more: 'عرض المزيد',
      cart: 'السلة', cart_empty: 'سلتك فارغة', cart_empty_sub: 'أضف ما يعجبك.', keep: 'تابع التسوق', total: 'المجموع', your_details: 'معلوماتك', name: 'اسمك', phone: 'رقم الهاتف (واتساب)', address: 'عنوان التوصيل', note: 'ملاحظة للمتجر (اختياري)',
      place: 'أرسل الطلب', placing: 'جارٍ الإرسال…', pay_note: 'الدفع عند الاستلام أو عند وصول الطلب.', no_results: 'لا نتائج', no_results_sub: 'جرّب كلمة أخرى أو تأكد من الإملاء.', saved_empty: 'لا شيء محفوظ', saved_empty_sub: 'اضغط على القلب في أي منتج ليظهر هنا.',
      buy_again: 'اشترِ مجدداً', wishlist: 'المفضلة', no_orders: 'لا طلبات بعد', no_orders_sub: 'ستظهر طلباتك هنا.', order: 'طلب', thanks: 'تم إرسال الطلب!', thanks_sub: 'سيؤكد المتجر طلبك قريباً. احتفظ بهذا الرمز:', send_wa: 'أرسل عبر واتساب', track: 'تتبّع طلبي', again: 'اطلب مجدداً', items: 'أصناف',
      s_new: 'تم الاستلام', s_accepted: 'تم القبول', s_ready: 'جاهز', s_done: 'مكتمل', s_rejected: 'غير متوفر', lang: 'EN', pc: 'قطعة', added: 'أضيف إلى السلة', unavail: 'هذا المنتج لم يعد متوفراً',
      wa_hi: 'مرحباً إيدي ماركت، طلبي', cat_dairy: 'الألبان', cat_bakery: 'المخبوزات', cat_produce: 'فواكه وخضار', cat_meat: 'لحوم ودواجن', cat_frozen: 'مجمّدات', cat_pantry: 'المؤن', cat_snacks: 'تسالي وحلويات', cat_drinks: 'مشروبات', cat_cleaning: 'تنظيف', cat_personal: 'العناية الشخصية', cat_other: 'منتجات أخرى' } };
  let lang = LS.get('lang', (navigator.language || '').startsWith('ar') ? 'ar' : 'en');
  const t = (k) => T[lang][k] ?? T.en[k] ?? k;
  const CI = { dairy: '🥛', bakery: '🥖', produce: '🥬', meat: '🍗', frozen: '🧊', pantry: '🥫', snacks: '🍫', drinks: '🥤', cleaning: '🧴', personal: '🧼', other: '🛍️' };
  const esc = (s) => String(s ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
  const catName = (c) => T[lang]['cat_' + c] || c.replace(/[_-]/g, ' ');
  const nm = (i) => (lang === 'ar' && i.name_ar) || i.name;
  const usd = (c) => '$' + (c / 100).toFixed(2);
  let HOME = { rate: 90000, open: true, wa: '', store_name: 'Eddy Market' };
  const llOf = (c) => (Math.round((c / 100) * HOME.rate / 1000) * 1000).toLocaleString('en-US') + ' LL';
  const ITEMS = new Map(); const keep = (list) => { list.forEach((i) => ITEMS.set(i.id, i)); return list; };
  let cart = LS.get('cart', []), wish = LS.get('wish', []), myOrders = LS.get('orders', []), me = LS.get('me', { name: '', phone: '', address: '' }), mode = LS.get('mode', 'pickup');
  const save = () => { LS.set('cart', cart); LS.set('wish', wish); LS.set('orders', myOrders); LS.set('me', me); LS.set('mode', mode); };
  const step = (i) => (i.unit && i.unit !== 'pc' ? 0.5 : 1);
  const unitTxt = (i) => (i.unit && i.unit !== 'pc' ? '/ ' + i.unit : '');
  async function api(p, o = {}) {
    const r = await fetch(p, { method: o.method || 'GET', headers: { 'Content-Type': 'application/json' }, body: o.body ? JSON.stringify(o.body) : undefined });
    const j = await r.json().catch(() => ({})); if (!r.ok) throw new Error(j.error || 'Something went wrong'); return j;
  }
  const I = { search: '<svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/></svg>', cart: '<svg viewBox="0 0 24 24"><path d="M3 4h2l2.4 11h10.2L20 7H6.2"/><circle cx="9" cy="20" r="1.4"/><circle cx="17" cy="20" r="1.4"/></svg>',
    store: '<svg viewBox="0 0 24 24"><path d="M4 9 5.5 4h13L20 9M4 9v11h16V9M4 9c0 1.7 1.3 3 3 3s3-1.3 3-3c0 1.7 1.3 3 3 3s3-1.3 3-3c0 1.7 1.3 3 3 3"/></svg>',
    grid: '<svg viewBox="0 0 24 24"><rect x="4" y="4" width="6.5" height="6.5" rx="1.5"/><rect x="13.5" y="4" width="6.5" height="6.5" rx="1.5"/><rect x="4" y="13.5" width="6.5" height="6.5" rx="1.5"/><rect x="13.5" y="13.5" width="6.5" height="6.5" rx="1.5"/></svg>',
    heart: '<svg viewBox="0 0 24 24"><path d="M12 20s-7.5-4.6-7.5-10.2A4.3 4.3 0 0 1 12 7.3a4.3 4.3 0 0 1 7.5 2.5C19.5 15.4 12 20 12 20Z"/></svg>',
    list: '<svg viewBox="0 0 24 24"><rect x="5" y="4" width="14" height="17" rx="2"/><path d="M9 4V3h6v1M9 10h6M9 14h6M9 18h3"/></svg>' };
  const total = () => cart.reduce((a, l) => a + Math.round(l.qty * l.price_cents), 0);
  const count = () => cart.length;
  const pic = (i) => (i.has_image ? `<img loading="lazy" src="/img/${i.id}?v=${i.v}" alt="">` : `<span class="ph">${CI[i.category] || '🛍️'}</span>`);
  const card = (i) => `<article class="card" data-go="#/i/${i.id}"><button class="add" data-add="${i.id}" aria-label="${t('add')}">+</button><div class="pic">${pic(i)}</div><div class="pt"><b>${usd(i.price_cents)}</b><small>${llOf(i.price_cents)}</small></div><h3>${esc(nm(i))}</h3></article>`;
  const rowOf = (list) => `<div class="scroll">${list.map(card).join('')}</div>`;
  const toast = (m) => { $('.toast')?.remove(); const d = document.createElement('div'); d.className = 'toast'; d.textContent = m; document.body.appendChild(d); setTimeout(() => d.remove(), 1600); };
  const phoneFmt = (s) => s;

  // ---- shell ----
  function shell() {
    document.documentElement.lang = lang; document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr';
    $('#app').innerHTML = `<header class="top"><div class="row"><a class="brand" href="#/"><span class="tg">E</span><span class="n">${esc(HOME.store_name)}</span></a><span class="pill ${HOME.open ? 'on' : 'off'}">${HOME.open ? t('open') : t('closed')}</span>
      <button class="ib" data-act="lang" aria-label="Language">${t('lang')}</button><a class="ib" href="#/cart" aria-label="${t('cart')}">${I.cart}<b id="cc" hidden></b></a></div>
      <div class="search">${I.search}<input id="q" type="search" enterkeyhint="search" autocomplete="off" placeholder="${t('search')}"></div></header>
      <main id="main"></main><div id="bar"></div>
      <nav class="tabs"><div>${[['#/', 'store', I.store], ['#/cats', 'cats', I.grid], ['#/saved', 'saved', I.heart], ['#/orders', 'orders', I.list]].map(([h, k, ic]) => `<a href="${h}" data-tab="${h}">${ic}<span>${t(k)}</span></a>`).join('')}</div></nav>`;
    $('#q').addEventListener('input', onSearch);
  }
  let st; function onSearch(e) { clearTimeout(st); const v = e.target.value.trim(); st = setTimeout(() => { if (v) location.hash = '#/s/' + encodeURIComponent(v); else if (location.hash.startsWith('#/s/')) location.hash = '#/'; }, 250); }
  function chrome(path) {
    const cc = $('#cc'); if (cc) { cc.hidden = !count(); cc.textContent = count(); }
    document.querySelectorAll('.tabs a').forEach((a) => { const h = a.dataset.tab; a.classList.toggle('on', h === '#/' ? path === '/' || path.startsWith('/s/') : path.startsWith(h.slice(1))); });
    const showBar = count() && !path.startsWith('/cart') && !path.startsWith('/i/') && !path.startsWith('/done');
    $('#bar').innerHTML = showBar ? `<a class="cartbar" href="#/cart"><span>${I.cart.replace('<svg', '<svg width="20" height="20" style="vertical-align:-4px;stroke:#fff;fill:none;stroke-width:1.8"')} ${t('cart')} · ${count()}</span><b>${usd(total())}</b></a>` : '';
  }
  const empty = (e, a, b) => `<div class="empty"><div class="e">${e}</div><h3>${a}</h3><p>${b}</p></div>`;

  // ---- views ----
  async function vHome() {
    const h = await api('/api/shop/home'); HOME = h; keep(h.featured); keep(h.recent);
    const top = $('.brand .n'); if (top) top.textContent = h.store_name; const pl = $('.pill'); if (pl) { pl.className = 'pill ' + (h.open ? 'on' : 'off'); pl.textContent = h.open ? t('open') : t('closed'); }
    return `${h.open ? '' : `<div class="err">${t('closed_msg')}</div>`}
      <section class="hero"><div><h1>${t('hero')}</h1><p>${t('hero_sub')}</p></div><div class="tg">Eddy</div></section>
      <div class="info" style="margin-top:12px"><div><i>💱</i><span>${t('rate')}<b>$1 = ${h.rate.toLocaleString('en-US')} LL</b></span></div><div><i>🛍️</i><span>${t('pickup')}<b>${t('pickup_sub')}</b></span></div><div><i>🚚</i><span>${t('delivery')}<b>${t('delivery_sub')}</b></span></div></div>
      ${h.featured.length ? `<h2 class="sec">${t('featured')}</h2>${rowOf(h.featured)}` : ''}
      ${h.recent.length ? `<h2 class="sec">${t('recent')}</h2>${rowOf(h.recent)}` : ''}
      <h2 class="sec">${t('shop_cat')}<a href="#/cats">${t('see_all')}</a></h2><div class="catrow">${h.cats.map(catTile).join('')}</div>`;
  }
  const catTile = (c, n) => `<a class="cat" href="#/c/${encodeURIComponent(c.category)}"><div class="ic c${(n ?? c.category.length) % 6}">${CI[c.category] || '🏷️'}</div>${esc(catName(c.category))}</a>`;
  async function vCats() { const h = await api('/api/shop/home'); HOME = h; return `<h2 class="sec">${t('cats')}</h2><div class="cats">${h.cats.map((c, n) => catTile(c, n)).join('')}</div>`; }
  let list = { q: '', category: '', off: 0, total: 0 };
  async function vList(opts, title) {
    list = { ...opts, off: 0, total: 0 };
    const p = new URLSearchParams({ limit: 24, ...(opts.q ? { q: opts.q } : {}), ...(opts.category ? { category: opts.category } : {}) });
    const r = await api('/api/shop/items?' + p); keep(r.items); list.off = r.items.length; list.total = r.total;
    return `<h2 class="sec">${esc(title)}</h2>` + (r.items.length ? `<div class="grid" id="g">${r.items.map(card).join('')}</div>${r.total > r.items.length ? `<button class="btn ghost more" data-act="more">${t('load_more')}</button>` : ''}` : empty('🔎', t('no_results'), t('no_results_sub')));
  }
  async function more() {
    const p = new URLSearchParams({ limit: 24, offset: list.off, ...(list.q ? { q: list.q } : {}), ...(list.category ? { category: list.category } : {}) });
    const r = await api('/api/shop/items?' + p); keep(r.items); list.off += r.items.length; $('#g').insertAdjacentHTML('beforeend', r.items.map(card).join('')); if (list.off >= list.total) $('.more')?.remove();
  }
  let pq = 1;
  async function vItem(id) {
    const r = await api('/api/shop/items?ids=' + id); keep(r.items); const i = r.items[0]; if (!i) return empty('🤷', t('unavail'), '');
    const inCart = cart.find((l) => l.id === i.id); pq = inCart ? inCart.qty : step(i);
    const sim = await api('/api/shop/items?limit=9&category=' + encodeURIComponent(i.category)); keep(sim.items);
    const s = sim.items.filter((x) => x.id !== i.id).slice(0, 8);
    return `<div class="pd"><div class="pbig">${pic(i)}</div><div><h1>${esc(nm(i))}</h1><span class="bigtag">${usd(i.price_cents)}</span><span class="ll">${llOf(i.price_cents)} ${unitTxt(i)}</span>
      ${s.length ? `<h2 class="sec">${t('similar')}</h2>${rowOf(s)}` : ''}</div></div>
      <div class="stick"><button class="heart ${wish.includes(i.id) ? 'on' : ''}" data-wish="${i.id}" aria-label="${t('wishlist')}">${I.heart}</button>
      <div class="step"><button data-pq="-1" data-id="${i.id}" aria-label="−">−</button><span id="pq">${pq}</span><button data-pq="1" data-id="${i.id}" aria-label="+">+</button></div>
      <button class="btn" data-addq="${i.id}">${inCart ? t('in_cart') + ' · ' : ''}${t('add_cart')}</button></div>`;
  }
  async function vSaved() {
    const again = [...new Set(myOrders.flatMap((o) => o.items.map((x) => x.item_id)))].slice(0, 24);
    const ids = [...new Set([...wish, ...again])]; if (ids.length) keep((await api('/api/shop/items?limit=60&ids=' + ids.join(','))).items);
    const g = (a) => a.map((id) => ITEMS.get(id)).filter(Boolean);
    const w = g(wish), b = g(again);
    if (!w.length && !b.length) return `<h2 class="sec">${t('saved')}</h2>` + empty('💙', t('saved_empty'), t('saved_empty_sub'));
    return `${w.length ? `<h2 class="sec">${t('wishlist')}</h2><div class="grid">${w.map(card).join('')}</div>` : ''}${b.length ? `<h2 class="sec">${t('buy_again')}</h2><div class="grid">${b.map(card).join('')}</div>` : ''}`;
  }
  const stIdx = { new: 0, accepted: 1, ready: 2, done: 3 };
  const statusBox = (o) => `<span class="ostat ${o.status}">${t('s_' + o.status)}</span>${o.status === 'rejected' ? '' : `<div class="bar">${[0, 1, 2, 3].map((n) => `<i class="${n <= (stIdx[o.status] ?? 0) ? 'on' : ''}"></i>`).join('')}</div>`}`;
  async function vOrders() {
    if (!myOrders.length) return `<h2 class="sec">${t('orders')}</h2>` + empty('🧾', t('no_orders'), t('no_orders_sub'));
    const rows = await api('/api/shop/orders?codes=' + myOrders.map((o) => o.code).join(','));
    return `<h2 class="sec">${t('orders')}</h2>` + rows.map((o) => `<div class="box"><div class="tot"><span>${t('order')} ${o.code}</span><span>${usd(o.total_cents)}</span></div>
      <small style="color:var(--mut)">${new Date(o.created_at).toLocaleString(lang === 'ar' ? 'ar-LB-u-nu-latn' : 'en-GB', { dateStyle: 'medium', timeStyle: 'short' })} · ${t(o.mode)} · ${o.items.length} ${t('items')}</small>${statusBox(o)}
      <button class="btn sm ghost" data-reorder="${o.code}">${t('again')}</button></div>`).join('');
  }
  async function vDone(code) {
    const [o] = await api('/api/shop/orders?codes=' + code); if (!o) return empty('🤷', t('no_orders'), '');
    const mine = myOrders.find((x) => x.code === code) || {};
    const lines = o.items.map((l) => `• ${l.qty} × ${l.name} — ${usd(Math.round(l.qty * l.price_cents))}`).join('\n');
    const msg = `${t('wa_hi')} ${code}\n${t(o.mode)}${mine.name ? ' · ' + mine.name : ''}\n${lines}\n${t('total')}: ${usd(o.total_cents)} (${llOf(o.total_cents)})`;
    return `<div class="done"><div class="ok">✓</div><h2>${t('thanks')}</h2><p>${t('thanks_sub')}</p><div class="code">${code}</div><div>${statusBox(o)}</div>
      <div style="display:grid;gap:10px;max-width:420px;margin:18px auto 0">${HOME.wa ? `<a class="btn wa" target="_blank" rel="noopener" href="https://wa.me/${HOME.wa}?text=${encodeURIComponent(msg)}">${t('send_wa')}</a>` : ''}<a class="btn ghost" href="#/orders">${t('track')}</a><a class="btn ghost" href="#/">${t('keep')}</a></div></div>`;
  }
  function vCart(err = '') {
    if (!cart.length) return `<h2 class="sec">${t('cart')}</h2>` + empty('🛒', t('cart_empty'), t('cart_empty_sub')) + `<p style="text-align:center"><a class="btn" href="#/">${t('keep')}</a></p>`;
    return `<h2 class="sec">${t('cart')}</h2><div class="box">${cart.map((l) => `<div class="ln"><div class="th">${pic(l)}</div><div class="nm">${esc(nm(l))}<small>${usd(l.price_cents)} ${unitTxt(l)}</small></div>
      <div class="step"><button data-cq="-1" data-id="${l.id}">−</button><span>${l.qty}</span><button data-cq="1" data-id="${l.id}">+</button></div></div>`).join('')}
      <div class="tot" style="margin-top:12px"><span>${t('total')}</span><span>${usd(total())}</span></div><div style="text-align:end;color:var(--mut)">${llOf(total())}</div></div>
      <div class="box"><h3 style="margin:0 0 10px">${t('your_details')}</h3>
      <div class="seg"><button data-mode="pickup" class="${mode === 'pickup' ? 'on' : ''}">🛍️ ${t('pickup')}</button><button data-mode="delivery" class="${mode === 'delivery' ? 'on' : ''}">🚚 ${t('delivery')}</button></div>
      <label class="f">${t('name')}<input id="f-name" autocomplete="name" value="${esc(me.name)}"></label>
      <label class="f">${t('phone')}<input id="f-phone" type="tel" inputmode="tel" autocomplete="tel" placeholder="03 123 456" value="${esc(me.phone)}"></label>
      ${mode === 'delivery' ? `<label class="f">${t('address')}<textarea id="f-addr" rows="2" autocomplete="street-address">${esc(me.address)}</textarea></label>` : ''}
      <label class="f">${t('note')}<input id="f-note"></label>
      ${err ? `<div class="err">${esc(err)}</div>` : ''}${HOME.open ? '' : `<div class="err">${t('closed_msg')}</div>`}
      <button class="btn full" data-act="place" ${HOME.open ? '' : 'disabled'}>${t('place')} · ${usd(total())}</button><p style="text-align:center;color:var(--mut);font-size:13px;margin:10px 0 0">${t('pay_note')}</p></div>`;
  }
  async function place() {
    me = { name: $('#f-name').value.trim(), phone: $('#f-phone').value.trim(), address: ($('#f-addr')?.value || me.address).trim() }; save();
    const btn = $('[data-act=place]'); btn.disabled = true; btn.textContent = t('placing');
    try {
      const r = await api('/api/shop/order', { method: 'POST', body: { ...me, mode, address: mode === 'delivery' ? me.address : '', note: $('#f-note').value, lines: cart.map((l) => ({ item_id: l.id, qty: l.qty })) } });
      myOrders.unshift({ code: r.code, at: Date.now(), name: me.name, items: cart.map((l) => ({ item_id: l.id })) }); myOrders = myOrders.slice(0, 20); cart = []; save(); location.hash = '#/done/' + r.code;
    } catch (e) { const keepNote = $('#f-note').value; $('#main').innerHTML = vCart(e.message); $('#f-note').value = keepNote; }
  }

  // ---- cart ops ----
  const snap = (i, qty) => ({ id: i.id, name: i.name, name_ar: i.name_ar, price_cents: i.price_cents, unit: i.unit, has_image: i.has_image, v: i.v, category: i.category, qty });
  function addItem(id, qty) { const i = ITEMS.get(id); if (!i) return; const l = cart.find((x) => x.id === id); if (l) l.qty = Math.round((l.qty + qty) * 100) / 100; else cart.push(snap(i, qty)); save(); chrome(path()); }
  const path = () => (location.hash || '#/').slice(1) || '/';
  let timer = 0;
  async function route() {
    clearInterval(timer); const p = path(); const main = $('#main'); chrome(p); window.scrollTo(0, 0);
    try {
      let m;
      if (p === '/') main.innerHTML = await vHome();
      else if (p === '/cats') main.innerHTML = await vCats();
      else if ((m = p.match(/^\/c\/(.+)$/))) main.innerHTML = await vList({ category: decodeURIComponent(m[1]) }, catName(decodeURIComponent(m[1])));
      else if ((m = p.match(/^\/s\/(.+)$/))) main.innerHTML = await vList({ q: decodeURIComponent(m[1]) }, '“' + decodeURIComponent(m[1]) + '”');
      else if ((m = p.match(/^\/i\/(\d+)$/))) main.innerHTML = await vItem(+m[1]);
      else if (p === '/saved') main.innerHTML = await vSaved();
      else if (p === '/orders') { main.innerHTML = await vOrders(); timer = setInterval(async () => { if (path() === '/orders') $('#main').innerHTML = await vOrders().catch(() => $('#main').innerHTML); }, 20000); }
      else if (p === '/cart') main.innerHTML = vCart();
      else if ((m = p.match(/^\/done\/([A-Z0-9]{6})$/))) { main.innerHTML = await vDone(m[1]); timer = setInterval(async () => { if (path().startsWith('/done')) $('#main').innerHTML = await vDone(m[1]).catch(() => $('#main').innerHTML); }, 20000); }
      else main.innerHTML = await vHome();
    } catch (e) { main.innerHTML = empty('📡', 'Connection problem', esc(e.message)); }
    if (!p.startsWith('/s/') && $('#q') && document.activeElement !== $('#q')) $('#q').value = '';
  }

  // ---- events ----
  document.addEventListener('click', async (e) => {
    const g = (s) => e.target.closest(s);
    let b;
    if ((b = g('[data-add]'))) { e.stopPropagation(); const i = ITEMS.get(+b.dataset.add); addItem(+b.dataset.add, step(i || {})); toast(t('added')); return; }
    if ((b = g('[data-addq]'))) { const id = +b.dataset.addq, l = cart.find((x) => x.id === id), i = ITEMS.get(id); if (l) l.qty = pq; else cart.push(snap(i, pq)); save(); toast(t('added')); if (history.length > 1) history.back(); else location.hash = '#/'; return; }
    if ((b = g('[data-pq]'))) { const i = ITEMS.get(+b.dataset.id); pq = Math.max(step(i), Math.round((pq + (+b.dataset.pq) * step(i)) * 100) / 100); $('#pq').textContent = pq; return; }
    if ((b = g('[data-cq]'))) { const l = cart.find((x) => x.id === +b.dataset.id), s = step(l); l.qty = Math.round((l.qty + (+b.dataset.cq) * s) * 100) / 100; if (l.qty <= 0) cart = cart.filter((x) => x !== l); save(); chrome(path()); $('#main').innerHTML = vCart(); return; }
    if ((b = g('[data-wish]'))) { const id = +b.dataset.wish; wish = wish.includes(id) ? wish.filter((x) => x !== id) : [id, ...wish]; save(); b.classList.toggle('on', wish.includes(id)); return; }
    if ((b = g('[data-mode]'))) { mode = b.dataset.mode; me.name = $('#f-name').value; me.phone = $('#f-phone').value; save(); $('#main').innerHTML = vCart(); return; }
    if ((b = g('[data-reorder]'))) { const o = myOrders.find((x) => x.code === b.dataset.reorder); const ids = (o?.items || []).map((x) => x.item_id); if (ids.length) { keep((await api('/api/shop/items?limit=60&ids=' + ids.join(','))).items); const lines = (await api('/api/shop/orders?codes=' + o.code))[0].items; lines.forEach((l) => ITEMS.has(l.item_id) && addItem(l.item_id, l.qty)); location.hash = '#/cart'; } return; }
    if ((b = g('[data-act]'))) { const a = b.dataset.act; if (a === 'lang') { lang = lang === 'ar' ? 'en' : 'ar'; LS.set('lang', lang); shell(); route(); } else if (a === 'more') more(); else if (a === 'place') place(); return; }
    if ((b = g('[data-go]'))) { location.hash = b.dataset.go; }
  });
  window.addEventListener('hashchange', route);
  if ('serviceWorker' in navigator) navigator.serviceWorker.register('/sw.js').catch(() => {});
  api('/api/shop/home').then((h) => { HOME = h; }).catch(() => {}).finally(() => { shell(); route(); });
})();
