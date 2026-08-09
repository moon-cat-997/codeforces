// # 676C — vasya-and-string
// https://codeforces.com/problemset/problem/676/C
//
// Workflow:
//   - paste the problem's sample cases into tests/1.in, tests/1.out, ...
//   - run:  ./scripts/test.sh <slug>       (compile + check against all samples)
//   - debug with dbg(...) — printed to stderr locally, compiled out on Codeforces.

#include <bits/stdc++.h>
using namespace std;

using ll = long long;
using ull = unsigned long long;
using pii = pair<int, int>;
using pll = pair<ll, ll>;
template <class T> using vec = vector<T>;

#define all(x)       (x).begin(), (x).end()
#define rall(x)      (x).rbegin(), (x).rend()
#define sz(x)        ((int)(x).size())
#define rep(i, a, b) for (int i = (a); i < (b); ++i)

// ---- debug: active only when compiled with -DLOCAL (test.sh does this) ----
#ifdef LOCAL
template <class T> void _print(const T& x) { cerr << x; }
template <class A, class B> void _print(const pair<A, B>& p) {
    cerr << '(';
    _print(p.first);
    cerr << ", ";
    _print(p.second);
    cerr << ')';
}
template <class T> void _print(const vector<T>& v) {
    cerr << '[';
    bool f = true;
    for (const auto& e : v) {
        if (!f) cerr << ", ";
        f = false;
        _print(e);
    }
    cerr << ']';
}
void _dbg() { cerr << '\n'; }
template <class T, class... R> void _dbg(const T& x, const R&... r) {
    _print(x);
    if (sizeof...(r)) cerr << ", ";
    _dbg(r...);
}
#define dbg(...) cerr << "[" << #__VA_ARGS__ << "] = ", _dbg(__VA_ARGS__)
#else
#define dbg(...)
#endif
// ---------------------------------------------------------------------------

int run(string s, int k, char letter) {
    int end = 0;
    int best = 0;
    int restSwaps = k;
    rep(start, 0, sz(s)) {
        if (start > end) end = start;
        while (end < sz(s)) {
            if (s[end] == letter && restSwaps <= 0) break;
            if (s[end] == letter) restSwaps--;
            end++;
        }
        if (s[start] == letter) restSwaps = min(k, restSwaps + 1);
        best = max(best, end - start);
    }

    return best;
}

void solve() {
    int n;
    cin >> n;
    int k;
    cin >> k;
    string s;
    cin >> s;

    int best = run(s, k, 'b');
    best = max(best, run(s, k, 'a'));
    cout << best << "\n";
}

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    int t = 1;
    // cin >> t;   // <-- uncomment for "t test cases" problems
    while (t--) solve();
    return 0;
}
