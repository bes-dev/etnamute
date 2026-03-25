---
name: test-app
description: Generate and run Maestro functional tests, smoke tests, and visual UI review
disable-model-invocation: true
---

Test an app like a real QA engineer. Requires Maestro + simulator + dev build.

**Step 1: Build interaction map**

For EVERY interactive element (`onPress`, `onValueChange`, `onSubmit` in the codebase):

1. **Determine what a USER expects** from the element's label, type, and context — NOT from reading the handler code. Infer the expected behavior from what the control promises visually.

2. Read the handler code and trace the effect chain: handler → state change → re-render → UI change

3. **Compare user expectation vs actual effect.** If the UI promises something the code doesn't deliver — that's a bug, not a "design gap". The rule: if a control's label implies a visible result, that result must happen. If a control stores a preference but the UI doesn't reflect it — bug.

4. Classify the effect type:

| Type | Example | How to test |
|------|---------|-------------|
| **Visual on current screen** | "Save" → success message appears | Maestro: tap → `assertVisible` new content |
| **Visual on another screen** | Setting that affects other screens' appearance | Maestro: tap → navigate to each affected screen → `takeScreenshot` → Claude reads screenshot and verifies visual change |
| **Navigation** | "View Details" → detail screen opens | Maestro: tap → `assertVisible` destination + `assertNotVisible` source |
| **State without immediate visual** | Store update, preference save | Unit test: `fireEvent.press` → `expect(store.field).toBe(value)` |
| **Side effect without visual** | Analytics event, prefetch, log | Unit test: `expect(mockFn).toHaveBeenCalled()` |
| **Broken promise** | Control's label implies an effect that doesn't happen | **Report as BUG**. Do NOT mark as PASS. |

5. For state/visual effects that span multiple screens — list ALL screens that depend on the changed state

**CRITICAL RULE: "stores preference but has no visible effect" is a BUG if the user would expect a visible effect from the control's label and context. Do NOT classify unimplemented functionality as "design gaps" or "not implemented yet" — if the UI shows the control, the feature must work.**

**Step 2: Generate tests**

**Unit tests** (`__tests__/`):
For every element classified as "state without visual" or "side effect" — write jest test with `fireEvent.press` → verify store/mock.

Also write unit tests for "visual on current screen" elements as backup — `fireEvent.press` → verify state changed (even if Maestro also tests it visually).

**Maestro flows** (`.maestro/`):

*Smoke flows* (tags: smoke):
- Launch → crash detection → navigate all tabs

*Functional flows* (tags: functional):
- For "visual on current screen": tap → `assertVisible`/`assertNotVisible`
- For "navigation": tap → `assertVisible` destination
- For "visual on another screen": tap → navigate to each affected screen → `takeScreenshot: <name>` (Claude will review visually in Step 4)

**RULES:**
- Every `tapOn` must be followed by an assertion or screenshot for Claude review
- `takeScreenshot` alone is NOT verification for current-screen effects — use `assertVisible`
- `takeScreenshot` IS appropriate for cross-screen visual effects — Claude reads the image in Step 4
- For settings that affect OTHER screens: tap setting → navigate to each affected screen → `takeScreenshot` with descriptive name

*Persistence flows* (tags: persistence):
- Add data → `killApp` → `launchApp` (without clearState) → verify data survived

*Error flows* (tags: errors):
- Submit invalid → verify error → fix → verify success

**Step 3: Run tests**

Read `.claude/skills/maestro/SKILL.md` for Maestro setup and Expo Router gotchas.

**Use `smoke.sh` for Maestro** — it handles dev build, headless simulator, Metro, and cleanup:

```bash
# Unit tests
npx jest --passWithNoTests

# Maestro — run ALL flows (no tag filter)
../../scripts/smoke.sh .
```

**NEVER run Maestro, xcodebuild, simctl, or expo run:ios manually. ALWAYS use `smoke.sh`.**

If `smoke.sh` fails:
1. Read the error output
2. Fix the **cause** (broken flow, bad testID, app code bug, or smoke.sh itself)
3. Re-run `../../scripts/smoke.sh .`
4. Max 3 attempts

Do NOT work around `smoke.sh` by running commands manually. If the script itself is broken — fix the script.

**Step 4: Visual verification (Claude reads screenshots)**

After Maestro flows pass, read EVERY screenshot captured in Step 2 via Read tool.

For each screenshot:
1. Read the image file
2. Compare against:
   - **Expected state** from interaction map ("after tapping Dark, this screen should have dark background")
   - **DESIGN.md** if exists (colors, spacing, typography)
   - **Reference screenshots** if exist (`spec/design-screens/`)
   - **UI checklist** (`.claude/rules/ui-review.md`)
3. If the screenshot shows the WRONG state for what was expected — this is a bug. Report and fix.

**This is the step that catches "state changed but UI didn't update" bugs that Maestro assertions cannot detect.**

**Step 5: Report**

```
## Test Report: <app-name>

### Interaction Map
| Element | Effect type | Test method | Result |
|---------|------------|-------------|--------|
| <btn> | visual/current | Maestro assertVisible | PASS |
| <toggle> | visual/cross-screen | screenshot + Claude review | FAIL: UI not updated |
| <input> | state only | unit test fireEvent | PASS |

### Unit Tests
- X passed, Y failed

### Maestro Flows
- X passed, Y failed

### Visual Verification
- Screenshots reviewed: X
- Issues found: <list with severity>

### Verdict: PASS / NEEDS FIXES
```

App: $ARGUMENTS
