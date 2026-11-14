# Keep Eddy OS online (macOS)

1. Stop the manual app and tunnel sessions.
2. Test the script once: `./deploy/start-eddy.sh` (Ctrl+C to stop).
3. Always-on: edit the path inside `deploy/com.ci.eddy.plist`, then
   `cp deploy/com.ci.eddy.plist ~/Library/LaunchAgents/ && launchctl load ~/Library/LaunchAgents/com.ci.eddy.plist`
4. Logs: `logs/app.log`, `logs/tunnel.log`. Stop: `launchctl unload ~/Library/LaunchAgents/com.ci.eddy.plist`.

Example items (with photos) are added on every start while `SEED_DEMO=1`. They never overwrite edits; set `SEED_DEMO=0` after importing the real catalogue.

## Best setup for a real shop: run it on the shop's own computer
Run Eddy OS on the counter laptop (or any always-on PC in the shop) and open `http://localhost:3000` there. The till then keeps working when the internet is down. The tunnel (eddy.ci-ccg.com) is only for remote access, phones and the price screen.

- **Windows:** install Node 22+, then use `deploy\start-eddy.bat`. To start it at boot:
  `schtasks /create /tn EddyOS /tr "C:\path\to\eddymarket\deploy\start-eddy.bat" /sc onstart /ru SYSTEM`
- **Mac:** `start-eddy.sh` with the launchd steps above.

## Backups
- A snapshot of the whole database is saved automatically every day (newest 30 kept) in `data/backups/`. Set `BACKUP_DIR` to save them to a USB drive or a cloud-synced folder as well.
- Owners can press Back up now or download a backup in Settings.
- **Restore:** stop the app, copy the chosen backup over `data/<store>.db` (delete any `-wal` and `-shm` files next to it), then start the app.

## Offline
The app installs on phones (Add to Home screen) and its screens load from the last copy when the connection drops. A red bar shows while the connection is lost and clears by itself. Sales are always saved by the server, so keep the server on the shop's own computer for true offline selling.

## Receipt printer + cash drawer (ZyWell ZY908)

Settings → Receipt printer. The till draws the receipt as a picture (so Arabic prints correctly) and the server sends it to the printer as ESC/POS. The drawer plugs into the printer's RJ11/RJ12 port and opens by itself on cash sales.

- **Network (best):** hold FEED while powering on to print the self-test page; it shows the printer's IP. Choose "Network printer", enter the IP, port 9100. Give the printer a fixed IP in the router.
- **USB on Windows:** Devices & Printers → share the ZY908 (e.g. name `ZY908`), choose "Windows shared printer", enter that name. The server must run on that PC.
- **USB on Mac/Linux:** add the printer, choose "Mac / Linux printer", enter its CUPS name.
- **Browser mode:** the normal print dialog. For no dialog, start Chrome with `--kiosk-printing`.

Use "Test print" and "Open drawer" to check. Not yet tested on the real ZY908.
