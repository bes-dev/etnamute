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
   ```
   Wait 45-60 seconds, then:
   ```bash
   cat /tmp/expo-runtime.log | grep -iE "ERROR|TypeError|ReferenceError|is not a function|is undefined|Exception in HostFunction"
   ```
   Kill: `kill %1 2>/dev/null`
   **If ANY matches → app is BROKEN. Fix and re-run. "Bundled successfully" ≠ app works.**

6. Write final verdict to `apps/<slug>/ralph/FINAL_VERDICT.md`

PRD path: $ARGUMENTS
