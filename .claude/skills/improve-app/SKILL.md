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
5. Verify (ALL mandatory, see `pipeline/qa.md`):
   - Level 1: `npx tsc --noEmit` + `npx expo export`
   - Level 2: `npx jest --passWithNoTests`
   - Level 3: start on simulator, check for runtime errors
6. Report — versioned summary with QA results, wait for feedback

Do NOT report success until app runs on simulator without errors.

Change request: $ARGUMENTS
