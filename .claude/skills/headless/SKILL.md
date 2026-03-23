---
name: headless
description: Build an app from a pre-written PRD file without interactive discovery
disable-model-invocation: true
---

Build an app from a ready PRD. No interview, no interaction.

1. Read `pipeline/headless.md` — validate PRD against `pipeline/prd-schema.md`
2. If invalid — list errors and stop
3. Copy PRD to `apps/<slug>/spec/prd.md`
4. Read `pipeline/plan.md` — generate implementation plan with jest setup in M1
5. Build all milestones. After EACH milestone run ALL QA levels:

   **Level 1:** `npx tsc --noEmit && npx expo export`
   **Level 2:** `npx jest --passWithNoTests`
   **Level 3 (CRITICAL):**
   ```bash
   npx expo start --ios 2>&1 | tee /tmp/expo-runtime.log &
   sleep 30
   grep -iE "ERROR|TypeError|ReferenceError|is not a function|is undefined|Exception in HostFunction" /tmp/expo-runtime.log
   ```
   If errors → fix, re-run. Kill expo after: `kill %1`

6. Write final verdict to `apps/<slug>/ralph/FINAL_VERDICT.md`

**You MUST run the app on simulator and verify zero ERROR lines before declaring BUILD COMPLETE.**

PRD path: $ARGUMENTS
