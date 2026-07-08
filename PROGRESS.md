# Progress Tracker

Living record of what's been solved, by subject, and what's next. **Consult this at the
start of a session to pick the next problem; update it whenever a problem is accepted or
scaffolded.** Companion to `ROADMAP.md` (the plan) and `NOTES.md` (missed-idea log).

_Last updated: 2026-07-05_

## Snapshot

- **Solved:** 17
- **Comfortable band:** 800–1000 (solid); 1100–1400 cleared (158B, 546B, 4B, 279B)
- **Current focus:** two pointers / sliding window (roadmap topic #4) — sliding window done; now converging-pointers
- **In progress:** `6C` Alice, Bob and Chocolate (1200, converging two pointers from both ends)
- **Open / not solved:** none

## Subject progress

Ordered by the `ROADMAP.md` topic sequence. "Reps" = problems solved touching that subject.

| # | Subject | Status | Reps |
|---|---------|--------|------|
| 1 | Implementation / simulation | strong | 71A, 231A, 158A, 282A, 427A |
| 2 | Math & number theory basics | good | 4A (parity), 50A (`n*m/2`), 263A (Manhattan dist), 1A (ceil div + `long long`) |
| 3 | Greedy | good | 158B (bucket-by-count), 546B (sort-then-sweep), 4B (feasibility + distribute-slack) |
| 4 | Two pointers / sliding window | started | 279B (variable-size sliding window — grow/shrink/record; canonical form is `for end / while shrink`) |
| 5 | Binary search (on the answer) | not started | — |
| 6 | Prefix sums / difference arrays | not started | — |
| 7 | Sorting + events | partial | 339A (sort) |
| 8 | Basic DP | not started | — |
| 9 | Graphs (BFS/DFS) | not started | — |
| 10 | Data structures (DSU, monotonic) | not started | — |

Cross-cutting tools already exercised: `sort`, `set`/`unordered_set` (469A), `map`/`unordered_map`
(4C), running-length scan (580A), running-balance counter (427A), string parsing (282A, 339A),
grid coordinates (263A).

## Solved log

Newest first. "Key idea" = the insight or tool the problem taught.

| Date | Problem | Rating | Subject | Key idea |
|------|---------|--------|---------|----------|
| 2026-07-06 | 279B Books | 1400 | two pointers / sliding window | max-length window with sum ≤ t; grow right, shrink left when over, record best; both pointers forward → O(n). Solved with extend-OR-shrink form + reset guard (correct); canonical `for end / while shrink` needs no guard. int safe only because a_i ≤ 1e4 |
| 2026-07-06 | 4B Before an Exam | 1400 | greedy / constructive | achievable totals form interval `[Σmin, Σmax]` → one check for feasibility; construct by starting at min and pouring slack front-to-back (`add = min(cap, rest)`). First special-judge problem — validate output validity, not exact match |
| 2026-07-05 | 1A Theatre Square | 1000 | math | ceil per dimension `n/a + (n%a!=0)`, multiply; **`long long` mandatory** — 10⁹×10⁹ = 10¹⁸ overflows `int` |
| 2026-07-05 | 546B Soldier and Badges | 1200 | greedy | bucket by value (`1≤a_i≤n` bounds it): split into missing slots vs excess duplicates, greedily match smallest excess to smallest reachable slot, overflow past `n` for the rest — cost-equivalent to sort-then-sweep, stress-verified vs. reference up to n=3000 |
| 2026-07-02 | 158B Taxi | 1100 | greedy | sort → order irrelevant → **only counts matter**; c1..c4 arithmetic. Solved correctly via 2-pointer+`used[]` (79 lines, stress-verified) but counting is ~10 lines |
| 2026-07-02 | 427A Police Recruits | 1000 | running balance | unify "recruit" and "spend on crime" into one `sum += x`; count only when `sum<=0` |
| 2026-07-02 | 580A Kefa and First Steps | 1000 | running-length scan | longest non-decreasing run in one O(n) pass; `<=` treats equals as non-decreasing |
| 2026-06-30 | 4C Registration System | 1000 | map / hashing | `map<name,count>`; `[]` post-increment prints suffix then bumps; O(n log n) needed (n≤1e5) |
| 2026-06-30 | 469A I Wanna Be the Guy | 800 | sets | union both friends' levels into one set, scan 1..n for coverage; exact output strings |
| 2026-06-30 | 339A Helpful Maths | 800 | sorting/strings | single-digit summands → sort the chars; read constraints to size the machinery |
| 2026-06-30 | 50A Domino Piling | 800 | math | answer is `n*m/2` |
| 2026-06-30 | 263A Beautiful Matrix | 800 | math observation | moves reduce to Manhattan distance to center; 1-indexed loops keep center clean at (3,3) |
| 2026-06-28 | 282A Bit++ | 800 | strings | ignore `X`/position; key only on presence of `+` (`find`/`npos` or `s[1]`) |
| 2026-06-28 | 158A Next Round | 800 | implementation | count `score >= cutoff && score > 0`; simple beats clever (first attempt was clever+wrong) |
| 2026-06-28 | 231A Team | 800 | implementation | count rows with `a+b+c >= 2` |
| 2026-06-28 | 71A Way Too Long Words | 800 | strings | abbreviate if `len>10`: first + (len-2) + last |
| (pre-session) | 4A Watermelon | 800 | math/parity | even `w` and `w>2` |

## Next-up candidates

Pick per `ROADMAP.md` (target ~+100–200 over comfort). Greedy now has 3 shapes (158B/546B/4B) — solid.

- **Two pointers / sliding window (topic #4, ~1100–1300):** the natural next new technique. ← recommended next.
- **More greedy (~1300–1500) if desired:** 1157C, 1006B.

## Habits being reinforced (from reviews)

- Simple beats clever when it's fast enough (158A, 4C).
- Minimize carried state: when order doesn't matter, reach for **counts, not pointers/positions** (158B — solved in 79 lines what counting does in 10).
- Read constraints → derive complexity budget before coding (learned via 4C's n≤1e5).
- Special-judge / "output any valid answer" problems (4B): local exact-diff can false-fail on YES cases — validate output *validity* (constraints + sum), trust CF's checker.
- `"\n"` not `endl`; exact output strings; test self-made edge cases beyond the given samples.
