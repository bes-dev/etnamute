---
paths:
  - "apps/**/*.tsx"
  - "apps/**/*.ts"
---

# Design Consistency Rules

Generate UI that looks designed, not "vibe coded."

## Stitch / DESIGN.md

- If `apps/<slug>/spec/DESIGN.md` exists — it is the **source of truth** for all visual decisions
- Reproduce the design as closely as possible: exact colors, spacing, typography, layout, component styles
- If Stitch MCP is available — use `get_screen_image` to see the intended design and match it precisely
- All visual decisions from DESIGN.md override the generic rules below
- If no DESIGN.md exists — follow the generic rules below

---

## Screen Composition

### One focus per screen
- Each screen has ONE primary action — not a dashboard of options
- Ask: "what should the user do on this screen?" — that action dominates the layout
- Secondary actions are visually subdued or in menus

### Screen budget discipline
- **Home/hero screen**: app identity + headline + one primary CTA + supporting content. Nothing else above the fold.
- **Detail screen**: content + one primary action. No competing CTAs.
- **Settings screen**: flat list of options. No cards, no hero, no decorative elements.

### No cards by default
- Cards require justification — they imply independent, interactable content units
- Flat lists, sections with dividers, or grouped content are often better for mobile
- If content is read-only or navigational — use a list row, not a card
- Never build a screen as "stacked cards" — that's a web anti-pattern

### Screen narrative flow
Order content as a story, not a random arrangement:
1. **Identify** — what is this screen? (header/title)
2. **Orient** — where am I, what's the status? (key metric, current state)
3. **Act** — what can I do? (primary action, content)
4. **Navigate** — where else can I go? (tabs, secondary actions)

---

## Content

### Real content, never placeholders
- Use actual app-relevant text from PRD, not "Lorem ipsum" or "Sample Item 1"
- Empty states must have: icon + message + CTA ("No entries yet. Tap + to add your first.")
- Loading states must be skeletons, not spinners with "Loading..."
- Error states must have: icon + message + retry button

### Text hierarchy
- One dominant text element per screen (screen title or key metric)
- Supporting text is visually subdued (secondary color, smaller size)
- Maximum 3 levels of text hierarchy per screen (title, body, caption)

---

## Spacing

- Define a spacing scale in the theme and use only values from that scale
- Never use arbitrary pixel values — always reference the scale
- **Spacing must vary** — tight for related items (8-16px), generous between sections (24-48px). NOT uniform padding everywhere
- Internal padding ≤ external margin — components must not bleed together
- Screen-edge margins: minimum 16px
- Content must never sit in the home indicator zone (bottom 34pt on iPhone)

## Typography

- One font family per app, maximum two weights
- Choose a font appropriate for the app's domain (defined in PRD §6)
- Never use display/decorative fonts in the app UI
- Headlines readable in one glance — 2-3 words max for key metrics, one line for titles

## Colors

- Define semantic color tokens in the theme:
  - background, surface, border
  - text-primary, text-secondary
  - brand-primary, brand-secondary
  - destructive, success
- **60-30-10 rule**: 60% background/neutrals, 30% secondary surfaces, 10% accent color
- **One accent color** — used for primary CTA, active tab, key highlights. Nowhere else.
- **Max 3 saturated hues** on any screen — more = "AI rainbow" palette
- Semantic colors follow convention: red=error, green=success, yellow=warning
- Support dark/light mode through token swapping
- Dark mode: dark gray (#121212-#1E1E1E) not pure black, off-white not pure white
- Never hardcode color values in component files
- NO purple/indigo gradients as default — this is the #1 tell of AI-generated UI

## Border Radius

- Pick one radius for the app and use it everywhere
- Cards, buttons, inputs, modals — all the same radius
- Never mix rounded and sharp corners in the same UI

## Shadows / Elevation

- Maximum two shadow levels: one for surfaces, one for overlays
- Shadows indicate elevation hierarchy, not decoration
- If in doubt — no shadow. Flat is better than gratuitous depth.

## Icons

- All icons from one library — pick one for the project, never mix
- Consistent icon sizes per context (define sizes in theme, not per-component)

## Inputs & Buttons

- All inputs the same height within the same context (minimum 48px)
- Persistent labels above inputs — NOT placeholder text as only label
- All buttons the same height as inputs when placed side-by-side
- Horizontal padding at least 2× vertical padding on buttons
- Touch targets must meet platform minimums
- Primary button: filled with accent color. One per screen.
- Secondary buttons: outlined or text-only. Visually subordinate.
- NEVER use default React Native `<Button>` — always custom styled

## Tab Bar

- Icons from ONE icon library — never mix families
- Active state: filled or brand color. Inactive: outline or gray.
- Text labels below icons
- NEVER use default Expo Router icons (▼ triangles, code brackets)

---

## Animation

### Budget: maximum 3 intentional animations per screen
1. One entrance animation (screen transition, content fade-in)
2. One feedback animation (button press, toggle, success state)
3. One state change animation (progress update, data refresh)

### Rules
- Animations must be fast (<300ms for feedback, <500ms for transitions)
- Remove any animation that is purely decorative and adds no information
- Respect `prefers-reduced-motion` — disable all non-essential animation
- Use `react-native-reanimated` for smooth 60fps — never JS-driven `Animated`

---

## Anti-patterns to reject

- Dashboard-style home screen with multiple card grids (pick one focus)
- Screens with 3+ equally prominent CTAs (pick one primary)
- Decorative illustrations that don't aid understanding
- Carousel/swiper without clear purpose (usually hides content)
- Identical visual weight on all elements (no hierarchy = no design)
- Gradient backgrounds used for "vibes" not function
- Badge/pill labels floating over content without clear association
- Purple/indigo as default brand color (the "AI purple problem")
- Inter + Lucide + shadcn-style cards = generic AI output. Choose a distinctive palette.
- Uniform mechanical spacing everywhere — vary spacing to create hierarchy
- Mixed icon families on the same screen
- Default unstyled system components (toggles, buttons, inputs)
