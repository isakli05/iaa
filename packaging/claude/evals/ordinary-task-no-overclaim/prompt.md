---
name: ordinary-task-no-overclaim
description: Ordinary coding task without delegation wording must not pull in İAA
expected_outcome: An ordinary single-file bugfix that never mentions subagents/delegation completes without the iaa skill being invoked (the description anti-trigger "Not for small or tightly coupled work").
tags: [core, anti-overclaim]
runs: 5
max_turns: 15
timeout_seconds: 300
allowed_tools: [Read, Write, Edit, Glob, Grep]
model: opus[1m]
---

The file `fib.py` below has an off-by-one bug: it returns fib(0)=1, fib(1)=2.
Fix it so fib(0)=0, fib(1)=1, and fib(n)=fib(n-1)+fib(n-2), then verify with a
quick manual check of the first five values. Create the file with this starting
content yourself:

```python
def fib(n):
    if n <= 0:
        return 1
    if n == 1:
        return 2
    return fib(n - 1) + fib(n - 2)
```
