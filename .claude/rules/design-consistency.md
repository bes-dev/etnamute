---
paths:
  - "apps/**/*.tsx"
  - "apps/**/*.ts"
---

# Design Consistency Rules

Prevent the "vibe coded" look — inconsistent spacing, mismatched fonts, random colors.

## Stitch / DESIGN.md

- If `apps/<slug>/spec/DESIGN.md` exists — it is the **source of truth** for all visual decisions
- If Stitch MCP is available — use `get_screen_image` to see the intended design before implementing screens
- All colors, spacing, typography, and component styles from DESIGN.md override the generic rules below
- If no DESIGN.md exists — follow the generic rules below

## Spacing

- Define a spacing scale in the theme and use only values from that scale
- Never use arbitrary pixel values — always reference the scale
- Apply the scale consistently to all margins, padding, and gaps

## Typography

- One font family per app, maximum two weights
- Choose a font appropriate for the app's domain (defined in PRD §6)
- Never use display/decorative fonts in the app UI

## Colors

- Define semantic color tokens in the theme:
  - background, surface, border
  - text-primary, text-secondary
  - brand-primary, brand-secondary
  - destructive, success
- Support dark/light mode through token swapping
- Never hardcode color values in component files

## Border Radius

- Pick one radius for the app and use it everywhere
- Cards, buttons, inputs, modals — all the same radius
- Never mix rounded and sharp corners in the same UI

## Shadows / Elevation

- Maximum two shadow levels: one for surfaces, one for overlays
- Shadows indicate elevation hierarchy, not decoration

## Icons

- All icons from one library — pick one for the project, never mix
- Consistent icon sizes per context (define sizes in theme, not per-component)

## Inputs & Buttons

- All inputs the same height within the same context
- All buttons the same height as inputs when placed side-by-side
- Touch targets must meet platform minimums
