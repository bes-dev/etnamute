---
name: test-app
description: Generate and run Maestro functional tests, smoke tests, and visual UI review
disable-model-invocation: true
---

Test an app like a real QA engineer. Requires Maestro + simulator + dev build.

**Step 1: Build interaction map**

For EVERY interactive element (`onPress`, `onValueChange`, `onSubmit` in the codebase):

1. **Determine what a USER expects** from the element's label, type, and context — NOT from reading the handler code. A button labeled "Dark" in a "Theme" section → user expects the app to turn dark. A toggle labeled "Notifications" → user expects notifications to enable/disable.

2. Read the handler code and trace the effect chain: handler → state change → re-render → UI change

3. **Compare user expectation vs actual effect.** If the UI promises something the code doesn't deliver — that's a bug, not a "design gap". Examples:
   - Theme selector with "Dark" option but app stays light → **BUG** (UI promises dark mode)
   - "Save" button that calls addEntry() but shows no confirmation → **BUG** (user expects feedback)
   - "Send Feedback" button with no handler → **BUG** (button exists but does nothing)
   - Analytics toggle that saves preference but has no visual indicator → **OK** (toggle itself shows on/off state)

4. Classify the effect type:

| Type | Example | How to test |
|------|---------|-------------|
| **Visual on current screen** | "Save" → success message appears | Maestro: tap → `assertVisible` new content |
| **Visual on another screen** | "Set Dark theme" → all screens change background | Maestro: tap → navigate to each affected screen → `takeScreenshot` → Claude reads screenshot and verifies visual change |
| **Navigation** | "View Details" → detail screen opens | Maestro: tap → `assertVisible` destination + `assertNotVisible` source |
| **State without immediate visual** | Store update, preference save | Unit test: `fireEvent.press` → `expect(store.field).toBe(value)` |
| **Side effect without visual** | Analytics event, prefetch, log | Unit test: `expect(mockFn).toHaveBeenCalled()` |
| **Broken promise** | UI shows control but effect not implemented | **Report as BUG**. Do NOT mark as PASS. |

5. For state/visual effects that span multiple screens — list ALL screens that depend on the changed state

**CRITICAL RULE: "stores preference but has no visible effect" is a BUG if the user would expect a visible effect from the control's label and context. Theme selector that doesn't change theme, language selector that doesn't change language, font size slider that doesn't change font size — all bugs. Do NOT classify these as "design gaps" or "not implemented yet".**

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
- For settings that affect OTHER screens: tap setting → navigate to affected screen → `takeScreenshot` with descriptive name like `after-dark-theme-home.png`

*Persistence flows* (tags: persistence):
- Add data → `killApp` → `launchApp` (without clearState) → verify data survived

*Error flows* (tags: errors):
- Submit invalid → verify error → fix → verify success

**Step 3: Run tests**

```bash
# Unit tests
npx jest --passWithNoTests

# Maestro
../../scripts/smoke.sh .
```

If fails → fix code, re-run. Max 3 attempts.

**Step 4: Visual verification (Claude reads screenshots)**

After Maestro flows pass, read EVERY screenshot captured in Step 2 via Read tool.

For each screenshot:
1. Read the image file
2. Compare against:
   - **Expected state** from interaction map ("after tapping Dark, this screen should have dark background")
   - **DESIGN.md** if exists (colors, spacing, typography)
   - **Reference screenshots** if exist (`spec/design-screens/`)
   - **UI checklist** (`.claude/rules/ui-review.md`)
3. If the screenshot shows the WRONG state (e.g., light background after selecting Dark theme) — this is a bug. Report and fix.

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
