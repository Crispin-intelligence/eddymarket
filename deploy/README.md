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
