#!/bin/bash
# One-time setup for the Mac that runs Eddy: starts by itself after a power cut or restart, and restarts if it ever stops.
# Usage:  deploy/install-mac.sh
set -e
cd "$(dirname "$0")/.."; ROOT="$PWD"; PL="$HOME/Library/LaunchAgents/com.ci.eddy.plist"
mkdir -p "$HOME/Library/LaunchAgents" logs; chmod +x deploy/start-eddy.sh
sed "s|REPLACE_WITH_FULL_PATH/eddymarket|$ROOT|" deploy/com.ci.eddy.plist > "$PL"
launchctl bootout "gui/$(id -u)" "$PL" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$PL"
echo "Eddy now starts automatically when this Mac starts, and restarts if it stops."
echo "Next: the Mac itself must power on and sign in after a power cut. Asking for your Mac password once:"
sudo pmset -a autorestart 1 sleep 0 disksleep 0 womp 1
echo "Done: the Mac turns itself back on after a power cut and never sleeps."
echo "ONE MORE STEP by hand: System Settings > Users & Groups > Automatic login > choose this user."
echo "(Automatic login needs FileVault turned off. Without it the Mac waits at the login screen after a power cut.)"
