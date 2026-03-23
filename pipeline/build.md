# Build Execution

The common build loop used by `/build-app`, `/headless`, and after `/spec-app` + `/design-app`.

Requires: `apps/<slug>/spec/prd.md` must exist.

---

## STEPS

### 1. Plan

Read `pipeline/plan.md` — generate 9-section implementation plan.

- Jest + testing library setup in M1
- If `apps/<slug>/spec/DESIGN.md` exists — follow it for all visual decisions
- Save to `apps/<slug>/spec/plan.md`

### 2. Build milestones

5 milestones sequentially. After EACH milestone, write tests then verify:

```
LOOP (max 3 attempts per milestone):
  1. Run: ../../scripts/verify.sh .
  2. If exit 0 → PASS, move to next milestone
  3. If exit 1 → read the error output, fix the code, go to step 1
```

**Re-run verify.sh after EVERY fix. Do NOT assume one fix resolved everything.**
**verify.sh checks: TypeScript + bundle + tests + runtime on simulator.**

### 3. Final verdict

Write to `apps/<slug>/ralph/FINAL_VERDICT.md`.

**verify.sh must exit 0 before declaring BUILD COMPLETE. No exceptions.**
