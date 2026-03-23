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

   **Level 3 — Runtime check (CRITICAL — do NOT skip):**
   ```bash
   npx expo start --ios 2>&1 | tee /tmp/expo-runtime.log &
   sleep 30
   grep -iE "ERROR|TypeError|ReferenceError|is not a function|is undefined|Exception in HostFunction" /tmp/expo-runtime.log
   ```
   If ANY errors in log → read the error, fetch docs via mcpdoc, fix, re-run.
   KILL the expo process after checking: `kill %1`

5. Write final verdict to `apps/<slug>/ralph/FINAL_VERDICT.md`

**CRITICAL: The #1 failure mode is declaring BUILD COMPLETE without running Level 3. Reanimated, SplashScreen, and other native modules can bundle correctly but crash at runtime. You MUST run the app on simulator and verify zero ERROR lines in the log before declaring complete.**

User's idea: $ARGUMENTS

Start with Phase 0a — analyze the idea and ask the first question.
