# Convenience wrapper around scripts/. Plain shell works too.
#
#   make new ID=4A T=watermelon     # scaffold problems/4A-watermelon/
#   make test P=4A-watermelon        # compile + check against samples
#   make run P=4A-watermelon         # compile + run, reading from your keyboard

.PHONY: new test run

new:
	@./scripts/new.sh $(ID) $(T)

test:
	@./scripts/test.sh $(P)

run:
	@g++ -std=gnu++23 -O2 -DLOCAL -o /tmp/cf_run problems/$(P)/main.cpp && /tmp/cf_run
