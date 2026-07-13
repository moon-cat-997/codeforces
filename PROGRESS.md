# Progress Tracker

Living record of what's been solved, by subject, and what's next. **Consult this at the
start of a session to pick the next problem; update it whenever a problem is accepted or
scaffolded.** Companion to `ROADMAP.md` (the plan) and `NOTES.md` (missed-idea log).

_Last updated: 2026-07-11_

## Snapshot

- **Solved:** 19
- **Comfortable band:** 800–1000 (solid); 1100–1400 cleared (158B, 546B, 4B, 279B, 6C)
- **Current focus:** two pointers / sliding window (roadmap topic #4) — cementing by shape: max-window ✓ (279B), converging ✓ (6C); now min-window (1354B → 701C), optionally sort-then-window (580B)
- **In progress:** `1354B` Ternary String (1200, min-window — scaffolded, skipped for now; user jumped to Ladder A). Next ladder item: `1133C` Balanced Team.
- **Queued:** two full ladders scaffolded with official samples — see "Scaffolded ladders" below. Order: finish 1354B → two-pointers ladder → binary-search ladder.
- **Open / not solved:** none

## Subject progress

Ordered by the `ROADMAP.md` topic sequence. "Reps" = problems solved touching that subject.

| # | Subject | Status | Reps |
|---|---------|--------|------|
| 1 | Implementation / simulation | strong | 71A, 231A, 158A, 282A, 427A |
| 2 | Math & number theory basics | good | 4A (parity), 50A (`n*m/2`), 263A (Manhattan dist), 1A (ceil div + `long long`) |
| 3 | Greedy | good | 158B (bucket-by-count), 546B (sort-then-sweep), 4B (feasibility + distribute-slack) |
| 4 | Two pointers / sliding window | good | 279B (variable-size sliding window — grow/shrink/record; canonical form is `for end / while shrink`), 6C (converging pointers from both ends — advance the side with the smaller accumulated total) |
| 5 | Binary search (on the answer) | not started | — |
| 6 | Prefix sums / difference arrays | not started | — |
| 7 | Sorting + events | partial | 339A (sort) |
| 8 | Basic DP | not started | — |
| 9 | Graphs (BFS/DFS) | not started | — |
| 10 | Data structures (DSU, monotonic) | not started | — |

Cross-cutting tools already exercised: `sort`, `set`/`unordered_set` (469A), `map`/`unordered_map`
(4C), running-length scan (580A), running-balance counter (427A), string parsing (282A, 339A),
grid coordinates (263A).4 / 1 1 1 100

## Solved log

Newest first. "Key idea" = the insight or tool the problem taught.

| Date | Problem | Rating | Subject | Key idea |
|------|---------|--------|---------|----------|
| 2026-07-12 | 1692E Binary Deque | 1200 | two pointers (window) | removing from both ends ⇔ keeping a contiguous window → minimize `l + (n-1-r)` over windows with sum == s. Solved with check-BEFORE-shrink order — correct here only because 0/1 elements make every missed window dominated by an equal-length earlier one; on general values that order breaks (`[2,3], s=3` → sentinel `1000000` printed). Canonical: extend → shrink → check (see CHEATSHEET). Stress-verified vs brute + independent binary-search ref |
| 2026-07-11 | 6C Alice, Bob and Chocolate | 1200 | two pointers (converging) | bar `m` goes to whoever *reaches* it first: Alice iff `prefixSum(m) <= suffixSum(m+1)` (tie → Alice). Loop exits two ways: pointers cross (no leftover) or `i==j` (one contested middle bar). AC on 3rd try — the `i==j` branch was guessed, not derived; `n&1` (try 2) fails both directions: `[5,1,1]` odd-n-no-leftover, `[1,1,1,100]` even-n-with-leftover. Stress-verified vs. time-simulation reference (3000 small + 200 large + edges) |
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

## Scaffolded ladders (solve in order)

All folders exist under `problems/` with the official CF samples already filled in
(scraped from the problem pages 2026-07-11). Check each statement for the
multi-test `t` line before coding.

### Ladder A — two pointers (cement topic #4)

| # | Problem | Rating | Flavor |
|---|---------|--------|--------|
| 1 | ✅ 1692E Binary Deque | 1200 | array + target sum — solved 2026-07-12 |
| 2 | 1133C Balanced Team | 1200 | pick a subset, bounded spread |
| 3 | 489B BerSU Ball | 1200 | two sequences, matching |
| 4 | 600B Queries about less or equal elements | 1300 | two sorted arrays |
| 5 | 1324D Pair of Topics | 1400 | counting pairs |
| 6 | 1955D Inaccurate Subsequence Search | 1400 | window + multiset of values |
| 7 | 580B Kefa and Company | 1500 | window under a spread constraint |
| 8 | 676C Vasya and String | 1500 | window with a change budget |
| 9 | 701C They Are Everywhere | 1500 | smallest window covering requirements |
| 10 | 616D Longest k-Good Segment | 1600 | window with a distinct-count cap (capstone) |

### Ladder B — binary search (topic #5)

| # | Problem | Rating | Flavor |
|---|---------|--------|--------|
| 1 | 706B Interesting drink | 1100 | queries on a sorted array |
| 2 | 1873E Building an Aquarium | 1100 | first "search on the answer" |
| 3 | 474B Worms | 1200 | locate by cumulative position |
| 4 | 1613C Poisoned Dagger | 1200 | pure search-on-answer drill (only tag: binary search) |
| 5 | 1538C Number of Pairs | 1300 | counting pairs in a range |
| 6 | 670D1 Magic Powder - 1 | 1400 | feasibility check |
| 7 | 1201C Maximum Median | 1400 | answer + cost check |
| 8 | 1701C Schedule Management | 1400 | answer + greedy check |
| 9 | 812C Sagheer and Nubian Market | 1500 | answer-dependent costs |
| 10 | 1843E Tracking Segments | 1600 | search over time (capstone) |

Stretch pool after both ladders (not scaffolded): 460C Present (1700), 448D
Multiplication Table (1800).

## Habits being reinforced (from reviews)

- Simple beats clever when it's fast enough (158A, 4C).
- Minimize carried state: when order doesn't matter, reach for **counts, not pointers/positions** (158B — solved in 79 lines what counting does in 10).
- Read constraints → derive complexity budget before coding (learned via 4C's n≤1e5).
- Special-judge / "output any valid answer" problems (4B): local exact-diff can false-fail on YES cases — validate output *validity* (constraints + sum), trust CF's checker.
- `"\n"` not `endl`; exact output strings; test self-made edge cases beyond the given samples.
- When a condition is a *guess* (6C's `i==j` vs `n&1`), construct a test that distinguishes the candidates before submitting — for 6C a 3-element hand trace (`[5,1,1]`) was enough to kill `n&1`.
