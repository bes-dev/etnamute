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
5. Verify — ALL levels mandatory:

   **Level 1:** `npx tsc --noEmit && npx expo export`
   **Level 2:** `npx jest --passWithNoTests`
   **Level 3 (CRITICAL):**
   ```bash
   npx expo start --ios 2>&1 | tee /tmp/expo-runtime.log &
   sleep 30
   grep -iE "ERROR|TypeError|ReferenceError|is not a function|is undefined|Exception in HostFunction" /tmp/expo-runtime.log
   ```
   If errors → fix, re-run. Kill expo after: `kill %1`

6. Report — versioned summary with QA results, wait for feedback

**You MUST run the app on simulator and verify zero ERROR lines before reporting success.**

Change request: $ARGUMENTS
