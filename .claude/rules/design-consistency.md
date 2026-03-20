---
paths:
  - "apps/**/*.tsx"
  - "apps/**/*.ts"
---

# Design Consistency Rules

These rules prevent the "vibe coded" look — inconsistent spacing, mismatched fonts, random colors.

## Spacing

- Use a 4px base unit scale: 4, 8, 12, 16, 24, 32, 48, 64
- Never use arbitrary values (13px, 22px, 15px)
- Apply the scale consistently to all margins, padding, and gaps
- If using NativeWind/Tailwind — use the default spacing scale, don't override with arbitrary values

## Typography

- One font family per app, maximum two weights (regular + bold or medium + semibold)
- Font choice by domain:
  - Productivity/utility: Inter or system font
  - Consumer/lifestyle: Plus Jakarta Sans or DM Sans
  - Finance/professional: system font with tighter letter spacing
- Never use display/decorative fonts in the app UI — only in marketing materials

## Colors

- Define semantic color tokens in theme, not individual hex values:
  - background, surface, border
  - text-primary, text-secondary
  - brand-primary, brand-secondary
  - destructive, success
- Support dark/light mode through token swapping — never conditionals in components
- Never hardcode hex/rgb values in component files

## Border Radius

- Pick one radius for the app and use it everywhere (typically 8, 12, or 16)
- Cards, buttons, inputs, modals — all the same radius
- Never mix rounded and sharp corners in the same UI

## Shadows / Elevation

- Maximum two shadow levels: one for cards/surfaces, one for modals/overlays
- Shadows indicate elevation hierarchy, not decoration
- On Android, use `elevation` property consistently

## Icons

- All icons from one library (Lucide, Phosphor, SF Symbols via expo-symbols — pick one)
- Never mix icons from different sets in the same app
- Consistent icon size per context (e.g. 20 for inline, 24 for navigation, 32 for empty states)

## Inputs & Buttons

- All inputs the same height in the same context (typically 44-48pt)
- All buttons the same height as inputs when side-by-side
- Touch targets ≥44pt on iOS, ≥48dp on Android
