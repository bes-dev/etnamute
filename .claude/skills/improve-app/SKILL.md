---
name: improve-app
description: Add/remove features, fix bugs, redesign — keeping code clean and artifacts in sync
disable-model-invocation: true
---

Improve an existing app. Read `pipeline/improve.md` and follow ALL steps:

1. Understand — read PRD and code
2. Clarify — ask only if ambiguous
3. Plan — PRD impact, files, dead code, tests to write, version bump
4. Apply — update PRD first, then code, write/update tests, clean dead code
5. Run `../../scripts/verify.sh .` in a loop (max 3 attempts) until exit 0
6. Report — versioned summary with verify.sh output, wait for feedback

**verify.sh must exit 0 before reporting success.**

Change request: $ARGUMENTS
