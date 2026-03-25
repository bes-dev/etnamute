---
name: testing
description: Full QA procedure — interaction map, unit tests, Maestro flows, visual review
---

Complete testing procedure for an app. Follow EVERY step in order. Do NOT skip steps.

## Step 1: Interaction map

Read `.claude/skills/interaction-map/SKILL.md` and build the full interaction map for the app.

Output: table of all interactive elements with effect types.
Report any bugs found (broken promises).

## Step 2: Generate tests

Based on the interaction map:

**Unit tests** (`__tests__/`):
- Every "state without visual" or "side effect" element → `fireEvent.press` → verify store/mock
- Every "visual on current screen" element → `fireEvent.press` → verify state changed (backup for Maestro)

**Maestro flows** (`.maestro/`):

Before writing ANY flow:
1. Fetch Maestro docs via mcpdoc — verify available commands
2. Read `.claude/skills/maestro/SKILL.md` — flow template, tab coordinates, keyboard patterns

Then generate flows from the interaction map:

*Smoke* (tags: smoke): launch → navigate all tabs → no crash
*Functional* (tags: functional): one flow per screen or feature group
*Persistence* (tags: persistence): add data → killApp → relaunch → verify
*Errors* (tags: errors): invalid input → error shown → fix → success

**RULES:**
- Copy the flow template from maestro skill — do NOT improvise structure
- Every `tapOn` → `extendedWaitUntil` (never `waitForAnimationToEnd`)
- Tab navigation → use coordinate table from maestro skill
- Keyboard dismissal → tap a label (never `hideKeyboard`)
- Cross-screen effects → navigate + `takeScreenshot` for Claude visual review

## Step 3: Run tests

```bash
# Unit tests
npx jest --passWithNoTests

# Maestro (all flows via smoke.sh)
../../scripts/smoke.sh .
```

**NEVER run Maestro manually. ALWAYS use smoke.sh.**

If smoke.sh fails → fix the cause (flow, code, or script) → re-run. Max 3 attempts.

## Step 4: Visual review

Read `.claude/skills/visual-review/SKILL.md` and review EVERY screenshot from Step 3.

## Step 5: Report

```
## Test Report: <app-name>

### Interaction Map
| Element | Effect type | Test method | Result |
|---------|------------|-------------|--------|

### Unit Tests
- X passed, Y failed

### Maestro Flows
- X passed, Y failed

### Visual Verification
- Screenshots reviewed: X
- Issues found: <list>

### Verdict: PASS / NEEDS FIXES
```
