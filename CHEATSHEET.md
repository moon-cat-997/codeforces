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
