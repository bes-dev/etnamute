# Design Generation

Generate a comprehensive DESIGN.md — the visual source of truth for code generation. Run after PRD, before building.

---

## INPUT

Read `apps/<slug>/spec/prd.md` — specifically:
- §1 App Name, Category
- §3 Target User (who is this for — informs visual tone)
- §4 Core Features (what needs to be designed)
- §6 UX Philosophy (design principles, visual style, key screens)

---

## EXECUTION

### Step 1: Choose design direction

Based on PRD §6 and the app's domain, define:
- **Design philosophy** — 1-2 sentences capturing the visual mood (e.g., "Atmospheric Serenity", "Kinetic Gallery", "Living Oasis")
- **Visual tone** — calm/energetic, minimal/rich, dark/light, warm/cool

If Stitch MCP is available:
1. Call Stitch to generate screens
2. Extract the design system from Stitch output
3. Enhance with our rules below

If Stitch is NOT available:
1. Generate the design system from PRD + design rules (see below)

### Step 2: Generate DESIGN.md

Write to `apps/<slug>/spec/DESIGN.md` following this structure exactly:

```markdown
# <App Name> — Design System: "<Design Name>"

**Philosophy**: <1-2 sentences — visual mood and inspiration>

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
- <domain-specific rules, e.g., "every neutral is blue-tinted", "no pure black">
- <accent usage rule>

---

## Typography

**Font**: <font family>

| Scale | Size | Usage |
|-------|------|-------|
| display-lg | ... | Hero numbers, key metrics |
| headline-md | ... | Section titles |
| body-md | ... | Body text |
| label-md | ... | Labels, captions |

### Typography Rules
- <e.g., "body text uses on-surface-variant, not black">
- <e.g., "pair display-lg metrics with label-sm units">

---

## Spacing

| Token | Value | Usage |
|-------|-------|-------|
| spacing-xs | ... | Tight clusters (label to value) |
| spacing-sm | ... | List item gaps |
| spacing-md | ... | Container padding |
| spacing-lg | ... | Section separation |
| spacing-xl | ... | Major section breaks |

---

## Shapes & Corners

- Buttons: <radius>
- Cards: <radius>
- Containers: <radius>
- <rules, e.g., "no sharp corners, minimum 0.5rem">

---

## Elevation & Depth

- <approach: tonal layering vs shadows>
- <shadow definition if used>
- <border approach: e.g., "no 1px borders, use color shifts">

---

## Components

### Primary Button
- Background: <color>
- Text: <color>
- Corner radius: <value>
- Press effect: <animation>

### Cards
- Background: <color>
- Corner radius: <value>
- Dividers: <approach>

### Bottom Navigation
- Tab count: <N>
- Active: <color>
- Inactive: <color>

### <App-specific components>
- <e.g., Progress Ring, Breath Circle, Timer Display — with specific colors, sizes, animations>

---

## Screens

### <Screen 1 Name>
- Layout: <description of arrangement>
- Primary CTA: <what, where>
- Key elements: <list>

### <Screen 2 Name>
...

(One section per screen from PRD §6)

---

## Design Rules

- <rule 1 — specific to this design>
- <rule 2>
- <rule 3>
```

### Step 3: Design generation rules (when generating without Stitch)

**Color generation:**
- Start from the app's domain and mood: calming apps get nature tones (greens, blues), productivity gets clean neutrals, fitness gets energetic accents
- Generate a full surface hierarchy (5-6 surface variants for tonal layering)
- One primary accent color, one secondary — never more
- All neutrals should be tinted with the primary hue (no pure grays)
- Avoid pure black (#000000) for text — use tinted near-black
- Dark mode: invert surfaces, lighten primary

**Typography:**
- Choose one font appropriate for the domain (or system default)
- Define 4 scale levels: display, headline, body, label
- Use consistent weight pairing (regular + semibold, not regular + bold + heavy)

**Spacing:**
- Define 5 tokens from tight (4-8px) to generous (48-64px)
- Generous whitespace between sections is mandatory — "airiness"
- Tight clusters bind related data (label + value)

**Components:**
- Every component must have specific colors from the palette — no generic "blue"
- Define press/interaction states
- Every app-specific component (timer ring, progress bar, chart) needs its own spec

**Screens:**
- One section per screen
- Describe layout as spatial arrangement (top → bottom, or zones)
- Name the primary CTA per screen
- List key visible elements

### Step 4: Review with user

Show a summary via `AskUserQuestion`:

```
question: "Design system generated. Review?"
header: "Design"
options:
  - label: "Looks good"
    description: "Save DESIGN.md and proceed"
  - label: "Adjust colors"
    description: "I want different color direction"
  - label: "Adjust style"
    description: "I want a different visual mood"
  - label: "Show full DESIGN.md"
    description: "Let me read the complete document"
```

---

## RULES

- DESIGN.md is the visual source of truth — code MUST follow it
- Every color in DESIGN.md must be a specific hex value — no "blue" or "dark"
- Every component must reference palette tokens — no hardcoded colors
- Must include dark mode variants
- Must include screen-by-screen layout descriptions
- The design must be cohesive — one mood, one accent, one font, consistent corners
- Follow `.claude/rules/design-consistency.md` for structural rules
