// If the service is put on hold while a page is already open, show the "coming soon" page instead of errors.
(() => { const f = window.fetch; window.fetch = async function (...a) { const r = await f.apply(this, a); if (r.status === 503 && r.headers.get('X-Eddy-Paused')) location.reload(); return r; }; })();
