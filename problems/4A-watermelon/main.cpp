// # 4A — Watermelon
// https://codeforces.com/problemset/problem/4/A
//
// Split weight w into two even positive parts. Possible iff w is even and w > 2.

#include <bits/stdc++.h>
using namespace std;

void solve() {
    int w;
    cin >> w;
    cout << (w > 2 && w % 2 == 0 ? "YES" : "NO") << '\n';
}

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
    solve();
    return 0;
}
