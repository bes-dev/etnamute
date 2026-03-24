---
name: test-app
description: Generate and run Maestro functional tests, smoke tests, and visual UI review
disable-model-invocation: true
---

Test an app like a real QA engineer. Requires Maestro + simulator + dev build.

**Step 1: Build interaction map (BEFORE writing any flows)**

For every interactive element in the codebase (every `onPress`, `onValueChange`, `onSubmit`):
1. Read the handler code — what function does it call?
2. Trace the effect — does it update state? navigate? call API?
3. Determine what VISIBLY changes in UI — trace state → re-render → what appears/disappears/changes?
4. Decide how Maestro can verify that visible change

If a handler changes state but nothing visibly changes in UI — that's a **bug in the app**. Write a test that will FAIL on it.

**Step 2: Generate .maestro/ flows**

Using the interaction map, generate flows. Every flow must test EFFECTS, not just EXISTENCE:

**Smoke flows** (tags: smoke):
- Launch → crash detection → navigate all tabs → screenshot each

**Functional flows** (tags: functional):
For EVERY interactive element (buttons, toggles, inputs, selectors):

**ABSOLUTE RULE: every `tapOn` must be followed by an assertion proving something VISIBLY changed. A `takeScreenshot` is NOT an assertion. If you cannot write an assertVisible/assertNotVisible after a tap, the test is useless.**

- Buttons: tap → `assertVisible` new content or `assertNotVisible` old content
- Toggles: tap → `assertVisible` new state text (e.g., "Dark Mode: On") or `assertWithAI` checking visual change
- Forms: fill → submit → `assertVisible` success message or `assertNotVisible` form screen
- Selections: tap option → `assertVisible` selected indicator or verify downstream content changed
- Settings that affect visuals: change → `assertWithAI "background is now dark"` or verify text/color token changed. Then navigate away → come back → SAME assertion must still pass (persistence check)
- Delete: add → delete → `assertNotVisible` deleted item → `assertVisible` empty state

**Common mistake to AVOID:** tap → takeScreenshot → move on. This proves nothing. The test passes even if the button is broken.

**For every interactive element, ask: "what should visibly change after I tap this?"** Then write an assertion for that change. If nothing visibly changes — the feature is broken and the test should fail.

**For settings/preferences that persist:**
1. Tap the control
2. Assert the new state is reflected in UI (text, visual indicator, or `assertWithAI`)
3. Navigate to a different screen
4. Come back
5. Assert the same state is still shown (persistence)
6. If the setting affects OTHER screens (e.g., visual theme) — navigate there and assert the effect is visible

**Persistence flows** (tags: persistence):
- Add data → `killApp` → `launchApp` (without clearState) → verify data survived

**Error path flows** (tags: errors):
- Submit empty form → verify error message
- Submit invalid data → verify specific error → fix → resubmit → verify success

See `.claude/skills/maestro/SKILL.md` for Expo Router gotchas.

**Step 2: Run tests**

```bash
../../scripts/smoke.sh .
```

If smoke.sh not available, run flows individually:
```bash
maestro test --no-ansi --include-tags smoke .maestro/
maestro test --no-ansi --include-tags functional .maestro/
maestro test --no-ansi --include-tags persistence .maestro/
```

If fails → read output, fix code (not the test unless testID changed), re-run. Max 3 attempts.

**Step 3: Visual UI Review**

After functional tests pass, review captured screenshots against:

1. **Reference screenshots** (if `spec/design-screens/` exists) — side-by-side comparison
2. **UI checklist** (`.claude/rules/ui-review.md`):
   - Critical: safe areas, no placeholder icons, visual hierarchy, no placeholder text
   - Major: color palette cohesive, tab bar professional, spacing consistent, typography hierarchy
   - Minor: input labels, alignment, dark mode correctness
3. Report per screen with severity levels

If critical or major issues → fix, re-run, re-review. Max 2 iterations.

**Step 4: Report**

```
## Test Report: <app-name>

### Functional Tests
- Flows: X passed, Y failed
- Interactive elements tested: <list>
- Persistence: PASS/FAIL
- Error handling: PASS/FAIL

### Visual Review
- Critical: X issues
- Major: X issues
- Minor: X issues

### Verdict: PASS / NEEDS FIXES
```

App: $ARGUMENTS
