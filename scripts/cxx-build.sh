#!/usr/bin/env bash
# Build a single .cpp for debugging with the right GNU g++ on any machine.
#
# Used by .vscode/tasks.json as the F5 pre-launch build, so the committed VS Code
# config is portable across macOS and Linux — this script, not tasks.json, is
# what knows where g++ lives on each box.
#
# Usage:  scripts/cxx-build.sh <source.cpp> [output-binary]
#           output-binary defaults to /tmp/cf_debug_bin
#
# Picks the newest real GNU g++ (Homebrew g++-NN on macOS, versioned or plain
# g++ on Linux) so <bits/stdc++.h> and libstdc++ match Codeforces. Debug build:
# -O0 -g3 for faithful stepping, -D_GLIBCXX_DEBUG to trap out-of-bounds / bad
# iterators, -DLOCAL so dbg(...) is active. Override the compiler with CXX=...
set -uo pipefail

SRC="${1:-}"
OUT="${2:-/tmp/cf_debug_bin}"
if [[ -z "$SRC" ]]; then
    echo "Usage: scripts/cxx-build.sh <source.cpp> [output-binary]" >&2
    exit 2
fi

if [[ -z "${CXX:-}" ]]; then
    CXX=$(ls /opt/homebrew/bin/g++-* /usr/local/bin/g++-* /usr/bin/g++-* 2>/dev/null | sort -V | tail -1)
    CXX=${CXX:-g++}
fi

exec "$CXX" \
    -fdiagnostics-color=always \
    -std=gnu++23 -O0 -g3 -Wall -Wextra \
    -DLOCAL -D_GLIBCXX_DEBUG -fno-omit-frame-pointer \
    "$SRC" -o "$OUT"
