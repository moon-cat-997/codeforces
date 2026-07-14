# Convenience wrapper around scripts/. Plain shell works too.
#
#   make new ID=4A T=watermelon     # scaffold problems/4A-watermelon/
#   make test P=4A-watermelon        # compile + check against samples
#   make run P=4A-watermelon         # compile + run, reading from your keyboard

# Newest Homebrew GNU g++ (real libstdc++ + <bits/stdc++.h>, matching
# Codeforces); falls back to plain g++. Override with `make run CXX=...`.
CXX := $(shell ls /opt/homebrew/bin/g++-* /usr/local/bin/g++-* 2>/dev/null | sort -V | tail -1)
CXX := $(or $(CXX),g++)

.PHONY: new test run

new:
	@./scripts/new.sh $(ID) $(T)

test:
	@./scripts/test.sh $(P)

run:
	@$(CXX) -std=gnu++23 -O2 -DLOCAL -o /tmp/cf_run problems/$(P)/main.cpp && /tmp/cf_run
