---
name: test-app
description: Generate Maestro smoke tests, run them, and review UI quality via screenshots
disable-model-invocation: true
---

Test an app: smoke tests + visual UI review. Requires Maestro + simulator.

**Step 1: Generate .maestro/ flows**

Read PRD §6 (Key Screens) and actual code in `app/` — extract testIDs, screen names, navigation.

Generate `apps/<slug>/.maestro/` flows:
- Tag all flows with `smoke`
- One smoke flow: launch → crash detection → navigate all tabs → take screenshot of each
- Per-screen flows: navigate to screen, assert key content, take screenshot
- Every flow must `takeScreenshot` of each screen it visits
- See `.claude/skills/maestro/SKILL.md` for Expo Router gotchas

**Step 2: Run smoke tests**

```bash
../../scripts/smoke.sh .
```

If fails → read output, fix code, re-run. Max 3 attempts.

**Step 3: Visual UI Review**

After smoke tests pass, review the captured screenshots:

1. Read each screenshot from `apps/<slug>/screenshots/` via Read tool
2. For each screenshot, evaluate against:
   - **PRD §6** — does the screen match the described layout and content?
   - **DESIGN.md** (if exists) — do colors, spacing, typography match the design system?
   - **`.claude/rules/design-consistency.md`** — one focus per screen, no card grids, proper hierarchy, animation budget
3. Report findings per screen:

```
## UI Review: <app-name>

### Home Screen (screenshots/smoke-home.png)
- Layout: ✓ matches PRD — single focus, clear CTA
- Design: ✓ colors match DESIGN.md palette
- Issues: none

### Settings Screen (screenshots/smoke-settings.png)
- Layout: ✓ flat list, no unnecessary cards
- Design: ⚠ spacing between sections too tight
- Issues: recommend increasing section gap

### Overall
- Design consistency: PASS / NEEDS WORK
- PRD compliance: PASS / NEEDS WORK
```

4. If issues found → fix code, re-run smoke.sh to recapture screenshots, re-review. Max 2 iterations.

App: $ARGUMENTS
