#!/bin/sh
# One-time setup, run by Anvil from this folder: downloads qwen2api at a pinned commit and installs it.
set -eu
REPO="https://github.com/smanx/qwen2api.git"
COMMIT="54f7993cbcb4a2dd5ae7210759fbe574a4c09f7a"

command -v node >/dev/null || { echo "Node.js 18+ is required: brew install node" >&2; exit 1; }
command -v git >/dev/null || { echo "git is required (xcode-select --install)" >&2; exit 1; }

if [ ! -d upstream/.git ]; then
  rm -rf upstream
  git clone --quiet --depth 50 "$REPO" upstream
fi
git -C upstream fetch --quiet origin "$COMMIT" 2>/dev/null || git -C upstream fetch --quiet origin
git -C upstream checkout --quiet --force "$COMMIT"
npm --prefix upstream install --omit=dev --ignore-scripts --no-audit --no-fund --loglevel=error
echo "qwen2api ready at $(git -C upstream rev-parse --short HEAD)"
