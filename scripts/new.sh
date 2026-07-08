#!/usr/bin/env bash
# Scaffold a new Codeforces problem folder from the template.
#
# Usage:  ./scripts/new.sh <id> <title...>
#   e.g.  ./scripts/new.sh 4A watermelon
#         ./scripts/new.sh 1742C deletion-of-repeating
#
# Creates problems/<id>-<slug>/ with main.cpp and one empty sample (tests/1.in, 1.out).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ID="${1:-}"
shift || true
TITLE_RAW="$*"

if [[ -z "$ID" || -z "$TITLE_RAW" ]]; then
    echo "Usage: ./scripts/new.sh <id> <title...>" >&2
    echo "Example: ./scripts/new.sh 4A watermelon" >&2
    exit 1
fi

# slugify the title: lowercase, spaces -> dashes, strip non [a-z0-9-]
slug=$(echo "$TITLE_RAW" | tr '[:upper:] ' '[:lower:]-' | tr -cd 'a-z0-9-')
dir="$ROOT/problems/${ID}-${slug}"

if [[ -d "$dir" ]]; then
    echo "Already exists: problems/${ID}-${slug}" >&2
    exit 1
fi

mkdir -p "$dir/tests"
sed \
    -e "s|# Template|# ${ID} — ${TITLE_RAW}|" \
    -e "s|https://codeforces.com/problemset/problem/0/0|https://codeforces.com/problemset/problem/${ID%%[A-Za-z]*}/${ID##*[0-9]}|" \
    "$ROOT/template/main.cpp" > "$dir/main.cpp"

: > "$dir/tests/1.in"
: > "$dir/tests/1.out"

echo "Created problems/${ID}-${slug}/"
echo "  1. Paste the sample input  -> problems/${ID}-${slug}/tests/1.in"
echo "  2. Paste the sample output -> problems/${ID}-${slug}/tests/1.out"
echo "     (add 2.in/2.out, 3.in/3.out ... for more samples)"
echo "  3. Write your solution     -> problems/${ID}-${slug}/main.cpp"
echo "  4. Check it                -> ./scripts/test.sh ${ID}-${slug}"
