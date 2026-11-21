#!/bin/sh
# Started by Anvil when a qwen model is first used; stopped when Anvil quits.
set -eu
# Chrome makes the upstream's anti-bot tokens far more reliable; without one it falls back to a weaker path.
if ( . ./find-chrome.sh ) 2>/dev/null; then . ./find-chrome.sh; else export USE_CHROME_BAXIA=false; fi
# Anvil hands over the signed-in cookie when the owner has connected an account.
if [ -n "${ANVIL_PROVIDER_COOKIES:-}" ]; then
  QWEN_TOKEN=$(node -e 'try{const c=JSON.parse(process.env.ANVIL_PROVIDER_COOKIES);process.stdout.write(c.token||"")}catch(e){}')
  [ -n "$QWEN_TOKEN" ] && export QWEN_TOKEN
fi
export PORT="${PORT:-38765}"
cd upstream
exec node -r ../localhost-only.cjs index.js
