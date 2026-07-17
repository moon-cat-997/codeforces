#!/usr/bin/env bash
# Format C++ solutions in place with clang-format (uses ./.clang-format).
#
# Usage:
#   ./scripts/fmt.sh <slug-or-path>   # format one problem's main.cpp
#   ./scripts/fmt.sh                  # format ALL problems + template
#   ./scripts/fmt.sh --check <...>    # report which files WOULD change, edit nothing
#
# On-demand only — nothing auto-runs on save, so your dense one-line CP style
# stays until you ask for it. clang-format is already installed (clang package).
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v clang-format >/dev/null 2>&1; then
    echo "clang-format not found (install the 'clang' package)." >&2
    exit 1
fi

CHECK=0
ARG=""
for a in "$@"; do
    case "$a" in
        --check|-n) CHECK=1 ;;
        *)          [[ -z "$ARG" ]] && ARG="$a" ;;
    esac
done

if [[ -t 1 ]]; then GRN=$'\e[32m'; YEL=$'\e[33m'; DIM=$'\e[2m'; RST=$'\e[0m'
else GRN=; YEL=; DIM=; RST=; fi

# ---- collect the target files ----
files=()
if [[ -z "$ARG" ]]; then
    shopt -s nullglob
    files=("$ROOT"/problems/*/main.cpp "$ROOT"/template/main.cpp)
else
    # resolve like test.sh: path, slug, or id prefix
    if [[ -f "$ARG" ]]; then
        files=("$ARG")
    elif [[ -d "$ARG" && -f "$ARG/main.cpp" ]]; then
        files=("$ARG/main.cpp")
    elif [[ -f "$ROOT/problems/$ARG/main.cpp" ]]; then
        files=("$ROOT/problems/$ARG/main.cpp")
    else
        match=$(find "$ROOT/problems" -maxdepth 1 -type d -name "${ARG}*" | head -1)
        [[ -n "$match" && -f "$match/main.cpp" ]] && files=("$match/main.cpp")
    fi
fi

if [[ ${#files[@]} -eq 0 ]]; then
    echo "No main.cpp found for '${ARG:-<all>}'." >&2
    exit 1
fi

changed=0
for f in "${files[@]}"; do
    rel="${f#"$ROOT"/}"
    if [[ $CHECK -eq 1 ]]; then
        if ! clang-format --style=file "$f" | diff -q "$f" - >/dev/null; then
            echo "${YEL}would reformat${RST} $rel"
            ((changed++))
        fi
    else
        if ! clang-format --style=file "$f" | diff -q "$f" - >/dev/null; then
            clang-format --style=file -i "$f"
            echo "${GRN}formatted${RST} $rel"
            ((changed++))
        fi
    fi
done

if [[ $changed -eq 0 ]]; then
    echo "${DIM}Nothing to change.${RST}"
elif [[ $CHECK -eq 1 ]]; then
    echo "${DIM}$changed file(s) would change (run without --check to apply).${RST}"
fi
