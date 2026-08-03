# Cheatsheet — reusable idioms & why they work

Techniques and one-liners that recur across problems, each with enough of a *proof*
to trust it (and re-derive it later). Different from `NOTES.md` (per-problem missed
ideas) — this is the durable toolbox.

---

## Ceiling division of positive integers

**Goal:** compute `ceil(n / a)` — the smallest integer `≥ n/a` — using only integer
arithmetic (C++ `/` **floors** for positives: `7 / 3 == 2`, not `2.33`).

### Two equivalent formulas

```cpp
n / a + (n % a != 0)     // "floor, then +1 if there's a remainder"  (explicit)
(n + a - 1) / a          // "nudge up by a-1, then floor"            (compact)
```

Both assume `n >= 0` and `a > 0`. They always produce the **same** result.

### Why `(n + a - 1) / a` works

Integer division floors, so to get a *ceiling* we push the numerator up by just
enough that the floor lands on the rounded-up value. That "just enough" is `a - 1`.

Write `n = q·a + r` with `q = n / a` (the floor) and `r = n % a`, so `0 ≤ r < a`.

**Case 1 — `a` divides `n` exactly (`r = 0`).** True ceiling is `q`.
```
n + a - 1 = q·a + a - 1 = (q+1)·a - 1
```
That numerator is one *less* than `(q+1)·a`, so floor-dividing by `a` gives `q`.
The nudge wasn't enough to reach the next multiple — correct, nothing to round up. ✅

**Case 2 — there's a remainder (`1 ≤ r < a`).** True ceiling is `q + 1`.
```
n + a - 1 = q·a + r + a - 1 = (q+1)·a + (r - 1),   and  0 ≤ r-1 < a
```
The `(q+1)·a` part floor-divides to `q+1`; the leftover `r-1 < a` floors away. ✅

**One-sentence intuition:** adding `a - 1` is "add almost a full block." Almost-a-block
can't carry an exact multiple over to the next multiple (Case 1), but it *does* carry
you over the moment there's any remainder at all (Case 2) — which is exactly the
definition of rounding up.

### Sanity check (`a = 3`)

| n | ceil(n/3) | (n+2)/3 |
|---|-----------|---------|
| 6 | 2 | 8/3 = 2 |
| 7 | 3 | 9/3 = 3 |
| 8 | 3 | 10/3 = 3 |
| 9 | 3 | 11/3 = 3 |
| 10| 4 | 12/3 = 4 |

`7, 8, 9` all round to `3`; it only ticks to `4` at the next exact multiple.

### Why the explicit form is the same

`n / a + (n % a != 0)`: `n / a` is the floor `q`; `(n % a != 0)` is a `bool` that is
`1` exactly when `r ≠ 0` (Case 2) and `0` when `r = 0` (Case 1). So it's literally
"floor, plus one iff there's a remainder" — the two cases above, spelled out.

### ⚠️ Caveats

- **Overflow:** `(n + a - 1) / a` adds to the numerator first, so if `n` is near the
  type's max, `n + a - 1` wraps to garbage. The explicit form `n/a + (n%a != 0)` never
  adds to `n`, so it can't overflow that way — prefer it when `n` can be huge.
- **Positives only.** With negatives, `/` truncates toward zero and both formulas
  break. CP ceiling problems are almost always on positives.
- Seen in: **1A Theatre Square** — `ceil(n/a) * ceil(m/a)`, with `long long` mandatory
  (10⁹ × 10⁹ = 10¹⁸ overflows `int`).

---

## Sliding window (two pointers) — longest/shortest valid contiguous range

