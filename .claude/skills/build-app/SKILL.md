---
name: build-app
description: Generate a new mobile app from an idea through interactive discovery
disable-model-invocation: true
---

Build a new mobile app. Follow the full pipeline:

1. Read `pipeline/discovery.md` — analyze idea, run adaptive interview via AskUserQuestion
2. Read `pipeline/spec.md` — web research + PRD generation + Stitch design (if available) + user approval
3. Read `pipeline/plan.md` — generate implementation plan with jest setup in M1
4. Build all milestones. After EACH milestone, write tests then enter the verify loop:

   ```
   LOOP (max 3 attempts):
     1. Run: ../../scripts/verify.sh .
     2. If exit 0 → PASS, move to next milestone
     3. If exit 1 → read the error output, fix the code, go to step 1
   ```

   **You MUST re-run verify.sh after EVERY fix. Do NOT assume one fix resolved everything — new errors can appear.** Continue the loop until verify.sh exits 0 or you've exhausted 3 attempts.

5. Write final verdict to `apps/<slug>/ralph/FINAL_VERDICT.md`

**verify.sh must exit 0 before declaring BUILD COMPLETE. No exceptions.**

User's idea: $ARGUMENTS

Start with Phase 0a — analyze the idea and ask the first question.
