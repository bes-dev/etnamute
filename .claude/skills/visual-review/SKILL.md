---
name: visual-review
description: Read screenshots and verify UI against DESIGN.md, reference mockups, and quality checklist
---

Visual verification of app screenshots. Read each image via Read tool and verify against design specs.

## For each screenshot:

1. Read the image file
2. Compare against (in priority order):
   - **Expected state** from interaction map (if available) — "after tapping Dark, background should be dark"
   - **Reference screenshots** from Stitch (`spec/design-screens/`) — layout, spacing, component placement
   - **DESIGN.md** — exact colors, typography, spacing tokens
   - **UI checklist** (`.claude/rules/ui-review.md`) — 27-item quality check

3. Flag issues by severity:
   - **Bug**: wrong state visible (e.g., settings changed but UI didn't update)
   - **Critical**: safe area violations, unreadable text, broken layout
   - **Major**: wrong colors, inconsistent spacing, missing visual hierarchy
   - **Minor**: alignment, divider inconsistencies, polish issues

## What catches bugs that Maestro cannot:

- **Cross-screen state not applied** — settings changed but other screen's UI didn't update visually
- **Wrong theme colors** — dark mode selected but background still light
- **Layout drift from design** — DESIGN.md says 16px padding but screenshot shows 8px
- **Broken animations** — element in wrong position mid-transition

## Output:

```
### Visual Verification
- Screenshots reviewed: X
- Reference screenshots compared: Y (if available)
- Issues found:
  - [severity] description — screenshot name
```
