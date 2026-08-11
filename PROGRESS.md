# Progress Tracker

Living record of what's been solved, by subject, and what's next. **Consult this at the
start of a session to pick the next problem; update it whenever a problem is accepted or
scaffolded.** Companion to `ROADMAP.md` (the plan) and `NOTES.md` (missed-idea log).

_Last updated: 2026-08-10_

## Snapshot

- **Solved:** 29
- **Comfortable band:** 800–1000 (solid); 1100–1500 cleared (158B, 546B, 4B, 279B, 6C, 1133C, 489B, 600B, 1324D, 580B, 676C, 1955D, 701C); **1600 cleared** (616D)
- **Current focus:** binary search (roadmap topic #5) — **Ladder B started 2026-08-09**, 1/10 done (706B ✓ 2026-08-10); next problem `1873E` Building an Aquarium (1100), the first true *search-on-the-answer* rep. Previous topic, two pointers / sliding window (#4), is complete: max-window ✓ (279B), converging ✓ (6C), sort-then-window ✓ (1133C, 580B), two-sequence matching ✓ (489B), offline sorted queries ✓ (600B), counting pairs by sum threshold ✓ (1324D), min-window ✓ (701C), distinct-count cap ✓ (616D)
- **In progress:** `1354B` Ternary String (1200, min-window — scaffolded, deferred; two-pointer topic already closed by Ladder A). **Ladder A is complete** (10/10, capstone 616D done 2026-08-02).
- **Queued:** Ladder B (binary search) is scaffolded with official samples — see below.
- **Open / not solved:** none

## Subject progress

Ordered by the `ROADMAP.md` topic sequence. "Reps" = problems solved touching that subject.

| # | Subject | Status | Reps |
|---|---------|--------|------|
| 1 | Implementation / simulation | strong | 71A, 231A, 158A, 282A, 427A |
| 2 | Math & number theory basics | good | 4A (parity), 50A (`n*m/2`), 263A (Manhattan dist), 1A (ceil div + `long long`) |
| 3 | Greedy | good | 158B (bucket-by-count), 546B (sort-then-sweep), 4B (feasibility + distribute-slack) |
| 4 | Two pointers / sliding window | good | 279B (variable-size sliding window — grow/shrink/record; canonical form is `for end / while shrink`), 6C (converging pointers from both ends — advance the side with the smaller accumulated total), 1133C (sort-then-window — largest window with bounded spread `a[r]-a[l] ≤ 5`), 489B (two sorted sequences, greedy matching — one pointer per array, advance the smaller side), 600B (offline sorted queries), 1324D (reduce two-array condition to one array via `c_i = a_i - b_i`, then count pairs with `c_i+c_j > 0`), 580B (**left-anchored** window — the canonical form mirrored: iterate the left edge in the `for`, grow the right in the `while`), 676C (longest window with ≤ k of a chosen letter, maximized over both letters — `start`-driven variant needed an explicit `end = max(end, start)` guard the canonical `end`-driven form makes structurally impossible), 1955D (fixed-size window over a frequency map — maintain the aggregate `matched = Σ min(cnt[v], b[v])` **incrementally** on enter/leave, never recompute per window; add uses strict `<`, remove uses `<=`), 701C (**minimum**-length window covering all distinct chars — the min-window shape: shrink is not "restore validity" but "tighten while still valid", so the shrink test is `cnt[s[lo]] > 1` and `best` is recorded *after* shrinking), 616D (window with a **distinct-count cap** — the canonical max-window over a frequency table; the whole problem is "which container holds the counts", and `0 ≤ a_i ≤ 10⁶` means a flat counting array beats `map` ~11×) |
| 5 | Binary search (on the answer) | started | 706B (STL boundary search: count of `≤ m` on a sorted array is `upper_bound(all(x), m) - x.begin()`; the array's sortedness *is* the monotone predicate `p(i) = x[i] > m`, so the STL call is the `while (lo < hi)` template with the loop already written) |
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
| 2026-08-10 | 706B Interesting drink | 1100 | binary search (sorted-array boundary) | **Ladder B #1, first rep of topic #5.** Answer per query = count of prices `≤ m` = `upper_bound(all(x), m) - x.begin()` after one sort ⇒ O((n+q) log n), sort dominant. The whole problem is `upper_bound` vs `lower_bound`: `upper_bound` finds the first element **>** `m` so its index counts `≤ m`; `lower_bound` counts `< m` and is a WA on *every* query that exactly equals a price (sample query `10` → 3 instead of 4). Worth naming what the STL call is: the boundary of the monotone predicate `p(i) = (x[i] > m)`, i.e. the `while (lo < hi)` first-true template with the loop pre-written — sortedness is what supplies the monotonicity. `int` safe throughout (n, q ≤ 10⁵; x_i, m ≤ 10⁹; answer ≤ n; nothing accumulates or multiplies). One fault: `while (cin >> m)` read to **EOF instead of exactly `q` queries** — correct here only because the queries are the last block in the file; with anything following (a `t` loop, another array) it answers phantom queries or eats the next block. `-Wunused-variable` can't catch it because `q` *is* assigned. Stress-verified vs brute (2000 cases across value ranges 3/10/1000/10⁹) + edges (n=1, all-duplicates, query == price, m below/above all, values at 10⁹); n=q=10⁵ in 0.02–0.03s |
| 2026-08-02 | 616D Longest k-Good Segment | 1600 | two pointers (distinct-count cap) | **Ladder A capstone, first 1600.** The window logic is the canonical max-window with no twist — grow `hi`, `while (distinct > k)` shrink `lo`, record after — so the whole problem is *which container holds the frequencies*. Solved with `map<int,int>`: correct, 0.29s / 24MB against a 2s / 256MB limit. But `0 ≤ a_i ≤ 10⁶` means the values are **bounded and small enough to index by**, so `vector<int> cnt(10⁶+1)` is a direct-address table — O(1) instead of O(log n), 4MB contiguous instead of ~24MB of scattered red-black nodes (each ~40 bytes of pointers/colour for 8 bytes of payload, one cache miss per access). Measured **0.29s → 0.025s, ~11×**. Same reflex as 546B. Two style faults: `best = mp(hi, lo)` stores the range **backwards** (`.first` = right edge), forcing `best.first - best.second` for the length and a reversed print — correct but a WA trap; two named ints (`bestL`, `bestLen`) remove it. And the `lo < hi` half of the shrink test is **dead for the second time running** (cf. 701C): adding one element raises `distinct` by ≤1, and a one-element window has `distinct == 1 ≤ k` since `k ≥ 1`, so the loop always exits on the constraint, never on the guard — and it isn't a safety net, it's a *silent wrong answer* mechanism if `k` were ever 0. Stress-verified vs brute (3000 cases, validity **and** optimal length — special judge) + edges (n=1, a_i=0, a_i=10⁶, all-same, all-distinct k=1, k≥n) |
| 2026-08-02 | 701C They Are Everywhere | 1500 | two pointers (**minimum** window) | first min-window rep, and the shape inverts the max-window reflex. In a max-window the `while` **restores validity** (shrink only while the constraint is violated) and you record `best` after it; here every window that contains all `k` distinct chars is already valid, so the `while` instead **tightens a valid window** — advance `lo` while `cnt[s[lo]] > 1` (that char is duplicated inside, so dropping it can't lose coverage) — and `best` is recorded after tightening, guarded by `curUnique == uniqueCnt`. Both pointers still forward-only ⇒ O(n) with an O(log Σ) `map`. Two harmless bits: the `lo < hi` half of the shrink test is **dead** (a one-element window can't have `cnt > 1`), and `bestLen = 100000` is a magic sentinel that only works because it equals max `n` and the full string always covers everything — `n` would say so directly. Stress-verified vs brute (5500 cases: 2-, 5-, and 52-letter alphabets) + edges (n=1, all-same, alternating, all-distinct, coverage at the far end); n=10⁵ in 2–8ms |
| 2026-07-30 | 1955D Inaccurate Subsequence Search | 1400 | two pointers (fixed window + freq map) | count length-`m` windows of `a` whose multiset-overlap with `b` is `≥ k`, where overlap `= Σ_v min(cnt_window[v], cnt_b[v])`. First version was **correct but TLE** — `match(b, c, k)` took both maps **by value** (deep-copying two hash maps *per window*) and **recomputed the overlap from scratch** each window (`O(distinct)` per step) ⇒ ~`O(n·m)` ≈ 10¹⁰. Fix: keep a running `matchedCnt` updated **incrementally** as the window slides — on enter, `if (c[x]++ < b[x]) matchedCnt++` (strict `<`: a copy helps only while below b's count); on leave, `if (t <= b[x]) matchedCnt--` where `t` is the pre-decrement count (`<=`: the copy at exactly `b[x]` was still a counted match). `c` tracks only values present in `b`. Turns per-step work into `O(1)` ⇒ `O(n)` total. Dead `match()` removed. Stress-verified vs brute (43k small/medium, value ranges 1–1000 + edges); n=2·10⁵ in 12–79ms (all-equal / 10⁶-wide-random) |
| 2026-07-25 | 676C Vasya and String | 1500 | two pointers (window) | `run(s,k,letter)` = longest window holding ≤ k of `letter` (flip those k), answer = max over both letters. Two bugs cost 6 attempts, both inattention not concept: (1) misread the statement — *any* single-char substring qualifies, so both letters must be tried; (2) the `start`-driven window (outer `for` advances left edge, inner `while` catches the right up) let `end` fall **behind** `start` when the left edge was a blocked `letter` with no swaps left — every later window scored `end - start < 0`, hidden by `max(0, …)`, silently dropping valid runs (`baa`, k=0 → printed 1, correct 2). Fix: one-line `if (start > end) end = start;`. Lesson logged: the canonical **`end`-driven** form (outer grows `end`, inner shrinks `start` only while constraint violated) makes `end ≥ start` impossible to violate by construction — same O(n). Stress-verified vs brute (5000 small + adversarial: single char, all-same, isolated-letter, k=0, k=n); n=10⁵ in ~2ms |
| 2026-07-22 | 580B Kefa and Company | 1500 | two pointers (sort + window) | sort by money, take a contiguous run with spread `< d`, maximize summed friendship. Solved in the **mirrored orientation**: `for` iterates the *left* edge and the `while` grows the *right* (canonical does the opposite) — same window, same O(n), both pointers still forward-only, and no shrink-*loop* is needed because the left edge advances exactly once per outer step (`curSum -= a[i].second`). Records `best` *inside* the growth loop, which is safe here only because values are non-negative ⇒ validity is prefix-closed (cf. 1692E where check-before-shrink was the trap). Carried a dead `if (j < i) j = i;` guard — `d ≥ 1` means the window always holds element `i`, so `j` can never fall behind. `ll` sums mandatory (max 10¹⁴). Stress-verified vs brute (3000 small + 300 medium) and vs the canonical orientation at n=10⁵ (11–17ms), incl. the `diff == d` exclusion boundary |
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
| 6 | ✅ 1955D Inaccurate Subsequence Search | 1400 | window + multiset of values — solved 2026-07-30 |
| 7 | ✅ 580B Kefa and Company | 1500 | window under a spread constraint — solved 2026-07-22 |
| 8 | ✅ 676C Vasya and String | 1500 | window with a change budget — solved 2026-07-25 |
| 9 | ✅ 701C They Are Everywhere | 1500 | smallest window covering requirements — solved 2026-08-02 |
| 10 | ✅ 616D Longest k-Good Segment | 1600 | window with a distinct-count cap (capstone) — solved 2026-08-02 |

**Ladder A complete (10/10).**

### Ladder B — binary search (topic #5)

| # | Problem | Rating | Flavor |
|---|---------|--------|--------|
| 1 | ✅ 706B Interesting drink | 1100 | queries on a sorted array — solved 2026-08-10 |
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
- **Read the *value* bound, not just `n`** (616D, 546B): when `a_i` is capped by something small, index an array **by the value** instead of reaching for `map`/`unordered_map`. O(1) and cache-friendly vs O(log n) and pointer-chasing — measured 11× on 616D.
- **A guard you can't prove is needed is a bug in waiting** (701C, then 616D — same dead `lo < hi` twice). In the canonical `end`-driven window the shrink condition is *sufficient* on its own. If the urge to add a bounds guard shows up, that's the signal to prove the invariant, not to patch it — the guard doesn't protect you, it converts a loud hang into a silent wrong answer.
- **When the statement gives you a count, consume exactly that many items** (706B: `while (cin >> m)` instead of `rep(i,0,q)`). Reading to EOF is a *different input format* — reserve it for problems that say "read until end of input". Otherwise the loop silently answers phantom queries or swallows the next block, and no compiler warning fires (the count variable *is* assigned, so `-Wunused-variable` stays quiet). Same species as the dead-guard smell: code that happens to be right on this input shape rather than right by construction.
- **Store a range as `(l, r)`, or as two named variables — never reversed** (616D stored `(hi, lo)`). Consistent-but-backwards code is correct today and a WA on a tired evening.
