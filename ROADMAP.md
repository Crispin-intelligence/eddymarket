# Roadmap

## Done (v0.1)
Till, USD/LL pricing, receipts and void, items with photos and CSV import, dashboard, team and roles, customer price screen with scan, voice and camera, Arabic and English.

## Next: make it Eddy Market's
1. Import the real item list (3,577 items in the old system) and agree categories.
2. Stock take to fix negative and zero stock, then switch on "in stock" on the price screen.
3. Photos for the top sellers (the old sales data tells us which).
4. Receipt printer and barcode scanner tested on the real counter.
5. Move the old sales history in for reports (optional).

## Then: run the shop
Purchasing from vendors and stock receiving, returns, customer accounts and credit, end-of-day cash count, reports by category and cashier, discounts and promotions, offline mode for the till.

## Then: the smart parts
- Customer screen: recognise a product from the camera image, answer "what's on offer today?", show stock by shelf.
- Ci in the shop: ask questions in plain language ("what sold least this week?"), WhatsApp daily summary to the owner, low-stock alerts, reorder suggestions.

## Selling to other shops
One instance per shop already keeps data separate. Needed: a simple installer or hosted setup, per-shop branding (logo, colours), an invoicing and support plan, and data import from other POS exports.

## Known limits
Single till database (SQLite); fine for one shop, not for a chain. The till needs the server to be reachable. Free browser speech recognition quality varies by device and language.
