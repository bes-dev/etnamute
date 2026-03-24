---
name: test-app
description: Generate and run Maestro functional tests, smoke tests, and visual UI review
disable-model-invocation: true
---

Test an app like a real QA engineer. Requires Maestro + simulator + dev build.

**Step 1: Generate .maestro/ flows**

Read PRD, DESIGN.md (if exists), and actual code in `app/` + `src/`. Generate three types of flows:

**Smoke flows** (tags: smoke):
- Launch → crash detection → navigate all tabs → screenshot each

**Functional flows** (tags: functional):
For EVERY interactive element (buttons, toggles, inputs, selectors):
- **Core rule: every `tapOn` must be followed by an assertion proving something changed**
- Buttons: tap → verify UI updated (not just "button exists")
- Toggles: tap → verify companion text or visual state changed
- Forms: fill → submit → verify success state or navigation
- Selections: tap option → verify selected state + downstream effect
- Settings: change → navigate away → come back → verify persisted
- Delete: add item → delete → verify gone → verify empty state returns

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
