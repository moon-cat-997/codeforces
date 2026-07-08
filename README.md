# Codeforces (C++)

A workspace for solving, running, and sample-testing Codeforces problems in C++.
Unlike LeetCode, Codeforces problems read from **stdin** and write to **stdout**,
so each problem is a standalone `main.cpp` checked against the sample cases you
paste from the problem page.

Compiles with **GNU C++23 `-O2`** — the same toolchain Codeforces runs — so
"passes locally" means "compiles and matches samples there too".

## Layout

```
template/main.cpp        # the starting point every problem is scaffolded from
problems/
  4A-watermelon/         # <id>-<slug>
    main.cpp             # your solution
    tests/
      1.in  1.out        # sample case 1 (paste from the problem page)
      2.in  2.out        # sample case 2 ...
scripts/
  new.sh                 # scaffold a problem folder
  test.sh                # compile + diff against every sample
```

## Workflow

**Start a problem** (`<id>` = contest+letter, e.g. `4A`, `1742C`):

```bash
./scripts/new.sh 4A watermelon        # -> problems/4A-watermelon/
# or:  make new ID=4A T=watermelon
```

**Paste the samples** from the problem page into `tests/1.in` / `tests/1.out`
(add `2.in`/`2.out`, ... for each extra sample). Then write your solution in
`main.cpp`.

**Check against all samples:**

```bash
./scripts/test.sh 4A-watermelon       # or: make test P=4A-watermelon
```

Output is per-sample `✓`/`✗`; failures show expected-vs-got. Comparison ignores
trailing whitespace and the final newline.

**Run interactively** (type input yourself, e.g. to probe edge cases):

```bash
make run P=4A-watermelon
```

## Debugging

`main.cpp` ships with a `dbg(...)` macro that prints to **stderr**:

```cpp
int x = 5; vector<int> v{1,2,3};
dbg(x, v);            // stderr:  [x, v] = 5, [1, 2, 3]
```

It is active only under `-DLOCAL` (which `test.sh` sets) and **compiles to
nothing on Codeforces** — so you can leave `dbg(...)` calls in when you submit.
stderr also doesn't affect sample checking (only stdout is compared).

For step debugging: `g++ -std=gnu++23 -g -DLOCAL -o /tmp/sol problems/<slug>/main.cpp`
then `gdb /tmp/sol`.

## Template cheatsheet

`template/main.cpp` includes `<bits/stdc++.h>`, fast IO
(`sync_with_stdio(false)`), `ll`/`pii` aliases, `all(x)`/`sz(x)`/`rep(...)`
macros, and the multi-test loop (uncomment `cin >> t;` for "t test cases"
problems — the common Div.2/Div.3 format).
