# Codeforces Roadmap

A concrete path from "I can code" to solving genuinely hard algorithmic problems.
The goal is steady rating growth, not heroics. **2–3 problems a day beats a
weekend marathon every month.**

## How rating works

Every CF problem has a difficulty rating (800 → 3500). Target problems **+100 to
+200 above the level you currently solve ~70% of unaided**. Growth happens at the
edge of discomfort, not above it and not below it.

| Rating | Level |
|--------|-------|
| 800–1000 | implementation, no real algorithm |
| 1100–1300 | first real techniques (greedy, two pointers) |
| 1400–1600 | solid middle — sorting + math + observation |
| 1700–1900 | needs data structures, careful DP |
| 2000–2200 | advanced |
| 2300+ | hard |

Filter the problemset by rating, not by "most solved":
<https://codeforces.com/problemset?order=BY_RATING_ASC>

## The loop (per problem)

1. Read carefully. Note constraints — they leak the intended complexity.
   `n ≤ 20` → exponential; `n ≤ 5000` → O(n²); `n ≤ 2·10⁵` → O(n log n); `n ≤ 10⁶` → O(n).
2. Think for **up to 30 min**. Try small cases by hand.
3. Code it, check against samples: `./scripts/test.sh <slug>`.
4. Submit on CF. WA/TLE → debug your own logic first.
5. **Stuck > 30–45 min total? Read the editorial.** Then *close it and re-solve
   from scratch*. Understanding ≠ ability.
6. In `NOTES.md`, log the one idea you missed. Patterns in your misses = your
   weak spots.

## Complexity budget

CF allows ~10⁸ simple operations/sec. With a 1–2s limit, aim for ≤ ~10⁸ ops.
This is *the* tool for guessing the intended algorithm before you have it.

## Topic order (don't mix — drill 10–15 problems per topic)

1. **Implementation / simulation** — translate statements to code cleanly
2. **Math & number theory basics** — gcd, primes, modular arithmetic, parity
3. **Greedy** — exchange argument, sort-then-decide
4. **Two pointers & sliding window**
5. **Binary search** — on the answer, not just on arrays
6. **Prefix sums & difference arrays**
7. **Sorting + events**
8. **Basic DP** — 1D, knapsack, LIS, grid paths
9. **Graphs** — BFS/DFS, connected components, shortest paths
10. **Data structures** — DSU (union-find), stack/monotonic, sparse table
11. **Advanced DP** — bitmask, on trees, digit DP
12. **Trees** — LCA, Euler tour; **segment trees / Fenwick**
13. **Advanced math** — combinatorics, sieve, modular inverse

Reference for every algorithm with code: <https://cp-algorithms.com/>

## 6-week starter schedule (adjust to your pace)

**Weeks 1–2 — get fluent (rating 800–1000).** One Div.3/Div.4 set worth of pure
reps. Speed and correctness on easy problems first.

Starter set (all ~800, classic, well-known editorials):
`4A` ✓done · `1A` (scaffolded) · `71A` · `231A` · `158A` · `282A` · `50A` ·
`116A` · `339A` · `263A` · `977A` · `469A`

**Weeks 3–4 — first techniques (1000–1300).** Pick greedy + two-pointers +
prefix-sum tags; 10 problems each. Do **virtual** Div.3 rounds (Gym → pick a past
Div.3, "Virtual participation") to practice under time pressure.

**Weeks 5–6 — binary search + basic DP (1300–1500).** "Binary search on the
answer" is the single highest-leverage idea at this level. Then 1D DP and
knapsack. Start joining **live** Div.3 / Div.2 rounds; rating is noisy, ignore
single-contest swings.

## Tools

- **Ladders** — sorted problem lists by rating for your level:
  A2OJ ladders, or <https://c0r3.github.io/CF-Ladders/>
- **CP-Algorithms** — the algorithm encyclopedia with copy-pasteable code.
- **USACO Guide** (<https://usaco.guide/>) — structured theory + problems, free.
- **CF problemset tag + rating filter** — your daily driver.

## Habits that actually move rating

- **Re-solve from scratch** after reading any editorial.
- **Upsolve** after every contest: solve the 1–2 problems just past where you
  stopped. That gap is exactly your next rating band.
- **Time-box.** 30 min thinking, then editorial — chronic over-grinding wastes reps.
- **One language, deeply.** You picked C++; learn its STL cold
  (`sort`, `lower_bound`, `set`/`map`, `priority_queue`, `__gcd`).
