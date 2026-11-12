# Needs & next steps

## A. Blockers / decisions (need Crispin)
1. **Goal.** What do we want from this system: keep running it as-is for Eddy Market, customize it, host it, or rebuild it as a web POS (e.g. under Ci)?
2. **Source code.** Only compiled binaries were delivered. The build path embedded in the debug file is `D:\MyProjects\FlexiBillsAccounting`, so a Visual Studio solution exists somewhere. We need it (or written confirmation that we only operate/customize the DB and reports). Ownership and licence terms of FlexiBills must be confirmed.
3. **Licences.** The app bundles DevExpress v19.1 and v24.2 (commercial). We need valid licences before redistributing or deploying beyond the current machine.
4. **Which modules Eddy Market actually uses.** The schema is a generic ERP. For a market we expect: items, barcodes/labels, sales invoices and returns, purchasing, customers, vendors, cash/bank accounts, multi-currency. Cars, Gym, Prescriptions, Frame jobs and Internet subscriptions are likely unused.

## B. Security – do first
1. The archive contains a **live SQL Server login (`sa`) for a remote host** in `MyConnections.txt`, plus weak `sa/sa` logins for local databases in the same file and in `FlexiBillsAccounting.exe.config`. **Rotate the remote `sa` password now**, stop using `sa` for the app (create a least-privilege login), and close the SQL port to the internet if it is open.
2. `FireStoreKeyBase.json` is a Firebase/Firestore key file. Treat it as compromised-by-sharing: regenerate it in the Firebase console if it was ever shared outside Eddy Market.
3. Those files are excluded by `.gitignore`; config templates in `config/` have placeholders only.

## C. Technical setup (to get a working copy)
1. Install SQL Server (version to confirm) and create the database from `database/EmptyDB.sql`, or from `database/schema/` scripts. Seed data / real Eddy Market data is **not** in the archive – we need a `.bak` backup of the live database.
2. Machine prerequisites: .NET Framework 4.x, WebView2 runtime, SQL Server spatial types, ACE OLEDB 12 (only for the Gym door-card integration; not needed for a market).
3. Copy the app folder, set the connection string from `config/FlexiBillsAccounting.exe.config.example`.
4. External services referenced by the config: Firebase Firestore (purpose to confirm: licence check or cloud sync), `webservice.moursel.com` (SMS), Zeller payments SDK, a price-checker database (`FlexiBillsPriceChecker`).
5. Hardware to confirm: receipt printer, barcode scanner, label printer (the layouts include 30x15, 40x27, 58x40, A4 label sheets), cash drawer.

## D. Archive integrity
- 660 of 663 files extracted cleanly. Three failed a CRC check in my extractor: `DevExpress.Utils.v19.1.dll`, `DevExpress.Utils.v24.2.dll`, `FlexiBillsAccounting.pdb`. This may be my tool rather than the archive; re-test with WinRAR on the original PC. Both DevExpress DLLs can be reinstalled from the vendor.
- The app's own `Handle global exceptions/Text.log` shows a recent SQL error (July 2026): `Arithmetic overflow ... numeric` when saving an invoice with the `@Detail` table-valued parameter (state 8115). Worth investigating – likely a decimal precision/size mismatch on a quantity or price column.

## E. Suggested order
1. Rotate credentials (B) → 2. confirm goal and licences (A) → 3. get live `.bak` + source (A2, C1) → 4. stand up a test copy (C) → 5. fix the invoice overflow bug (D) → 6. customize / extend.
