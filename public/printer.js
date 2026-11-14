// Draws a receipt as a 1-bit bitmap for 80 mm thermal printers (576 dots wide), so Arabic text shapes correctly.
(() => {
  const W = 576, PAD = 14, FONT = '"IBM Plex Sans Arabic", "IBM Plex Sans", Arial, sans-serif';
  async function render(s, set, I) {
    const t = (k) => I.t(k), rtl = I.lang === 'ar';
    try { await Promise.all(['500', '700'].map((w) => document.fonts.load(`${w} 24px ${FONT}`, 'Aأب'))); } catch { /* fall back to system fonts */ }
    const cv = document.createElement('canvas'); cv.width = W; cv.height = 5000;
    const ctx = cv.getContext('2d'); ctx.fillStyle = '#fff'; ctx.fillRect(0, 0, W, cv.height); ctx.fillStyle = '#000'; ctx.textBaseline = 'alphabetic';
    let y = 8;
    const font = (size, bold) => { ctx.font = `${bold ? 700 : 500} ${size}px ${FONT}`; };
    const put = (text, x, align, dir) => { ctx.direction = dir; ctx.textAlign = align; ctx.fillText(text, x, y); };
    const startX = rtl ? W - PAD : PAD, endX = rtl ? PAD : W - PAD, startAl = rtl ? 'right' : 'left', endAl = rtl ? 'left' : 'right', dir = rtl ? 'rtl' : 'ltr';
    const center = (text, size, bold) => { font(size, bold); y += size; put(text, W / 2, 'center', dir); y += 8; };
    const rule = (dash) => { ctx.save(); ctx.strokeStyle = '#000'; ctx.lineWidth = dash ? 2 : 3; if (dash) ctx.setLineDash([8, 6]); y += 6; ctx.beginPath(); ctx.moveTo(PAD, y); ctx.lineTo(W - PAD, y); ctx.stroke(); ctx.restore(); y += 14; };
    const wrapLines = (text, size, bold, maxW) => {
      font(size, bold); ctx.direction = dir; const words = String(text).split(/\s+/), out = []; let cur = '';
      for (const w of words) { const test = cur ? cur + ' ' + w : w; if (ctx.measureText(test).width > maxW && cur) { out.push(cur); cur = w; } else cur = test; }
      if (cur) out.push(cur); return out;
    };
    const row = (left, right, size, bold) => {
      const rw = (() => { font(size, bold); ctx.direction = 'ltr'; return ctx.measureText(right || '').width; })();
      const lines = wrapLines(left, size, bold, W - PAD * 2 - rw - 16); if (!lines.length) lines.push('');
      lines.forEach((ln, i) => { font(size, bold); y += size + 2; put(ln, startX, startAl, dir); if (i === 0 && right) { ctx.direction = 'ltr'; ctx.textAlign = endAl; ctx.fillText(right, endX, y); } y += 4; });
    };
    center(set.store_name, 38, true);
    if (s.status === 'void') center(t('voided').toUpperCase(), 30, true);
    center(`${t('receipt')} #${s.id}`, 24, false);
    center(new Date(s.created_at).toLocaleString(rtl ? 'ar-LB-u-nu-latn' : 'en-GB', { timeZone: set.tz, dateStyle: 'medium', timeStyle: 'short' }), 22, false);
    center(`${t('cashier')}: ${s.user_name}`, 22, false);
    rule(true);
    for (const l of s.items) {
      row(l.name, I.usd(Math.round(l.qty * l.price_cents)), 25, true);
      if (l.qty !== 1) row(`${l.qty} × ${I.usd(l.price_cents)}`, '', 21, false);
    }
    rule(true);
    row(t('total'), I.usd(s.total_cents), 34, true);
    row('', I.ll(s.total_ll), 26, true);
    const paid = s.method === 'card' ? t('card') : `${t('cash')} ${s.currency === 'LL' ? I.ll(s.tendered) : I.usd(Math.round(s.tendered * 100))}`;
    row(t('paid_by'), paid, 23, false);
    if (s.change_cents) row(t('change'), I.usd(s.change_cents), 23, false);
    row(t('rate'), `$1 = ${Number(s.rate).toLocaleString('en-US')} LL`, 20, false);
    rule(false);
    if (set.footer) wrapLines(set.footer, 23, true, W - PAD * 2).forEach((ln) => center(ln, 23, true));
    y += 20;
    const out = document.createElement('canvas'); out.width = W; out.height = Math.ceil(y); out.getContext('2d').drawImage(cv, 0, 0);
    return out;
  }
  function toRaster(cv) {
    const { width: w, height: h } = cv, d = cv.getContext('2d').getImageData(0, 0, w, h).data, wb = w / 8, bytes = new Uint8Array(wb * h);
    for (let y = 0; y < h; y++) for (let x = 0; x < w; x++) { const i = (y * w + x) * 4; if ((d[i] + d[i + 1] + d[i + 2]) / 3 < 150) bytes[y * wb + (x >> 3)] |= 0x80 >> (x & 7); }
    let bin = ''; for (let i = 0; i < bytes.length; i += 8192) bin += String.fromCharCode.apply(null, bytes.subarray(i, i + 8192));
    return { w, h, data: btoa(bin) };
  }
  window.EddyPrint = { render, toRaster };
})();
