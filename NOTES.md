# Notes

For each problem where you opened the editorial, log the idea you missed.
Patterns in your misses reveal your weak topics.

| Problem                 | Rating | Topic          | The idea I missed                                                                                                                                                                    |
| ----------------------- | ------ | -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1A Theatre Square       | 1000   | math           | ceil division: (n + a - 1) / a, use long long                                                                                                                                        |
| 158A Next Round         | 800    | implementation | clever-but-twisty beats simple only when simple isn't fast enough                                                                                                                    |
| 158B Taxi               | 1100   | greedy         | when order doesn't matter, reach for counts, not pointers                                                                                                                            |
| 546B Soldier and Badges | 1200   | greedy         | if a task's description allows certain cases that look strange in the task context ALWAYS take them into account as real. They ARE age cases and author probably want to confuse you |
| 1324D Pair of Topics    | 1400   | two pointers   | asked "how do I scan the array?" (→ one drifting pointer + boundary patches) instead of "which element can I **completely finish** right now?". On a sorted array the extremes are never ambiguous: `hi` either pairs with all of `[lo,hi)` or `lo` pairs with nothing left — so one of them is fully accounted for every step, count it in bulk and retire it. Also: this is **counting/partition, not greedy** — no choice is made, each step is a deduction, so no exchange argument is needed |
