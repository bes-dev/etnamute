---
name: build-app
description: Generate a new mobile app — full pipeline or code-only if PRD already exists
disable-model-invocation: true
---

Build a new mobile app.

**If `apps/<slug>/spec/prd.md` already exists** (created by `/spec-app`):
- Skip interview and PRD generation
- Read existing PRD
- Go straight to planning and building

**If no PRD exists:**
1. Read `pipeline/discovery.md` — analyze idea, run adaptive interview
2. Read `pipeline/spec.md` — web research + PRD + name + Stitch + approval preferences

**Then:**
3. Read `pipeline/plan.md` — generate implementation plan with jest setup in M1
4. If `apps/<slug>/spec/DESIGN.md` exists (from `/design-app`) — follow it for all visual decisions
5. Build all milestones. After EACH milestone, write tests then enter the verify loop:

   ```
   LOOP (max 3 attempts):
     1. Run: ../../scripts/verify.sh .
     2. If exit 0 → PASS, move to next milestone
     3. If exit 1 → read the error output, fix the code, go to step 1
   ```

   **You MUST re-run verify.sh after EVERY fix. Do NOT assume one fix resolved everything.**

6. Write final verdict to `apps/<slug>/ralph/FINAL_VERDICT.md`

**verify.sh must exit 0 before declaring BUILD COMPLETE. No exceptions.**

User's idea: $ARGUMENTS

If PRD exists, start building. If not, start with Phase 0a.
