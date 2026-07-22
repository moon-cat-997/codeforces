# Progress Tracker

Living record of what's been solved, by subject, and what's next. **Consult this at the
start of a session to pick the next problem; update it whenever a problem is accepted or
scaffolded.** Companion to `ROADMAP.md` (the plan) and `NOTES.md` (missed-idea log).

_Last updated: 2026-07-22_

## Snapshot

- **Solved:** 23
- **Comfortable band:** 800–1000 (solid); 1100–1400 cleared (158B, 546B, 4B, 279B, 6C, 1133C, 489B, 600B, 1324D)
- **Current focus:** two pointers / sliding window (roadmap topic #4) — cementing by shape: max-window ✓ (279B), converging ✓ (6C), sort-then-window ✓ (1133C), two-sequence matching ✓ (489B), offline sorted queries ✓ (600B), counting pairs by sum threshold ✓ (1324D); now min-window (1354B → 701C)
- **In progress:** `1354B` Ternary String (1200, min-window — scaffolded, skipped for now; user jumped to Ladder A). Next ladder item: `1955D` Inaccurate Subsequence Search.
- **Queued:** two full ladders scaffolded with official samples — see "Scaffolded ladders" below. Order: finish 1354B → two-pointers ladder → binary-search ladder.
- **Open / not solved:** none

## Subject progress

Ordered by the `ROADMAP.md` topic sequence. "Reps" = problems solved touching that subject.

| # | Subject | Status | Reps |
|---|---------|--------|------|
| 1 | Implementation / simulation | strong | 71A, 231A, 158A, 282A, 427A |
| 2 | Math & number theory basics | good | 4A (parity), 50A (`n*m/2`), 263A (Manhattan dist), 1A (ceil div + `long long`) |
| 3 | Greedy | good | 158B (bucket-by-count), 546B (sort-then-sweep), 4B (feasibility + distribute-slack) |
| 4 | Two pointers / sliding window | good | 279B (variable-size sliding window — grow/shrink/record; canonical form is `for end / while shrink`), 6C (converging pointers from both ends — advance the side with the smaller accumulated total), 1133C (sort-then-window — largest window with bounded spread `a[r]-a[l] ≤ 5`), 489B (two sorted sequences, greedy matching — one pointer per array, advance the smaller side), 600B (offline sorted queries), 1324D (reduce two-array condition to one array via `c_i = a_i - b_i`, then count pairs with `c_i+c_j > 0`) |
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
| 2026-07-22 | 1324D Pair of Topics | 1400 | two pointers (counting pairs) | condition `a_i+a_j > b_i+b_j` is **per-topic** ⇒ sorting `a`/`b` separately breaks the pairing — reduce per-index to one array `c_i = a_i - b_i` *before* sorting, then count pairs with `c_i+c_j > 0` by converging from both ends: `>0` ⇒ `hi` pairs with all of `[lo,hi)`, bulk-count `hi-lo` and retire `hi`; `≤0` ⇒ `lo`'s best partner failed so retire `lo`. First AC used a single drifting pointer + two boundary-guard patches (correct, amortized O(n), but hard to prove by inspection); **rewritten from understanding into the canonical 8-line form, no guards** — see CHEATSHEET. Not greedy: no choice is made, the branch is a fact about the data ⇒ proof obligation is a partition check, not an exchange argument. `ans` must be `ll` (max ≈ 2·10¹⁰). Both versions stress-verified vs brute (3000 small + 200 medium) and at n=2·10⁵ (random, all-equal, alternating-extreme, sorted/reverse-sorted; 15–41ms) |
| 2026-07-18 | 600B Queries about less or equal | 1300 | two pointers (offline sorted queries) | answer per query = count of `a[i] ≤ v` = upper_bound index. Solved offline: sort a AND the queries, one monotone sweep (i never resets), map answers back to input order. Canonical online alternative: `upper_bound(all(a), v) - a.begin()` per query — same complexity, less machinery. Stress-verified vs upper_bound ref (negatives, dups, n=m=2·10⁵ in 0.09s) |
| 2026-07-17 | 489B BerSU Ball | 1200 | two pointers (two-sequence matching) | sort both arrays; greedy "match the smallest compatible pair" is optimal — skip a-side while `b[j]-a[i] > 1` (too small), pair when `|diff| ≤ 1`, else skip b[j]. Stress-verified vs exact bitmask matching (3000 tiny + 500 medium + edges: chains, all-dups, max-n) |
| 2026-07-14 | 1133C Balanced Team | 1200 | two pointers (sort + window) | sort skills, then slide a window keeping `a[r]-a[l] ≤ 5`; left pointer only ever advances (monotonic) → O(n) after the sort. Edge-verified beyond samples: spread=5 keeps / spread=6 drops, disjoint clusters, n=1 |
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
| 2 | ✅ 1133C Balanced Team | 1200 | pick a subset, bounded spread — solved 2026-07-14 |
| 3 | ✅ 489B BerSU Ball | 1200 | two sequences, matching — solved 2026-07-17 |
| 4 | ✅ 600B Queries about less or equal elements | 1300 | two sorted arrays — solved 2026-07-18 |
| 5 | ✅ 1324D Pair of Topics | 1400 | counting pairs — solved 2026-07-22 |
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
- **Classify the technique by its proof obligation, not its loop shape** (1324D): incremental + invariant + no-backtracking describes greedy, binary search, merge, *and* sliding window alike. The discriminator is whether a **genuine choice** exists — could you have decided differently and still gotten a valid answer? Yes ⇒ greedy, owe an exchange argument or stress test. No, the branch is a fact about the data ⇒ counting/invariant, owe a partition check. See CHEATSHEET "What greedy actually means".
- On a sorted array, ask **"which element can I *completely finish* right now?"** rather than "how do I scan?" — the extremes are never ambiguous (`hi` pairs with everything left, or `lo` pairs with nothing left), which is what turns a drifting pointer with boundary patches into a clean converging loop (1324D).
- A first AC is not the end of a problem: **re-deriving the clean form from understanding** (1324D, 14 lines + 2 guards → 8 lines + 0) is where the pattern actually gets learned.
