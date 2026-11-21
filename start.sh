#!/bin/sh
# Started by Anvil when a qwen model is first used; stopped when Anvil quits.
set -eu
# Chrome makes the upstream's anti-bot tokens far more reliable; without one it falls back to a weaker path.
if ( . ./find-chrome.sh ) 2>/dev/null; then . ./find-chrome.sh; else export USE_CHROME_BAXIA=false; fi
export PORT="${PORT:-38765}"
cd upstream
exec node -r ../localhost-only.cjs index.js
