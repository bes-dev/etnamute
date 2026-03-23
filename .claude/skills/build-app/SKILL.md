---
name: build-app
description: Generate a new mobile app from an idea through interactive discovery
disable-model-invocation: true
---

Build a new mobile app. Follow the full pipeline:

1. Read `pipeline/discovery.md` — analyze idea, run adaptive interview via AskUserQuestion
2. Read `pipeline/spec.md` — web research + PRD generation + Stitch design (if available) + user approval
3. Read `pipeline/plan.md` — generate implementation plan with jest setup in M1
4. Build all milestones. After EACH milestone run ALL QA levels:

   **Level 1 — Build check:**
   ```bash
   npx tsc --noEmit && npx expo export
   ```
   If either fails → fix before proceeding.

   **Level 2 — Tests:**
   Write tests for the milestone, then:
   ```bash
   npx jest --passWithNoTests
   ```
   If fails → fix before proceeding.

   **Level 3 — Runtime check (CRITICAL):**
   ```bash
   npx expo start --ios 2>&1 | tee /tmp/expo-runtime.log &
   ```
   Then WAIT — do NOT immediately check. The runtime errors appear AFTER bundling completes.
   After 45-60 seconds:
   ```bash
   cat /tmp/expo-runtime.log | grep -iE "ERROR|TypeError|ReferenceError|is not a function|is undefined|Exception in HostFunction|Invariant Violation"
   ```
   Then kill the process:
   ```bash
   kill %1 2>/dev/null
   ```

   **If grep finds ANY matches — the app is BROKEN.** Read the error, fetch docs via mcpdoc, fix the code, and re-run Level 3. Do NOT proceed.

   **If grep finds nothing — PASS.** Proceed to next milestone.

   **COMMON TRAP: "Bundled successfully" does NOT mean the app works.** Reanimated, SplashScreen, expo-av, and other native modules can bundle fine but crash at runtime. The ERROR lines appear in the log AFTER the "Bundled Xms" line. You MUST wait long enough and grep the FULL log.

5. Write final verdict to `apps/<slug>/ralph/FINAL_VERDICT.md`

User's idea: $ARGUMENTS

Start with Phase 0a — analyze the idea and ask the first question.
