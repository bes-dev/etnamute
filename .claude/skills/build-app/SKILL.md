---
name: build-app
description: Generate a new mobile app — full pipeline or code-only if PRD already exists
disable-model-invocation: true
---

Build a new mobile app.

**If `apps/<slug>/spec/prd.md` already exists** (created by `/spec-app`):
- Skip interview and PRD generation
- Go straight to Phase 1

**If no PRD exists:**
- Run the full spec process: follow every step in `.claude/skills/spec-app/SKILL.md`

User's idea: $ARGUMENTS

---

## PHASE 1: PLAN

Read `pipeline/plan.md` — generate 9-section implementation plan.

- If testing level is Standard or Full: include Jest + testing library setup in M1
- If `apps/<slug>/spec/DESIGN.md` exists — follow it for all visual decisions
- Save to `apps/<slug>/spec/plan.md`

---

## PHASE 2: BUILD MILESTONES

5 milestones sequentially. After EACH milestone, verify based on testing level:

**Fast:**
```
LOOP (max 3 attempts):
  1. npx tsc --noEmit && npx expo export
  2. Start on simulator, check runtime log for errors (45s wait)
  3. If errors → fix → go to 1
```
No jest, no unit tests. User tests manually.

**Standard:**
```
LOOP (max 3 attempts):
  1. Run: ../../scripts/verify.sh .
     (tsc + bundle + jest + runtime on simulator)
  2. If exit 0 → PASS
  3. If exit 1 → fix → go to 1
```
Write unit tests for every handler alongside the code.

**Full:**
Same as Standard, plus after final milestone (M5):
1. Generate `.maestro/` flows (smoke + functional + persistence)
2. Run Maestro tests
3. Capture screenshots → read and verify visually
4. Fix any bugs found → re-run
(This is equivalent to running `/test-app` inline.)

For test writing guidelines, see `pipeline/qa.md`.

---

## PHASE 3: FINALIZE

Write to `apps/<slug>/ralph/FINAL_VERDICT.md`. Include testing level used.

**verify.sh must exit 0 (Standard/Full) or tsc+bundle+runtime must pass (Fast) before BUILD COMPLETE.**

---

## RECOMMEND NEXT STEPS

After BUILD COMPLETE:

**If Fast:** recommend `/test-app <slug>` for thorough testing before release.
**If Standard:** recommend `/test-app <slug>` for UI verification.
**If Full:** testing already done — recommend `/market-app <slug>` and `/release-app <slug>`.
