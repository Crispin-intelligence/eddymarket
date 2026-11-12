# Findings from the live database backup

Backup: `FlexiBills2020`, taken 2026-10-25 (restored locally into SQL Server 2022 for analysis; the `.bak` is NOT stored in this repo).
Only aggregate facts are recorded here – no customer or transaction data.

## Size of the business data
| Data | Rows |
|---|---|
| Items (`Items.t_ItemShared`) | 3,577 |
| Barcodes (`Items.t_ItemSharedBarCode`) | 5,051 (every item has at least one) |
| Sales invoices (`Invoices.t_Sold`) | 61,133 (2024-11-18 → 2026-10-25), ~3,000 in the last 30 days |
| Sales lines (`Invoices.t_SoldDetail`) | 146,838 |
| Purchase invoices | 1,787 |
| Accounts (customers/vendors/etc.) | 200 |
| CRM records (`Customers.t_CRM`) | 277,761 – contains personal data, handle with care |

## How a price lookup works
barcode → `Items.t_ItemSharedBarCode` → `Items.t_ItemShared` (name, category) → `Items.t_UnityItem` (price, primary unit) → stock in `Items.t_Item`.
See `sql/price_lookup.sql`. It works on real data.

## Things that affect the Ci layer
- **Prices are in USD** with the LL equivalent stored (observed rate 90,000 LL per $). The kiosk should show both.
- **Names are mixed**: Arabic, English and abbreviations (e.g. brand-only names). Voice search needs fuzzy matching on both scripts.
- **Categories are mostly empty**: 3,204 of 3,577 items have no category.
- **Stock is unreliable**: 416 items show negative stock and 1,513 show zero. Do not show "in stock / out of stock" to customers until stock is cleaned.
- **Almost no photos**: only ~243 items have a real image; the rest hold a 1x1 placeholder. The camera/screen idea needs a photo set first.
- The program already has a "price checker" feature (`Items.t_ItemSharedPriceCheckerView`, 114 items) and a `FlexiBillsPriceChecker` database reference – worth learning how Eddy Market uses it.

## Suggested cleanup before smart features
1. Item categories (3,204 uncategorized)
2. A stock take to fix negative/zero stock
3. Product photos, at least for the top sellers (we can find top sellers from the sales lines)
