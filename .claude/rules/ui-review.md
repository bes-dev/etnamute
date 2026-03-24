---
paths:
  - "apps/*/screenshots/**"
  - "apps/*/spec/design-screens/**"
---

# UI Screenshot Review Checklist

When reviewing app screenshots, evaluate against this checklist. Ordered by severity.

## Critical (users won't download — any failure = must fix)

- [ ] **Safe areas respected** — content not behind notch, Dynamic Island, or home indicator
- [ ] **No placeholder/default icons** — no Expo Router ▼ triangles, no code bracket icons, no broken image boxes in tab bar or anywhere else
- [ ] **Clear visual hierarchy** — one primary action/content dominates each screen, eyes have a clear scanning path. NOT everything same size/weight/color
- [ ] **No placeholder text** — no "Lorem ipsum", "Tab One", "Hello World", "Title", "Subtitle"
- [ ] **Text contrast sufficient** — body text ~4.5:1 ratio against background, no light gray on white
- [ ] **Body text readable** — at least 16px, not tiny
- [ ] **Touch targets adequate** — buttons/tappables appear at least 44×44pt

## Major (users perceive as low-quality — more than 2-3 = "cheap app")

- [ ] **Color palette cohesive** — max 1 primary accent + neutrals + max 2 semantic colors. NOT purple buttons + green highlights + orange badges + blue links ("AI rainbow")
- [ ] **Tab bar professional** — icons from ONE family, active/inactive states visually distinct, text labels present
- [ ] **Spacing consistent** — follows a rhythm (8px grid), related items grouped tight (8-16px), sections separated generous (24-48px). NOT random gaps
- [ ] **Typography hierarchy** — at least 3 levels visible (heading bold/large, body regular/medium, caption light/small). NOT everything same size
- [ ] **Button hierarchy** — one filled primary CTA, secondary buttons outlined/text-only, consistent radius. NOT all buttons identical
- [ ] **Cards show depth** — distinct from background via shadow, border, or tonal shift. NOT indistinguishable from background
- [ ] **Navigation platform-appropriate** — iOS: large title headers, chevron back. Android: Material app bar. NOT custom web-style headers
- [ ] **Status bar correct** — dark content on light bg, light content on dark bg. NOT invisible text
- [ ] **Empty states designed** — icon + message + CTA button. NOT blank screen or just "No data"
- [ ] **Content density appropriate** — utility: 4-8 elements, feed: 2-4 items visible, settings: 6-10 items. NOT single element in vast whitespace
- [ ] **Icon styles consistent** — all from one family, same stroke weight, same fill style. NOT mixed FontAwesome + Ionicons + Material
- [ ] **Design unified** — same-purpose components look identical across the screen. NOT some cards with shadows, others flat, others with borders

## Minor (designers notice)

- [ ] **Input fields labeled** — persistent label above, not just placeholder text
- [ ] **Alignment consistent** — elements share common edges, no "floating" unanchored elements
- [ ] **List dividers proper** — inset (not full-width on iOS) or replaced by spacing
- [ ] **Bottom sheets/modals styled** — rounded top corners, drag handle, dim scrim
- [ ] **Dark mode correct** (if applicable) — dark gray not pure black, off-white not pure white, elevated surfaces lighter
- [ ] **Toggles/progress themed** — use brand colors, not system defaults
- [ ] **Line height comfortable** — body ~1.5×, headings ~1.2×
- [ ] **iOS polish** (if iOS) — blur behind nav/tab bars, squircle corners

## Quick tells of AI-generated UI

Flag if ANY of these are present:
- More than 3 saturated hues on one screen
- Uniform spacing everywhere (no variance between groups and sections)
- Mixed icon families
- Default Expo/React Native components with no styling
- Purple/indigo gradient (the "AI default palette")
- Inter font + Lucide icons + shadcn-style cards = generic AI output
