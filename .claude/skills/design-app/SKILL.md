---
name: design-app
description: Generate a complete design system (DESIGN.md + reference screenshots) for an app before building code
disable-model-invocation: true
---

Generate a design system with visual references. Run after PRD, before building.

**Output:**
- `apps/<slug>/spec/DESIGN.md` — design tokens and rules (text)
- `apps/<slug>/spec/design-screens/` — reference screenshots of each screen (PNG)

App: $ARGUMENTS

---

## INPUT

Read `apps/<slug>/spec/prd.md`:
- §1 App Name, Category
- §3 Target User (informs visual tone)
- §4 Core Features (what needs to be designed)
- §6 UX Philosophy (design principles, visual style, key screens)

---

## EXECUTION

### Step 1: Generate screens with Stitch (if available)

**If Stitch MCP is available:**

1. `create_project` — create Stitch project with app name and description from PRD
2. Generate screens for each key screen from PRD §6 (use Stitch's text-to-UI)
3. Create directory: `apps/<slug>/spec/design-screens/`
4. For EACH screen (do NOT skip any):
   a. `get_screen_image` → save the returned image as `apps/<slug>/spec/design-screens/<screen-name>.png`
   b. `get_screen_code` → parse HTML/CSS to extract exact design tokens
   **Both calls are MANDATORY for every screen. Saving screenshots is NOT optional.**
5. Extract from CSS:
   - Color values: every hex/rgb from the generated CSS
   - Font family, sizes, weights, letter-spacing
   - Spacing values: padding, margin, gap
   - Border radius values
   - Shadow definitions
   - Component-specific styles (button bg, card bg, nav active color)

**If Stitch is NOT available:**
- Skip to Step 2 — generate design system from PRD + design rules
- No reference screenshots (Claude makes visual decisions during build)

### Step 2: Generate DESIGN.md

Write to `apps/<slug>/spec/DESIGN.md`.

**If Stitch was used:** populate with EXACT values parsed from Stitch CSS — not approximations.
**If no Stitch:** generate values based on PRD §6 + design rules below.

Required structure:

```markdown
# <App Name> — Design System: "<Design Name>"

**Philosophy**: <1-2 sentences>
**Source**: <Google Stitch / Generated from PRD>

---

## Color Palette

| Token | Hex | Usage |
|-------|-----|-------|
| background | #... | Base canvas |
| surface | #... | Card/modal fills |
| surface-container-low | #... | Recessed sections |
| surface-container-high | #... | Elevated surfaces |
| primary | #... | Main actions, headers |
| primary-container | #... | Progress fills, selected states |
| on-surface | #... | Primary text |
| on-surface-variant | #... | Secondary/label text |
| secondary | #... | Secondary actions |
| secondary-container | #... | Accent highlights |
| outline-variant | #... | Ghost borders |
| error | #... | Error states |

### Dark Mode
| Token | Hex |
|-------|-----|
| inverse-surface | #... |
| inverse-on-surface | #... |
| inverse-primary | #... |

### Color Rules
- <specific rules from this design>

---

## Typography

**Font**: <font family>

| Scale | Size | Weight | Usage |
|-------|------|--------|-------|
| display-lg | ...px | ... | Hero numbers, key metrics |
| headline-md | ...px | ... | Section titles |
| body-md | ...px | ... | Body text |
| label-md | ...px | ... | Labels, captions |

---

## Spacing

| Token | Value | Usage |
|-------|-------|-------|
| spacing-xs | ...px | Tight clusters |
| spacing-sm | ...px | List item gaps |
| spacing-md | ...px | Container padding |
| spacing-lg | ...px | Section separation |
| spacing-xl | ...px | Major breaks |

---

## Shapes & Corners

- Buttons: <radius>px
- Cards: <radius>px
- Containers: <radius>px

---

## Elevation & Depth

- <approach and specific values>

---

## Components

### Primary Button
- Background: <hex>
- Text: <hex>
- Corner radius: <value>px
- Height: <value>px

### Cards
- Background: <hex>
- Corner radius: <value>px
- Padding: <value>px

### Bottom Navigation
- Tab count: <N>
- Active: <hex>
- Inactive: <hex>
- Icons: <library and style>

### <App-specific components>
- <detailed specs>

---

## Screens

### <Screen Name>
- Reference: `design-screens/<screen-name>.png`
- Layout: <description>
- Primary CTA: <what, where>
- Key elements: <list>

(One section per screen)

---

## Design Rules

- <rules specific to this design>
```

### Step 3: Design rules (when generating without Stitch)

**Colors:** start from domain mood, generate full surface hierarchy (5-6 variants), tint all neutrals with primary hue, avoid pure black/gray.

**Typography:** one font family, 4 scale levels, consistent weight pairing.

**Spacing:** 5 tokens from 4-8px to 48-64px, generous whitespace between sections.

**Components:** every component has specific hex colors from palette, press/interaction states defined.

**Screens:** layout described as spatial arrangement, primary CTA named, key elements listed.

### Step 4: Review with user

Show screenshots (if Stitch) or summary (if generated). Ask via `AskUserQuestion`:

```
question: "Design system ready. Review?"
header: "Design"
options:
  - label: "Looks good"
    description: "Save and proceed"
  - label: "Adjust colors"
    description: "Want different color direction"
  - label: "Adjust style"
    description: "Want different visual mood"
  - label: "Show full DESIGN.md"
    description: "Read the complete document"
```

---

## REFERENCE SCREENSHOTS

When Stitch generates screens, save each as:
```
apps/<slug>/spec/design-screens/
├── home.png
├── detail.png
├── settings.png
├── history.png
└── onboarding.png
```

These are used by:
- `/build-app` — Claude reads them to understand intended layout while coding
- `/test-app` — compare Maestro screenshots against reference screenshots
- `/improve-app` — verify UX changes still match the design intent

---

## RULES

- Every color must be a specific hex value — no "blue" or "dark"
- Every spacing must be a specific px value — no "generous" or "tight"
- If Stitch was used — values come from actual CSS, not guessed
- DESIGN.md + reference screenshots together are the visual source of truth
- Code must follow DESIGN.md; `/test-app` verifies against reference screenshots
