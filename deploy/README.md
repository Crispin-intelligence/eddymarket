# Keep Eddy OS online (macOS)

1. Stop the manual app and tunnel sessions.
2. Test the script once: `./deploy/start-eddy.sh` (Ctrl+C to stop).
3. Always-on: edit the path inside `deploy/com.ci.eddy.plist`, then
   `cp deploy/com.ci.eddy.plist ~/Library/LaunchAgents/ && launchctl load ~/Library/LaunchAgents/com.ci.eddy.plist`
4. Logs: `logs/app.log`, `logs/tunnel.log`. Stop: `launchctl unload ~/Library/LaunchAgents/com.ci.eddy.plist`.

Example items (with photos) are added on every start while `SEED_DEMO=1`. They never overwrite edits; set `SEED_DEMO=0` after importing the real catalogue.
