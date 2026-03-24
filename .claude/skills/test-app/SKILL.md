---
name: test-app
description: Generate Maestro smoke tests, run them, and review UI quality via screenshots
disable-model-invocation: true
---

Test an app: smoke tests + visual UI review. Requires Maestro + simulator.

**Step 1: Generate .maestro/ flows**

Read PRD §6 and actual code — extract testIDs, screen names, navigation.

Generate flows that `takeScreenshot` of every screen. See `.claude/skills/maestro/SKILL.md` for gotchas.

**Step 2: Run smoke tests**

```bash
../../scripts/smoke.sh .
```

If fails → read output, fix code, re-run. Max 3 attempts.

**Step 3: Visual UI Review**

After smoke tests pass, review captured screenshots:

1. Read each screenshot from `apps/<slug>/screenshots/`

2. **If reference screenshots exist** (`apps/<slug>/spec/design-screens/`):
   - Read both the Maestro screenshot AND the matching reference screenshot
   - Compare side-by-side: does the implemented screen match the Stitch design?
   - Check: same colors, same layout structure, same component styles, same spacing proportions

3. **Evaluate each screenshot against this checklist:**

   **Critical (users won't download):**
   - [ ] No placeholder/default icons (Expo ▼ triangles, missing images, broken assets)
   - [ ] No raw/unstyled system components (default toggles, unstyled inputs)
   - [ ] No broken layout (overlapping elements, content cut off, elements off-screen)
   - [ ] No error screens or red boxes visible
   - [ ] Tab bar has real icons, not placeholders

   **Major (users notice):**
   - [ ] Colors match DESIGN.md palette (not random/default colors)
   - [ ] Typography consistent — one font, proper hierarchy (title > body > caption)
   - [ ] Spacing even and consistent — not cramped, not excessively empty
   - [ ] One clear primary action per screen — not competing CTAs
   - [ ] Empty states have icon + message + CTA (not just blank space or plain text)
   - [ ] Status bar style matches app theme (dark text on light bg, light text on dark bg)

   **Minor (designers notice):**
   - [ ] Border radius consistent across all components
   - [ ] Shadow/elevation consistent
   - [ ] Active/selected states visually distinct from inactive
   - [ ] Text doesn't overflow or truncate unexpectedly

4. **Report per screen:**

```
## UI Review: <app-name>

### <Screen Name> (screenshot.png vs design-screens/screen.png)
- Reference match: ✓ close / ⚠ deviates / ✗ doesn't match
- Critical issues: <list or "none">
- Major issues: <list or "none">
- Minor issues: <list or "none">

### Overall
- Critical: X issues
- Major: X issues
- Minor: X issues
- Verdict: PASS / NEEDS FIXES
```

5. If critical or major issues found → fix code, re-run smoke.sh, re-review. Max 2 iterations.

App: $ARGUMENTS
