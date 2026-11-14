#!/bin/bash
# Starts Eddy OS and its Cloudflare tunnel (eddy.ci-ccg.com) and keeps both alive.
# Usage: ./deploy/start-eddy.sh        (run by launchd on boot, see deploy/README.md)
cd "$(dirname "$0")/.." || exit 1
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
export STORE_ID="${STORE_ID:-eddy}" PORT="${PORT:-3000}" DATA_DIR="${DATA_DIR:-$PWD/data}"
export SEED_DEMO="${SEED_DEMO:-1}"        # 1 = keep the example items; set to 0 once the real catalogue is imported
export SHOP_WA="${SHOP_WA:-96181852775}"   # store WhatsApp number for online orders (only used until set in Settings)
TUNNEL_CFG="${TUNNEL_CFG:-$HOME/.cloudflared/eddy.yml}"
mkdir -p "$DATA_DIR" logs
pids=()
cleanup() { kill "${pids[@]}" 2>/dev/null; exit 0; }
trap cleanup INT TERM
( while true; do node --disable-warning=ExperimentalWarning server.js >> logs/app.log 2>&1; echo "$(date) app stopped, restarting" >> logs/app.log; sleep 3; done ) & pids+=($!)
sleep 2
( while true; do cloudflared tunnel --config "$TUNNEL_CFG" run eddy >> logs/tunnel.log 2>&1; echo "$(date) tunnel stopped, restarting" >> logs/tunnel.log; sleep 5; done ) & pids+=($!)
wait
