#!/bin/bash
# Starts Eddy OS and its Cloudflare tunnel (eddy.ci-ccg.com) and keeps both alive.
# Usage: ./deploy/start-eddy.sh        (run by launchd on boot, see deploy/README.md)
cd "$(dirname "$0")/.." || exit 1
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
export STORE_ID="${STORE_ID:-eddy}" PORT="${PORT:-3187}" DATA_DIR="${DATA_DIR:-$PWD/data}"
export SEED_DEMO="${SEED_DEMO:-0}"        # 0 = real catalogue only (set 1 to load example items)
export SHOP_WA="${SHOP_WA:-96181852775}"   # store WhatsApp number for online orders (only used until set in Settings)
# Optional: sharper HD product photos from Google Images through serper.dev. Put your key in ~/.eddy-env as SERPER_KEY=... (never in the repo)
[ -f "$HOME/.eddy-env" ] && set -a && . "$HOME/.eddy-env" && set +a
TUNNEL_CFG="${TUNNEL_CFG:-$HOME/.cloudflared/eddy.yml}"
mkdir -p "$DATA_DIR" logs
pids=()
cleanup() { kill "${pids[@]}" 2>/dev/null; exit 0; }
trap cleanup INT TERM
( while true; do node --disable-warning=ExperimentalWarning server.js >> logs/app.log 2>&1; echo "$(date) app stopped, restarting" >> logs/app.log; sleep 3; done ) & pids+=($!)
sleep 2
( while true; do cloudflared tunnel --config "$TUNNEL_CFG" run eddy >> logs/tunnel.log 2>&1; echo "$(date) tunnel stopped, restarting" >> logs/tunnel.log; sleep 5; done ) & pids+=($!)
# watchdog: if Eddy stops answering for ~1.5 minutes (frozen, not crashed), restart it
( fails=0; while true; do sleep 30; if curl -fs -m 8 "http://localhost:$PORT/api/settings" >/dev/null; then fails=0; else fails=$((fails+1)); fi
  if [ "$fails" -ge 3 ]; then echo "$(date) not answering, restarting app" >> logs/app.log; pkill -f "node --disable-warning=ExperimentalWarning server.js"; fails=0; sleep 20; fi; done ) & pids+=($!)
wait
