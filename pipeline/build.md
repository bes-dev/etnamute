# Build Execution

The common build loop used by `/build-app`, `/headless`, and after `/spec-app` + `/design-app`.

Requires: `apps/<slug>/spec/prd.md` must exist.

---

## STEPS

### 1. Plan

Read `pipeline/plan.md` — generate 9-section implementation plan.

- If testing level is Standard or Full: include Jest + testing library setup in M1
- If `apps/<slug>/spec/DESIGN.md` exists — follow it for all visual decisions
- Save to `apps/<slug>/spec/plan.md`

### 2. Build milestones

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

### 3. Final verdict

Write to `apps/<slug>/ralph/FINAL_VERDICT.md`. Include testing level used.

**verify.sh must exit 0 (Standard/Full) or tsc+bundle+runtime must pass (Fast) before BUILD COMPLETE.**

### 4. Recommend next steps

After BUILD COMPLETE:

**If Fast:** recommend `/test-app <slug>` for thorough testing before release.
**If Standard:** recommend `/test-app <slug>` for UI verification.
**If Full:** testing already done — recommend `/market-app <slug>` and `/release-app <slug>`.
