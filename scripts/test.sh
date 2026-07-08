#!/usr/bin/env bash
# Compile a solution and check it against every sample in its tests/ folder.
#
# Usage:  ./scripts/test.sh <slug-or-path> [-- <extra g++ flags>]
#   e.g.  ./scripts/test.sh 4A-watermelon
#         ./scripts/test.sh problems/4A-watermelon
#
# For each tests/N.in it runs the binary and diffs stdout against tests/N.out.
# Compiles with the same standard/flags Codeforces uses (GNU C++23, -O2),
# plus -DLOCAL so dbg(...) prints to stderr.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ARG="${1:-}"
if [[ -z "$ARG" ]]; then
    echo "Usage: ./scripts/test.sh <slug-or-path>" >&2
    exit 1
fi

# Resolve to a problem directory: accept a path, a slug, or an id prefix.
if [[ -d "$ARG" ]]; then
    DIR="$(cd "$ARG" && pwd)"
elif [[ -d "$ROOT/problems/$ARG" ]]; then
    DIR="$ROOT/problems/$ARG"
else
    match=$(find "$ROOT/problems" -maxdepth 1 -type d -name "${ARG}*" | head -1)
    [[ -n "$match" ]] && DIR="$match"
fi
if [[ -z "${DIR:-}" || ! -f "$DIR/main.cpp" ]]; then
    echo "No main.cpp found for '$ARG'" >&2
    exit 1
fi

# ---- colors (disabled when not a TTY) ----
if [[ -t 1 ]]; then RED=$'\e[31m'; GRN=$'\e[32m'; YEL=$'\e[33m'; DIM=$'\e[2m'; RST=$'\e[0m'
else RED=; GRN=; YEL=; DIM=; RST=; fi

CXX=${CXX:-g++}
FLAGS=(-std=gnu++23 -O2 -Wall -Wextra -DLOCAL)
BIN="$(mktemp -d)/sol"

echo "${DIM}Compiling $(basename "$DIR")/main.cpp ...${RST}"
if ! "$CXX" "${FLAGS[@]}" -o "$BIN" "$DIR/main.cpp"; then
    echo "${RED}Compilation failed.${RST}" >&2
    exit 1
fi

shopt -s nullglob
ins=("$DIR"/tests/*.in)
if [[ ${#ins[@]} -eq 0 ]]; then
    echo "${YEL}No sample tests in $DIR/tests/ — nothing to check.${RST}"
    exit 0
fi

# Normalize: drop trailing whitespace on each line; $(...) already strips the
# trailing newlines, so this makes the two sides directly comparable.
norm() { printf '%s\n' "$1" | sed 's/[[:space:]]*$//'; }

pass=0; fail=0
for in in $(printf '%s\n' "${ins[@]}" | sort -V); do
    name=$(basename "$in" .in)
    out="$DIR/tests/$name.out"
    got=$("$BIN" < "$in"); status=$?
    if [[ $status -ne 0 ]]; then
        echo "${RED}✗ $name — runtime error (exit $status)${RST}"
        ((fail++)); continue
    fi
    if [[ ! -f "$out" ]]; then
        echo "${YEL}? $name — no expected output; got:${RST}"
        echo "$got" | sed 's/^/    /'
        continue
    fi
    if [[ "$(norm "$got")" == "$(norm "$(cat "$out")")" ]]; then
        echo "${GRN}✓ $name${RST}"
        ((pass++))
    else
        echo "${RED}✗ $name${RST}"
        echo "    ${DIM}--- expected ---${RST}"; sed 's/^/    /' "$out"
        echo "    ${DIM}--- got --------${RST}"; echo "$got" | sed 's/^/    /'
        ((fail++))
    fi
done

echo "${DIM}─────────────${RST}"
if [[ $fail -eq 0 ]]; then
    echo "${GRN}All $pass sample(s) passed.${RST}"
else
    echo "${RED}$fail failed${RST}, ${GRN}$pass passed${RST}."
    exit 1
fi
