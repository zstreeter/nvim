#!/bin/sh
# Smoke test: config must boot headless with no errors and pass tests/smoke.lua.
set -e
cd "$(dirname "$0")/.."

out=$(nvim --headless "+lua dofile('tests/smoke.lua')" +qa 2>&1) || true
printf '%s\n' "$out"
printf '%s' "$out" | grep -q 'SMOKE-PASS' || { echo "smoke.lua failed"; exit 1; }
printf '%s' "$out" | grep -qi 'E5108\|stack traceback' && { echo "runtime errors during boot"; exit 1; }

# structural: exactly one copy of the kind glyph table (lua/config/icons.lua)
dups=$(grep -rln 'EnumMember = "' lua | grep -v 'lua/config/icons.lua' || true)
if [ -n "$dups" ]; then
	echo "duplicated kind table in: $dups"
	exit 1
fi

echo PASS