**Use when:** you need the longest (or shortest) *contiguous* subarray whose running
aggregate (sum, count, distinct-count, …) stays within some limit — and the aggregate
is **monotonic** as the window grows/shrinks (adding an element can't make it "more
valid," removing can't make it "less valid"). Turns an O(n²) all-subarrays scan into O(n).

### The canonical form (memorize this skeleton)

```cpp
int left = 0, best = 0;
long long sum = 0;                     // the window aggregate
for (int right = 0; right < n; right++) {
    sum += a[right];                   // 1. always extend to include a[right]
    while (sum > t) {                  // 2. shrink from the left until valid again
        sum -= a[left];
        left++;
    }
    best = max(best, right - left + 1); // 3. window [left, right] is now valid; record
}
cout << best << "\n";
```

Read it as three beats: **extend → shrink-while-invalid → record.**

### Why it's O(n)

`right` advances exactly `n` times. `left` only ever moves forward and never passes
`right`, so across the whole run it advances at most `n` times total. Each element is
added once and removed at most once → `2n` pointer moves → O(n), even though the
`while` *looks* like a nested loop.

### Why no empty-window special case is needed

If a single `a[right] > t`, then after `sum += a[right]` the `while` shrinks until
`left = right + 1`. Then `right - left + 1 = 0`, so `best` simply isn't updated — the
empty window handles itself. (Ad-hoc "extend OR shrink in one branch" variants instead
need a `max(0, …)` on the sum and a `if (left > right) right = left;` guard — correct,
but more surface area. Prefer the canonical form that needs neither.)

### ⚠️ Caveats

- **Overflow:** the window sum can reach up to `t + max(a[i])` mid-comparison. Size the
  accumulator to the *max it can reach*, not to `t`. Use `long long` unless you've proven
  `int` is safe. (279B was safe with `int` only because `a[i] ≤ 10⁴`, so
  `sum + a[right] ≤ 10⁹ + 10⁴ < INT_MAX` — not because the pattern is inherently safe.)
- **Monotonicity is required.** If a value can be negative (adding an element can
  *decrease* the sum), the "shrink until valid" logic breaks — that's a prefix-sum +
  other-structure problem, not a sliding window.
- Seen in: **279B Books** — longest run of consecutive books with total time ≤ t.

### The mirrored orientation — anchor the LEFT edge instead

The canonical form iterates the **right** edge and shrinks the **left**. The mirror
image iterates the **left** edge and grows the **right** — same window, same O(n),
both pointers still forward-only:

```cpp
int j = 0;                                  // right edge, never resets
long long cur = 0, best = 0;
rep(i, 0, n) {                              // i = LEFT edge
    while (j < n && valid(i, j)) {          // grow right while the window stays legal
        cur += a[j].second;
        best = max(best, cur);
        j++;
    }
    cur -= a[i].second;                     // retire the left edge — exactly once
}
```

**Why no shrink-*loop* is needed:** the left edge advances exactly once per outer
iteration, so a single subtraction replaces the canonical `while`-shrink. That's what
makes this orientation read simpler on "for each left edge, how far right can I reach?"
problems.

**⚠️ The catch — recording inside the growth loop.** Updating `best` on every
extension (rather than once per outer step) is only safe when **validity is
prefix-closed**: every prefix of a valid window is itself valid, so you can never
record a state you haven't finished validating. Non-negative values give you this for
free (a longer window is never worse). If values can be negative, or the predicate
isn't prefix-closed, move the `best` update out of the `while` — this is the same trap
as 1692E's check-before-shrink, which survived on 0/1 data by coincidence and died on
`[2,3], s=3`.

**Pick the orientation by what the problem asks:** right-anchored (canonical) for a
single global best; left-anchored when you need a per-left-edge answer ("for each `i`,
the farthest valid `j`").

- Seen in: **580B Kefa and Company** — sort by money, maximize summed friendship over a
  run with money spread `< d`. Verified equivalent to the canonical orientation at
  n=10⁵.
- **Watch for dead guards.** 580B carried `if (j < i) j = i;` to stop `j` falling behind
  `i` — but `d ≥ 1` means the window always contains element `i`, so `j` always ends at
  `i+1` or beyond. Unreachable. A defensive line standing in for an unproven invariant
  is a smell (same species as 1324D's boundary patches): prove it and delete it, or
  discover the constraint that actually makes it live (here, `d = 0`).

### Exact-target windows (`sum == s`): record AFTER shrinking

When hunting windows with an *exact* aggregate (not `≤ t`), keep the same three
beats but put the equality check after the shrink:

```cpp
sum += a[right];                 // 1. extend
while (sum > s) { sum -= a[left]; left++; }  // 2. shrink while OVER the target
if (sum == s) record();          // 3. only now test for equality
```

Checking *before* the shrink misses every window that becomes `== s` mid-shrink.
On 0/1 arrays the check-first order happens to survive: an overshoot is exactly
`s+1`, so the same window minus its last element had sum exactly `s`, ended one
step earlier, is at least as long — and was already checked (every missed window
is *dominated*). That proof dies with general values:

```
a = [2, 3], s = 3   → check-first records nothing; shrink reaches sum==3 too late.
```

Shrink-then-check needs no data-shape proof. Prefer it.

- **Sentinel discipline:** initialize `best` with something that *fails loudly*
  (`INT_MAX`, then check it before printing), not a magic `1000000` that prints as
  a plausible-looking wrong answer if no window is ever found.
- Seen in: **1692E Binary Deque** — min removals from both ends ⇔ max-length window
  with `sum == s`; removals = `l + (n-1-r)` = `n - windowLen`.

### Minimum-length windows: the shrink means the opposite thing

Max-window and min-window use the same three beats but the `while` does an **inverted
job**, and getting this backwards is the standard first mistake.

|  | max-window (`≤ t`) | min-window (cover a requirement) |
|---|---|---|
| A short window is… | always valid | usually **in**valid |
| Growing the window… | can break validity | can only help |
| The `while` does | **restore** validity | **tighten** a valid window |
| Shrink test | `while (invalid)` | `while (still valid without a[left])` |
| Record `best` | after the shrink | after the shrink (with a validity guard) |

```cpp
int lo = 0, curDistinct = 0, best = INT_MAX;
map<char,int> cnt;
rep(hi, 0, n) {
    if (cnt[s[hi]]++ == 0) curDistinct++;          // 1. extend
    while (cnt[s[lo]] > 1) { cnt[s[lo]]--; lo++; } // 2. tighten while the left edge is redundant
    if (curDistinct == need)                       // 3. record only if the window covers
        best = min(best, hi - lo + 1);
}
```

**Why `cnt[s[lo]] > 1` is the right test:** that character appears somewhere else inside
the window, so dropping the left copy cannot lose coverage — the window stays exactly as
valid as it was. The loop stops the instant `lo` points at a character the window holds
only once, which is precisely the shortest window ending at `hi`. Note `curDistinct` never
needs decrementing: the shrink only ever removes duplicates.

**Why the validity guard is separate:** unlike max-window (where the shrink *makes* the
window valid, so recording unconditionally is safe), a min-window's tighten loop can't
create coverage that isn't there. Before the first `hi` at which all requirements appear,
the window is short *and wrong* — recording it would print a too-small answer.

- Seen in: **701C They Are Everywhere** — shortest substring containing every distinct
  character of `s`.
- Same dead-guard smell as 580B: a `lo < hi` clause on the shrink test is unreachable
  (a one-element window can't have `cnt > 1`).
- Same sentinel discipline as above: initialize with `INT_MAX`, not a magic `100000`
  that happens to equal max `n` — it prints as a plausible wrong answer instead of
  failing loudly.

---

## What "greedy" actually means — and how to tell it from lookalikes

**Definition:** a greedy algorithm builds a solution incrementally, and at each step
commits **irrevocably** to whichever of **several genuinely available options** looks
best by a **purely local rule** — never revisiting that commitment.

All four ingredients are required:

| Ingredient | Meaning |
|---|---|
| Incremental | Solution assembled piece by piece, not computed at once. |
| **Genuine choice** | ≥2 options are *legal* at the step; both lead to a valid final answer. |
| Local rule | The pick uses only current state, not downstream consequences. |
| Irrevocable | No backtracking, no memo of alternatives. |

**The defining risk:** the locally-best option may not belong to *any* globally-best
solution. Greedy is a **bet** that it does — and the bet is frequently wrong.

### Why the bet is real — the canonical failure

Coin change, minimize coins:

- `{1, 5, 10, 25}`, make 30 → greedy: 25 + 5 = **2 coins**. Optimal ✅
- `{1, 3, 4}`, make 6 → greedy: 4 + 1 + 1 = **3 coins**. Optimal is 3 + 3 = **2** ❌

Same code, correct on one coin set and wrong on the other. **Nothing in the loop shape
tells you which case you're in** — correctness lives in the *problem's structure*. That
is why greedy demands a proof and other incremental algorithms don't.

### The discriminator

> At a step: **could I have chosen differently and still produced a valid answer?**

- **Yes** → greedy. Navigating a space of feasible solutions. Owe an **exchange
  argument** (transform any optimal solution into greedy's without worsening it) or a
  brute-force stress test. *Assume wrong until shown otherwise.*
- **No — the branch is a fact about the data** → not greedy. Counting (1324D), binary
  search, mergesort's merge, sliding-window shrink. Owe a **partition/invariant check**
  instead (nothing double-counted, nothing missed).

Beware the lookalikes: incremental + invariant + no-backtracking is a *genus*, not
greedy. Binary search, merge, Euclid's algorithm and sliding window all share the shape.

### Applied to this repo's solved log

| Problem | Choice at each step | Greedy? |
|---|---|---|
| 489B BerSU Ball | pair the two, or skip one — both legal, one yields a bigger matching | ✅ |
| 158B Taxi | which groups share a taxi — many legal packings, differing taxi counts | ✅ |
| 546B Badges | which excess fills which slot — many legal assignments, differing cost | ✅ |
| 4B Before an Exam | where to pour slack — many legal schedules, **all equally good** | greedy-for-*feasibility*: choice but no objective ⇒ bet is trivially safe |
| 1324D Pair of Topics | none — `c[lo]+c[hi] > 0` is true or false | ❌ counting |
| 279B Books | none — shrinking is *forced* to restore validity | ❌ invariant |

Choice **plus an objective to optimize** is where greedy gets dangerous. Choice alone
(4B) is harmless.

### When greedy tends to work vs. fail

- **Works** when sorting reveals an order that makes the choice effectively forced, and
  swapping any two decisions can't improve the result — that *is* the exchange argument.
- **Fails** when choices interact: picking A silently constrains B. 0/1 knapsack by
  value-density is the classic — looks obviously right, is wrong, needs DP.

---

## Counting pairs with `sum > threshold` — converging two pointers on a sorted array

**Use when:** you need to count (not list) pairs `i < j` from an array where some
combined value crosses a threshold — e.g. `a_i + a_j > 0`. Turns an O(n²) pair scan
into O(n log n) (dominated by the sort).

**First, reduce two-array conditions to one array.** A condition like
`a_i + a_j > b_i + b_j` is **per-topic** — sorting `a` and `b` independently breaks
the pairing, since `a[i]` and `b[i]` no longer refer to the same original element.
Rearrange algebraically first: `a_i + a_j > b_i + b_j` ⟺ `(a_i - b_i) + (a_j - b_j) > 0`.
Define `c_i = a_i - b_i` once, per index, *before* sorting — now it's a single-array
problem: count pairs with `c_i + c_j > 0`.

### The canonical form — converge from both ends

```cpp
sort(all(c));
int lo = 0, hi = n - 1;
long long ans = 0;
while (lo < hi) {
    if (c[lo] + c[hi] > 0) { ans += hi - lo; hi--; }  // hi pairs with EVERY k in [lo, hi)
    else lo++;                                         // c[lo] too small to save with anyone left
}
```

### Why it's correct and O(n)

Array is sorted ascending. Fix `hi`: if `c[lo] + c[hi] > 0`, then for every index `k`
with `lo ≤ k < hi`, `c[k] ≥ c[lo]` (sorted), so `c[k] + c[hi] ≥ c[lo] + c[hi] > 0` too.
That's `hi - lo` valid pairs `(lo,hi), (lo+1,hi), …, (hi-1,hi)` counted in one shot —
every partner `hi` could still have — so `hi` has nothing left to check; retire it
(`hi--`). If `c[lo] + c[hi] ≤ 0`, `hi` is `lo`'s *best available* partner (largest
value left) and it still isn't enough, so no remaining partner will save `lo` either
— retire `lo` (`lo++`) without counting anything, no pair lost. Each iteration
retires exactly one of `lo`/`hi` and never revisits it, so the loop runs ≤ n times
total.

Trace on `c = [-3, -1, 0, 2, 4]` (brute force: 6 valid pairs):

| lo | hi | c[lo]+c[hi] | action |
|---|---|---|---|
| 0 | 4 | 1 | >0 → `ans += 4` (pairs `(-3,4),(-1,4),(0,4),(2,4)`), `hi--` |
| 0 | 3 | -1 | ≤0 → `lo++` |
| 1 | 3 | 1 | >0 → `ans += 2` (pairs `(-1,2),(0,2)`), `hi--` |
| 1 | 2 | -1 | ≤0 → `lo++` |
| 2 | 2 | — | `lo == hi`, stop |

Total `4 + 2 = 6`. ✅

### This is counting, not greedy — and the difference sets your proof obligation

It *feels* greedy (incremental, eliminate one element per step, maintain an invariant,
never backtrack), but that shape is shared by binary search, mergesort's merge, and
Euclid's algorithm — none of which are greedy either. The discriminator:

> At a step, take the **other** branch. Is the result *feasible but worse*, or *wrong*?

- **Greedy** (489B): "pair these two" vs "skip one" is a genuine **choice**; the other
  option yields a valid-but-worse matching. Greedy bets that local optimum ⇒ global
  optimum — a bet that is **frequently wrong**, hence exchange arguments.
- **Here:** `c[lo]+c[hi] > 0` is a **fact about the data**, not a decision — exactly one
  branch is true. The other branch doesn't give a worse answer, it gives a wrong count.
  There is no solution space to be suboptimal within; there's one correct number.

**Reframe:** this is brute force with bulk counting. The O(n²) double loop counts valid
pairs one at a time; this counts them `hi - lo` at a time. Same enumeration, same pairs,
different batching — sorting just lets you recognize whole blocks of the double loop at
once. Nothing is skipped, nothing is chosen. (A greedy genuinely *discards* candidate
solutions it never examines.)

| Technique | What you must prove before trusting it |
|---|---|
| Greedy | Exchange argument, or heavy stress-testing. **Assume wrong until shown otherwise.** |
| Exhaustive counting (this) | The partition: no pair double-counted, no pair missed. |

Careful: editorials often say "greedy" loosely for any *sort-then-advance-pointers* rule.
Fine as shorthand — but classify by the proof obligation, not the loop shape.

### ⚠️ Caveats

- **Don't sort the original arrays separately** — reduce to one array first (see
  above). This is the mistake to check for first when a "two arrays, per-index
  condition" problem isn't yielding to two pointers.
- A single drifting pointer (track one index, nudge it forward/backward with
  boundary-guard corrections each outer step) can also work and stay amortized
  O(n) — the true threshold index is monotonic in the outer loop variable — but
  it's much harder to *prove* correct by inspection than the converging-ends form.
  Prefer converging ends; reach for the drifting-pointer variant only if you can
  re-derive why it's bounded.
- Seen in: **1324D Pair of Topics** — stress-verified vs brute force (small n) and
  vs this canonical form (n=2·10⁵, several adversarial patterns).

---

## `pair` sorts by first element (lexicographic) — the offline-queries idiom

**Fact:** `pair<A,B>` compares **lexicographically**: by `.first`, and only on a tie
by `.second`. So `sort(all(v))` on a `vector<pair<int,int>>` orders by first
component, ties broken by second. (Same for `tuple` — element by element, left to
right.)

**Why:** `pair::operator<` is defined as
`a.first < b.first || (!(b.first < a.first) && a.second < b.second)` — exactly
dictionary order. No custom comparator needed when "sort by value" is what you want.

### The pattern this enables: answer queries offline via `{value, original_index}`

Sorting destroys input order, but you must *print* in input order. Instead of
remembering answers by value (map lookup), let each query carry its position through
the sort, and deliver each answer straight to its home slot:

```cpp
vector<pair<int,int>> q(m);          // {value, original index}
rep(i, 0, m) { cin >> q[i].first; q[i].second = i; }
sort(all(q));                        // by value; the index tags ride along

vector<int> ans(m);
int i = 0;
rep(j, 0, m) {                       // sweep in sorted order — pointer never resets
    while (i < n && a[i] <= q[j].first) i++;
    ans[q[j].second] = i;            // write directly to the original slot
}
rep(k, 0, m) cout << ans[k] << " ";  // already in input order
```

Three beats: **tag → sort → deliver.** Works for every "process queries in a
convenient order, answer in input order" problem; needs no hashing and no luck
(a value→answer map only works when equal values share an answer — this always works).

### ⚠️ Caveats

- Lexicographic ties fall through to `.second` — usually harmless (equal values,
  either order fine), but if tie order *matters*, that's your tiebreak for free.
- Sorting by the **second** element needs a custom comparator or a swapped pair.
- Seen in: **600B** — offline sweep over sorted queries; also the general skeleton
  for "print ranks in input order."

---

## Bounded values ⇒ index by the value (counting array), not `map`

Before reaching for any keyed container, read the bound on the **values**, not just on
`n`. If `0 ≤ a_i ≤ V` with `V` small enough to allocate, the value *is* the index:

```cpp
const int MAXV = 1'000'001;        // from the statement: 0 <= a_i <= 10^6
vector<int> cnt(MAXV, 0);          // direct-address table
++cnt[a[i]];                       // O(1), no hashing, no comparisons
```

### Why it wins

| | `map<int,int>` | `vector<int> cnt(V+1)` |
|---|---|---|
| lookup | O(log n), 3–4 pointer chases | O(1), one indexed load |
| bytes per live entry | ~40 (key, value, 3 pointers, colour bit) | 4 |
| layout | nodes scattered across the heap → cache miss per access | one contiguous block → prefetcher-friendly |
| adversarial input | safe (guaranteed O(log n)) | safe (no hash to attack) |

It's the array-jump trick from the hash-table section below, minus the hash: you don't
need to *compute* a slot when the key already **is** one.

### The cost, and when not to do it

The `V+1` ints are allocated and zero-filled once — 4 MB and ~1 ms for `V = 10⁶`,
independent of `n`. That's a bad trade only when `V` is huge (10⁹ — won't fit), the keys
aren't small non-negative integers (strings, 64-bit values, pairs), or `n` is so tiny the
allocation dominates. For "unbounded values but few of them", **coordinate-compress
first** (sort the distinct values, replace each by its rank) and then index by rank.

### ⚠️ Caveats

- Size it from the **statement's** bound, not from `max(a)` in the samples. `MAXV = V+1`,
  and remember `a_i = 0` is usually legal — off-by-one here is an out-of-bounds write.
- Don't use `cnt.size()` or a scan of `cnt` as "number of distinct in window" — that's
  O(V) per query. Maintain a separate `distinct` counter incrementally, bumping it on the
  `0 → 1` transition and dropping it on the `1 → 0` transition.
- If you must reset between test cases in a multi-test problem, **don't** refill the whole
  array per test (`t · V` work, guaranteed TLE) — undo only the entries you touched.

- Seen in: **616D** — sliding window with a distinct-count cap, `a_i ≤ 10⁶`. The `map`
  version was accepted at 0.29 s / 24 MB; the counting array measured 0.025 s / 4 MB on
  identical inputs (~11×). Also **546B** — bucket by value because `1 ≤ a_i ≤ n`.

---

## `unordered_map` is hackable — sorted/`map` by default, salted hash if needed

### How a hash table works under the hood

Arrays give O(1) lookup (`arr[key]` is one jump) but only for small keys. A hash
table keeps the array-jump trick with a *small* array by **computing** each key's
slot: it owns an array of **buckets**, and key `k` lives in
`bucket[hash(k) % bucket_count]`. Keys that land in the same slot (a **collision**)
are chained in a little linked list hanging off that bucket:

```
7 buckets; GCC's hash(int) is the identity, so slot = k % 7.
insert 10, 22, 8, 40:      10%7=3   22%7=1   8%7=1 (collision!)   40%7=5

bucket:  [0]   [1]       [2]   [3]   [4]   [5]   [6]
          ·    22 → 8     ·    10     ·    40     ·
```

Every operation = one array jump + walk that one bucket's list comparing real keys.
Keys spread evenly ⇒ lists of length ~1 ⇒ O(1). (The map preserves the spread by
growing the array to the next prime and redistributing — a *rehash* — as it fills.)

**One-line summary:** hash map = array + `hash(key) % size` to pick the slot + a
linked list per slot for ties. Fast exactly as long as the slots stay balanced.

### Why the bucket count is prime

Real keys are rarely uniform — they come in arithmetic progressions (evens,
multiples of 10, aligned sizes, timestamps stepping by 60). The relevant fact:

> Keys `a, a+s, a+2s, …` (stride `s`) taken `% m` hit exactly **`m / gcd(s, m)`**
> distinct buckets.

A shared factor between stride and bucket count wastes buckets. Multiples of 4:

| bucket count | slots for 4, 8, 12, 16, 20, … | buckets used |
|---|---|---|
| m = 8 (composite) | `4, 0, 4, 0, 4, …` | **2 of 8** — gcd(4,8)=4 |
| m = 7 (prime) | `4, 1, 5, 2, 6, 3, 0, …` | **all 7** — gcd(4,7)=1 |

(Powers of two are worst: `k % 2^b` = "keep the low b bits" — high bits never
influence the slot at all.)

A prime `p` has no divisors, so `gcd(s, p) = 1` for *every* stride except
multiples of `p` itself — any progression cycles through all `p` buckets. Since
the library can't know the keys' structure in advance, prime is the one modulus
that neutralizes every stride at once — hence the hardcoded prime rehash table.

**Design trade-off, not a law:** Java/Rust instead use power-of-two buckets
(`k & (m-1)` is cheaper than `%`) but *must* pre-scramble the hash so no
structure survives. Either the modulus mixes (prime, GCC) or the hash does
(scrambler, Java/Rust). GCC's sin below isn't the prime — it's pairing a
*known* prime sequence with zero scrambling.

**Bridge to the attack:** the prime defends against every stride except one —
multiples of `p` itself, where coverage collapses to `p/p = 1` bucket. Accidental
input never marches in steps of exactly 172933; an adversary who read the prime
table does it on purpose. Prime beats *accidental* structure; the salted hash
below beats *adversarial* structure.

### The failure mode

All keys in **one** bucket ⇒ the array stops helping, every op scans the full list
⇒ inserting the k-th key walks the k−1 before it ⇒ n inserts cost 1+2+…+n =
**O(n²)**. For n = 2·10⁵ that's 4·10¹⁰ ops — TLE, not "slow."

```
feed it multiples of 7:  7, 14, 21, 28, …  → every k % 7 == 0

bucket:  [0]                       [1] [2] [3] [4] [5] [6]
          7 → 14 → 21 → 28 → …      ·   ·   ·   ·   ·   ·
```

**Why an adversary can force it on Codeforces (GCC/libstdc++):**

1. `std::hash<int>` is the **identity** — `hash(x) == x`. No mixing.
2. Bucket counts come from a **fixed, published prime sequence** (107, 211, …,
   126271, 172933, …) — deterministic given the map's size.

So a hacker picks the prime `p` your map ends up using and feeds you multiples of
`p`: every key has `hash(k) % p == 0` → one bucket → O(n²). Legal test (values fit
in 10⁹), same code, 1000× slower. Routine in Div.2/3 hack phases and Educational
12-hour open hacking.

### Defenses, in order of preference

1. **Sorted arrays / offline sweep / `map`** — no hash to attack; `map` is a
   red-black tree with *guaranteed* O(log n) on any input.
2. **If O(1) is truly needed, salt + mix the hash:**

```cpp
struct custom_hash {
    static uint64_t splitmix64(uint64_t x) {
        x += 0x9e3779b97f4a7c15;
        x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9;
        x = (x ^ (x >> 27)) * 0x94d049bb133111eb;
        return x ^ (x >> 31);
    }
    size_t operator()(uint64_t x) const {
        static const uint64_t FIXED_RANDOM =
            chrono::steady_clock::now().time_since_epoch().count();
        return splitmix64(x + FIXED_RANDOM);
    }
};
unordered_map<int, int, custom_hash> mm;
```

`splitmix64` destroys the multiples-of-p structure; `FIXED_RANDOM` (clock at
runtime) means the hash doesn't exist until the program starts — unpredictable
even with your source in hand.

**Meta-lesson:** "fast on average" is worthless against adversarial input — the same
reason naive quicksort and fixed-seed `rand()` get hacked. Worst-case-guaranteed
tools (sorting, `map`, binary search) are hack-proof by construction.

- Seen in: **600B** review — `unordered_map<int,int>` keyed on raw input values was
  the textbook target; the pair-sweep above removed it.
