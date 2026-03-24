# PRD Generation

Generate a comprehensive Product Requirements Document from the discovery interview and web research.

---

## EXECUTION

### Step 1: Discovery Interview

Follow `pipeline/discovery.md`.

Use `AskUserQuestion` for every question. Generate questions and options dynamically based on the app domain.

- Analyze user's initial idea first — skip questions already answered
- 5-8 questions total
**After the last domain question, ask three setup questions in a row (before starting any long work):**

**App name** via `AskUserQuestion`:
```
question: "What should we call the app?"
header: "Name"
options:
  - label: "<your suggested name>"
    description: "Generated based on the app's domain and positioning"
```
User picks or types their own via "Other".

**Stitch design** via `AskUserQuestion`:
```
question: "Generate UI design with Google Stitch before building?"
header: "Design"
options:
  - label: "Yes, generate design"
    description: "Stitch will create screen designs. Code will follow the design closely."
  - label: "No, skip design"
    description: "AI will make UI decisions during build"
```

**Testing level** via `AskUserQuestion`:
```
question: "Testing level?"
header: "QA"
options:
  - label: "Fast"
    description: "Build check + runtime only. You test the app manually."
  - label: "Standard (Recommended)"
    description: "Build check + unit tests for every handler"
  - label: "Full"
    description: "Standard + Maestro UI tests + visual review. Requires simulator + Maestro."
```

**PRD review preference** via `AskUserQuestion`:
```
question: "Review PRD before building, or auto-approve?"
header: "PRD Review"
options:
  - label: "Auto-approve"
    description: "Skip PRD review — go straight from research to building"
  - label: "Review PRD first"
    description: "Show PRD summary for approval before building starts"
```

After these questions — no more user interaction until build is complete (unless user chose "Review PRD first").

Save the testing level choice — it determines QA behavior during build (see `pipeline/build.md`).

Then tell user you're starting research (in their language).

### Step 2: Web Research (MANDATORY)

Search for:
1. Competitors in the app's niche
2. Competitor reviews and pain points
3. Pricing benchmarks
4. Market demand signals

Save to `apps/<slug>/spec/research.md` with URLs, dates, key findings.

If WebSearch is unavailable, mark PRD sections as `[UNVALIDATED]`.

### Step 3: Generate PRD & Get Approval

Write `apps/<slug>/spec/prd.md` using the structure below.

Every section must have a source tag:
- `[USER]` — from interview
- `[RESEARCH]` — from web search (with citation)
- `[DEFAULT]` — pipeline default (user skipped)
- `[INFERRED]` — derived from answers

**Show the user a summary (in the user's language — match the language of their initial request):**

```
## PRD: [App Name]

**Pitch**: [one-line]
**Target user**: [who]
**Core features**: [3-5 bullets]
**Monetization**: [model + price, or "free"]
**Key competitors**: [from research]
**Positioning**: [differentiator]

### Defaults applied (review these):
- [list [DEFAULT] sections]

### Research highlights:
- [key insights]

```

**If user chose Stitch design in Step 1:**
1. Call Stitch MCP to generate screens from PRD §6
2. Extract design tokens into `apps/<slug>/spec/DESIGN.md`
3. If Stitch MCP fails — inform user, continue without design

**If user chose "Auto-approve":**
- Show brief one-line confirmation: "PRD saved to spec/prd.md. Starting build."
- Proceed directly to Phase 1. No review dialog.

**If user chose "Review PRD first":**
- Show PRD summary (as above)
- Ask for approval via `AskUserQuestion`:

```
question: "PRD is ready. Start building?"
header: "PRD"
options:
  - label: "Start building"
    description: "PRD approved, proceed to planning and implementation"
  - label: "Need changes"
    description: "I want to discuss or modify the spec first"
  - label: "Show full PRD"
    description: "I want to read the full document before deciding"
```

If "Need changes" — ask what to change, update PRD, show summary again, ask again.
If "Show full PRD" — output full prd.md, then ask again.
If "Start building" — proceed to Phase 1.

---

## PRD STRUCTURE

```markdown
# App Specification: [App Name]

## 1. Overview
- **App Name**: [max 30 chars] > Source: [USER/INFERRED]
- **One-Line Pitch**: [what + for whom] > Source: [USER/INFERRED]
- **Value Proposition**: [2-3 sentences] > Source: [USER/RESEARCH]
- **App Category**: [App Store category] > Source: [RESEARCH]

## 2. Goals
- **Primary Goals**: [3 goals] > Source: [USER/INFERRED]
- **Non-Goals**: [what this app will NOT do] > Source: [USER]

## 3. Target User
- **Who**: [specific description]
- **Pain Point**: [what frustrates them]
- **Current Solutions**: [what they use now]
- **Context**: [when/where/frequency]
> Source: [USER/RESEARCH]

## 4. Core Features (3-5 for MVP)
For each feature:
- **Purpose**: why it exists
- **User Action**: what the user does
- **System Response**: what the app does
- **Success State**: how user knows it worked
> Source: [USER]

## 5. Monetization
If free: "Free — no monetization. No RevenueCat, no paywall." > Source: [USER]

If paid:
- **Model**: [Freemium/Subscription/One-time] > Source: [USER]
- **Free Tier**: [what's free] > Source: [USER/INFERRED]
- **Premium Tier**: [price + what it unlocks] > Source: [USER/RESEARCH]
- **Paywall Triggers**: [when paywall appears] > Source: [USER/DEFAULT]

## 6. UX Philosophy
- **Design Principles**: [3 principles] > Source: [USER/DEFAULT]
- **Key Screens**: onboarding, home, core action, paywall (if paid), settings
- **Interaction Patterns**: gestures, haptics, feedback

## 7. Technical Constraints
- Platform: Expo (latest stable SDK), Expo Router
- Storage: expo-sqlite + MMKV (or AsyncStorage)
- Secrets: expo-secure-store for tokens
- Monetization: RevenueCat (if enabled)
- Offline: [what works offline]
> Source: [USER/DEFAULT]

## 8. Quality Bars
- UI: premium, domain-specific, consistent
- Performance: <2s load, 60fps, low battery
- Accessibility: WCAG 2.1 AA, VoiceOver/TalkBack, 44pt touch targets

## 9. Market Research
- **Market Overview**: [size, trends, demand] > Source: [RESEARCH]
- **Competitors**: [direct + indirect, strengths/weaknesses/pricing] > Source: [RESEARCH]
- **Positioning**: [UVP, differentiation, niche] > Source: [RESEARCH + USER]

## 10. ASO
- **Title**: [max 30 chars]
- **Subtitle**: [max 30 chars]
- **Description**: [full App Store description]
- **Keywords**: [max 100 chars total]
> Source: [RESEARCH]

## 11. Deliverables Checklist
- [ ] Onboarding flow
- [ ] Home screen with core feature
- [ ] RevenueCat paywall (if monetization enabled)
- [ ] Settings screen
- [ ] App icon + splash screen
- [ ] Privacy policy
- [ ] Note: research/, aso/, marketing/ are generated later via `/market-app`

## 12. Success Criteria
1. Core loop works end-to-end
2. Monetization works (if enabled)
3. All deliverables present
4. Ralph PASS
```

---

## RULES

**DO**: use interview answers as primary source, validate with research, mark all sources, stay focused (3-5 features), be specific and implementable.

**DO NOT**: skip the interview, hallucinate market data, over-scope, proceed without user approval.
