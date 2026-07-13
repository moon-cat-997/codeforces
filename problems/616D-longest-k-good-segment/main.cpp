// # 616D — longest-k-good-segment
// https://codeforces.com/problemset/problem/616/D
//
// Workflow:
//   - paste the problem's sample cases into tests/1.in, tests/1.out, ...
//   - run:  ./scripts/test.sh <slug>       (compile + check against all samples)
//   - debug with dbg(...) — printed to stderr locally, compiled out on Codeforces.

#include <bits/stdc++.h>
using namespace std;

using ll  = long long;
using ull = unsigned long long;
using pii = pair<int, int>;
using pll = pair<ll, ll>;
template <class T> using vec = vector<T>;

#define all(x)    (x).begin(), (x).end()
#define rall(x)   (x).rbegin(), (x).rend()
#define sz(x)     ((int)(x).size())
#define rep(i, a, b) for (int i = (a); i < (b); ++i)

// ---- debug: active only when compiled with -DLOCAL (test.sh does this) ----
#ifdef LOCAL
template <class T> void _print(const T& x) { cerr << x; }
template <class A, class B> void _print(const pair<A, B>& p) {
    cerr << '('; _print(p.first); cerr << ", "; _print(p.second); cerr << ')';
}
template <class T> void _print(const vector<T>& v) {
    cerr << '['; bool f = true;
    for (const auto& e : v) { if (!f) cerr << ", "; f = false; _print(e); }
    cerr << ']';
}
void _dbg() { cerr << '\n'; }
template <class T, class... R> void _dbg(const T& x, const R&... r) {
    _print(x); if (sizeof...(r)) cerr << ", "; _dbg(r...);
}
#define dbg(...) cerr << "[" << #__VA_ARGS__ << "] = ", _dbg(__VA_ARGS__)
#else
#define dbg(...)
#endif
// ---------------------------------------------------------------------------

void solve() {
    // Read input from cin, write the answer to cout.
}

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    int t = 1;
    // cin >> t;   // <-- uncomment for "t test cases" problems
    while (t--) solve();
    return 0;
}
