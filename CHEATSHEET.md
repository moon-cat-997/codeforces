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
