#!/usr/bin/env bash

set -euo pipefail

NODE22_CANDIDATES=(
  "/opt/homebrew/opt/node@22/bin"
  "/usr/local/opt/node@22/bin"
)

for candidate in "${NODE22_CANDIDATES[@]}"; do
  if [ -x "$candidate/node" ]; then
    export PATH="$candidate:$PATH"
    break
  fi
done

DOCS_PORT="${DOCS_PORT:-3001}"

node_major="$(node -p 'process.versions.node.split(".")[0]')"

if [ "$node_major" -ge 25 ]; then
  cat >&2 <<'EOF'
Mintlify does not support Node 25+.

Install Homebrew node@22, then rerun:
  brew install node@22
  bun run docs:dev

Or run once with a temporary PATH override:
  PATH="/opt/homebrew/opt/node@22/bin:$PATH" bun run docs:dev
EOF
  exit 1
fi

exec npx mint dev --port "$DOCS_PORT"
