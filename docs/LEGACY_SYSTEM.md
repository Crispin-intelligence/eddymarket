# Legacy system (FlexiBillsAccounting) – what we found

Eddy Market currently runs on this installed Windows program. **Eddy OS replaces it**; this file records what was in the archive so we can migrate the data and keep what matters.

**Start with [`NEEDS.md`](NEEDS.md)** – it lists what is missing and what we must do next.

## What the system is
Extracted from `Program.rar` (Eddy Market's installed copy). It is a compiled Windows desktop
application, **FlexiBillsAccounting** (.NET Framework WinForms, DevExpress UI, SQL Server backend,
Arabic/English/French UI, currencies LL / USD / EUR). No source code was in the archive.

## What is in this repo
| Path | Contents |
|---|---|
| `database/schema/` | Full SQL Server schema as scripts: 298 tables, 1,463 views, 1,164 stored procedures, 451 functions, 49 types, security objects (from `Database.rar`) |
| `database/EmptyDB.sql` | Full empty-database create script (444 tables, DB name `FlexiBills2026`, generated 2026-03-28), converted to UTF-8 |
| `database/ObjectsDB.sql` | Companion objects script, converted to UTF-8 |
| `reports/ReportLayout-Original/` | 18 DevExpress report layouts (`.repx`): invoices, receipts, quotations, sell order, barcode/shelf labels |
| `config/` | Sanitized config templates – fill in real credentials locally, never commit them |

## Deliberately NOT in this repo
- `FlexiBillsAccounting.exe` (165 MB, over GitHub's 100 MB file limit) and all `.dll` / `.pdb` files (third-party, licensed DevExpress libraries)
- `MyConnections.txt`, `FireStoreKeyBase.json` – contain live credentials (see `NEEDS.md`)
- User state: `SaveLayoutGrid/`, `SaveLayoutTree/`, `Text.log`, calendar files
