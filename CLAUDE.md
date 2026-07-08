# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal workspace for solving Codeforces problems in C++ **and** for the user learning/re-learning competitive programming. Each problem is a standalone `main.cpp` that reads from **stdin** and writes to **stdout**, checked locally against the sample cases pasted from the problem page. There is no application to build — every problem is independent.

The toolchain deliberately mirrors Codeforces: **GNU C++23, `-O2`**. "Compiles and matches samples locally" is meant to imply "compiles and matches samples on the judge too."

## Commands

```bash
# Scaffold a new problem folder from template/main.cpp
./scripts/new.sh <id> <title...>          # e.g. ./scripts/new.sh 1742C deletion-of-repeating
make new ID=1742C T=deletion-of-repeating # Makefile equivalent

# Compile + check a solution against ALL samples in its tests/ folder
./scripts/test.sh <id-or-slug-or-path>    # e.g. ./scripts/test.sh 4A  (id prefix, slug, or path all resolve)
make test P=4A-watermelon

# Compile + run reading input from the keyboard (manual edge-case probing; Ctrl+D ends input)
make run P=4A-watermelon
```

There is no "run a single test" — `test.sh` always runs every `tests/*.in` for the problem and diffs each against its `*.out` (trailing whitespace and the final newline are ignored). To isolate one case, temporarily keep only that `N.in`/`N.out` pair, or use `make run` and type the input.

`test.sh` compiles with `g++ -std=gnu++23 -O2 -Wall -Wextra -DLOCAL`. There is no lint/format step wired up.

## Per-problem structure

```
problems/<id>-<slug>/
  main.cpp            # the solution (scaffolded from template/main.cpp)
  tests/1.in 1.out    # sample case 1 — paste input/output from the problem page
  tests/2.in 2.out    # additional samples...
```

`new.sh` creates the folder with `main.cpp` and one **empty** `tests/1.in`/`1.out` pair. Samples must be filled in before `test.sh` has anything to check. When scaffolding a problem for the user, populate the real sample cases (via `printf` redirection into the `.in`/`.out` files) as a follow-up step — an empty tests folder makes `test.sh` a no-op.

## The template (`template/main.cpp`)

Every solution starts from this file, so understand its scaffolding before editing:

- **`#include <bits/stdc++.h>` + `using namespace std;`** — GCC-only catch-all include; valid because the target is Codeforces/GCC.
- **Aliases/macros:** `ll`/`ull`/`pii`/`pll`, `all(x)`, `rall(x)`, `sz(x)` (casts `.size()` to `int` to dodge unsigned-comparison bugs), `rep(i,a,b)`.
- **`dbg(...)` macro:** prints to **stderr**, and is active **only under `-DLOCAL`** (which `test.sh` sets) — it compiles to nothing on the judge, so `dbg(...)` calls are safe to leave in submitted code. Sample checking compares **stdout only**, so stderr debug output never affects test results.
- **`solve()` + multi-test loop in `main()`:** the `cin >> t;` line is commented out by default. Uncomment it for the common Div.2/Div.3 "t test cases" format; leave commented for single-case problems.

## Judge-correctness gotchas (these cause wrong verdicts, not compile errors)

- **Output strings must match exactly** — capitalization, punctuation, and trailing characters. (A real example from this repo: `469A` expects `I become the guy.` *with* the period.) When a locally-authored sample disagrees with the judge, trust the judge and fix the sample.
- **`"\n"` over `endl`** — `endl` flushes every call and can turn a correct solution into a TLE on large output. Prefer `"\n"`.
- **Read the constraints to pick complexity before coding.** The `~10^8 ops/sec` budget means `O(n^2)` is fine up to `n≈5000` but TLEs at `n≥10^5`. Several problems here (e.g. `4C` with `n≤10^5`) require an O(n log n)/O(n) approach, not a naive scan.
- **Overflow:** use `ll` when a sum/product can exceed ~2·10^9.

## Learning context — read before scaffolding or reviewing

This is a mentored practice repo, and the interaction pattern matters as much as the code:

- **`PROGRESS.md`** — the living progress tracker: what's solved, subject-by-subject status, the solved log, current focus, and next-up candidates. **Consult it at the start of a session to see where the user is and pick the next problem; update it whenever a problem is scaffolded (mark in-progress) or accepted (move to the solved log + bump the subject status and snapshot).** This is the source of truth for "where are we"; keep it current.
- **`ROADMAP.md`** — the study plan: rating bands, topic order (implementation → math → greedy → two pointers → binary search → DP → graphs → …), the complexity budget, and a curated starter problem set. Use it (with `PROGRESS.md`) to pick the next problem at the right difficulty (target ~+100–200 above the user's current comfortable level).
- **`NOTES.md`** — a log of "the idea I missed" per problem where the editorial was opened. Patterns here reveal weak topics.
- **`CHEATSHEET.md`** — durable reference of reusable idioms/techniques with short proofs (e.g. ceiling division). Add an entry when the user learns a general technique worth re-reading; distinct from `NOTES.md` (per-problem misses).
- **Established workflow when helping:** scaffold the problem folder **and** fill in the real sample cases; **do not volunteer the solution approach** unless asked (the user solves independently); after the user reports "accepted," verify the solution by compiling and running it against extra hand-picked edge cases (not just the given samples) before reviewing. Reviews should be honest — a passing/AC solution can still be wrong on untested inputs (a `158A` submission here passed samples by coincidence while being logically incorrect).

## Housekeeping

`.gitignore` covers `a.out`, `*.out`, `*.o`, `sol`, `cf_run` — but **not** bare `main` binaries. `make run` compiles to `/tmp`, but ad-hoc `g++ -o main ...` invocations have left committed `main` executables in some problem folders (e.g. `339A`, `580A`). Don't add more; prefer `test.sh`/`make run` (which build to temp dirs), or name throwaway binaries something `.gitignore` already catches (e.g. `sol`).
