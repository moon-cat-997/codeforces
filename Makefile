# Convenience wrapper around scripts/. Plain shell works too.
#
#   make new ID=4A T=watermelon      # scaffold problems/4A-watermelon/
#   make test P=4A-watermelon         # compile + check against samples
#   make run P=4A-watermelon          # compile + run, reading from your keyboard
#   make debug P=4A-watermelon        # sanitizer run on tests/1.in (catches UB / OOB)
#   make debug P=4A-watermelon N=2    # ...on tests/2.in
#   make gdb P=4A-watermelon          # step through in gdb, stopped at solve()

# Newest GNU g++ (Homebrew on macOS, versioned or plain on Linux; real libstdc++
# + <bits/stdc++.h>, matching Codeforces). Override with `make run CXX=...`.
CXX := $(shell ls /opt/homebrew/bin/g++-* /usr/local/bin/g++-* /usr/bin/g++-* 2>/dev/null | sort -V | tail -1)
CXX := $(or $(CXX),g++)

.PHONY: new test run debug gdb

new:
	@./scripts/new.sh $(ID) $(T)

test:
	@./scripts/test.sh $(P)

run:
	@$(CXX) -std=gnu++23 -O2 -DLOCAL -o /tmp/cf_run problems/$(P)/main.cpp && /tmp/cf_run

debug:
	@./scripts/debug.sh $(P) $(N)

gdb:
	@./scripts/debug.sh $(P) --gdb $(N)
