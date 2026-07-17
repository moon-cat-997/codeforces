#!/usr/bin/env bash
# Debug a solution — two modes.
#
# Usage:
#   ./scripts/debug.sh <slug-or-path> [N]           # sanitizer run (default)
#   ./scripts/debug.sh <slug-or-path> --gdb [N]     # interactive gdb session
#
#   N selects tests/N.in as the program's stdin (default: 1, if it exists).
#   With no usable N.in the program reads from your keyboard (Ctrl+D to end).
#
# Sanitizer mode compiles with AddressSanitizer + UBSan + libstdc++ debug mode
# (-D_GLIBCXX_DEBUG) and -g, then runs the solution on the chosen input. It
# catches the bugs a plain run hides: out-of-bounds vector access (even a[0] on
# an empty vector), signed overflow, use-after-free, bad iterators — printing a
# precise file:line the moment they happen. stdout, stderr (your dbg(...)), and
# any sanitizer report are all shown.
#
# gdb mode builds an un-sanitized debug binary (-O0 -g), breaks at solve(), and
# drops you into gdb with the input already wired up. Handy gdb commands:
#   n (next)  s (step)  c (continue)  p <expr> (print)  bt (backtrace)  q (quit)
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ---- parse args: <problem> [--gdb] [N], order-independent for the flag ----
# The problem token comes first; a bare all-digits token counts as N only once
# the problem is set (slugs like "489B" start with a digit, so order matters).
ARG=""; USE_GDB=0; TESTNUM=""
for a in "$@"; do
    if [[ "$a" == "--gdb" || "$a" == "-g" ]]; then
        USE_GDB=1
    elif [[ -z "$ARG" ]]; then
        ARG="$a"
    elif [[ "$a" =~ ^[0-9]+$ ]]; then
        TESTNUM="$a"
    fi
done

if [[ -z "$ARG" ]]; then
    echo "Usage: ./scripts/debug.sh <slug-or-path> [--gdb] [N]" >&2
    exit 1
fi

# ---- resolve to a problem directory: path, slug, or id prefix (as test.sh) ----
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

# ---- pick the input file ----
INPUT="$DIR/tests/${TESTNUM:-1}.in"
if [[ ! -f "$INPUT" ]]; then
    if [[ -n "$TESTNUM" ]]; then
        echo "${RED}No such input: tests/$TESTNUM.in${RST}" >&2
        exit 1
    fi
    INPUT=""   # no default sample — fall back to keyboard input
fi

# ---- compiler: newest GNU g++ (Homebrew on macOS, versioned or plain on Linux) ----
if [[ -z "${CXX:-}" ]]; then
    CXX=$(ls /opt/homebrew/bin/g++-* /usr/local/bin/g++-* /usr/bin/g++-* 2>/dev/null | sort -V | tail -1)
    CXX=${CXX:-g++}
fi

BIN="$(mktemp -d)/dbg"

if [[ $USE_GDB -eq 1 ]]; then
    # -------- interactive gdb --------
    FLAGS=(-std=gnu++23 -O0 -g3 -Wall -Wextra -DLOCAL -D_GLIBCXX_DEBUG -fno-omit-frame-pointer)
    echo "${DIM}Compiling (debug, -O0 -g) $(basename "$DIR")/main.cpp ...${RST}"
    if ! "$CXX" "${FLAGS[@]}" -o "$BIN" "$DIR/main.cpp"; then
        echo "${RED}Compilation failed.${RST}" >&2
        exit 1
    fi
    GDB_ARGS=(-q "$BIN" -ex "set debuginfod enabled off" -ex "break solve" -ex "set print pretty on")
    if [[ -n "$INPUT" ]]; then
        echo "${DIM}Feeding $(basename "$INPUT") to stdin; stopping at solve().${RST}"
        GDB_ARGS+=(-ex "run < $INPUT")
    else
        echo "${DIM}No sample input; type the input yourself after 'run'.${RST}"
    fi
    exec gdb "${GDB_ARGS[@]}"
fi

# -------- sanitizer run (default) --------
FLAGS=(-std=gnu++23 -O1 -g -Wall -Wextra -DLOCAL
       -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC
       -fsanitize=address,undefined -fno-sanitize-recover=all -fno-omit-frame-pointer)
echo "${DIM}Compiling (ASan+UBSan+_GLIBCXX_DEBUG) $(basename "$DIR")/main.cpp ...${RST}"
if ! "$CXX" "${FLAGS[@]}" -o "$BIN" "$DIR/main.cpp"; then
    echo "${RED}Compilation failed.${RST}" >&2
    exit 1
fi

export ASAN_OPTIONS="abort_on_error=0:detect_leaks=1:color=always"
export UBSAN_OPTIONS="print_stacktrace=1:color=always"

if [[ -n "$INPUT" ]]; then
    echo "${DIM}Running on $(basename "$INPUT") ...${RST}"
    echo "${DIM}─── stdout ───${RST}"
    "$BIN" < "$INPUT"; status=$?
else
    echo "${YEL}No sample input — type it now (Ctrl+D to end):${RST}"
    echo "${DIM}─── stdout ───${RST}"
    "$BIN"; status=$?
fi

echo "${DIM}──────────────${RST}"
if [[ $status -eq 0 ]]; then
    echo "${GRN}Exited cleanly (0) — no sanitizer errors.${RST}"
else
    echo "${RED}Exited with status $status${RST} ${DIM}(sanitizer/runtime report above).${RST}"
fi
exit $status
