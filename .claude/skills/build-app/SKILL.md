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

5 milestones sequentially. After EACH milestone, run the verify loop from `pipeline/qa.md` (reads testing level from `apps/<slug>/spec/testing-level.txt`).

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
