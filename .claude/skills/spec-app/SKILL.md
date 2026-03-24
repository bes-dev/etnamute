---
name: spec-app
description: Generate PRD through discovery interview and market research — no code
disable-model-invocation: true
---

Generate a Product Requirements Document for a new app. No code — just the spec.

Output: `apps/<slug>/spec/prd.md` — ready for `/design-app`, `/build-app`, or `/headless`.

App idea: $ARGUMENTS

---

## PHASE 0a: DISCOVERY INTERVIEW

### Purpose

Replace guesswork with user input. Every answer fills a PRD section. Skipped questions get `[DEFAULT]` in the PRD.

### Rules

1. **Detect the user's language** from their initial message — all questions, options, messages MUST be in that language
2. **Read the user's initial idea first** — analyze it before asking anything
3. **Generate questions and options dynamically** based on the specific idea
4. Ask questions **one at a time** using `AskUserQuestion`
5. Maximum 2 questions per call — only when tightly related
6. Wait for the answer before asking the next
7. Adapt follow-up questions based on previous answers
8. Do NOT ask about things the user already specified
9. Do NOT lecture, explain the pipeline, or sell — just ask
10. Total: 5-8 questions (fewer if the initial idea is detailed)

### Before asking: analyze the idea

```
Initial idea → Parse for:
  - App category / domain
  - Core action
  - Target audience (if mentioned)
  - Specific features (if mentioned)
  - Visual references (if mentioned)
  - Monetization preferences (if mentioned)
  - Anti-scope / constraints (if mentioned)
```

**Skip any question already answered by the initial idea.**

### Question sequence

Ask these topics in order. Generate options relevant to the user's specific idea. Skip topics already covered.

**All examples are in English. Generate actual questions in the user's language.**

**Q1: Clarify the Core** (skip if idea is already specific)
> Maps to: PRD §1, §4

Ask only if ambiguous. Generate 3-4 interpretations.

**Q2: Target Audience** (skip if specified)
> Maps to: PRD §3

Generate audience options relevant to the domain.

**Q3: Must-Have Features**
> Maps to: PRD §4

Generate 3-4 feature options specific to the domain. Always `multiSelect: true`.

**Q4: Anti-Scope**
> Maps to: PRD §2

Generate anti-scope options relevant to the domain — things similar apps do that this one won't. `multiSelect: true`.

**Q5: Competitors**
> Maps to: PRD §9, search queries

Ask about user's experience with existing apps.

**Q6: Monetization**
> Maps to: PRD §5. If free → skip Q7.

Options: Free, Freemium, Subscription, One-time purchase.

**Q7: Premium Features** (SKIP if free)
> Maps to: PRD §5 paywall triggers

Generate premium options based on Q3 answers. `multiSelect: true`.

**Q8: Visual Style** (skip if already clear)
> Maps to: PRD §6

Generate style options appropriate for the domain.

**Q9: Language** (ALWAYS)
> Maps to: PRD §7

Options: English, Same as conversation, Multiple languages.

### What NOT to ask

- Platform (always iOS + Android)
- Tech stack (always Expo/TypeScript/Zustand)
- Data storage (default local-only)
- Authentication (default guest-first)

### After domain questions — three setup questions in a row:

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

Save the testing level to `apps/<slug>/spec/testing-level.txt` (one word: `fast`, `standard`, or `full`). This file is read by `/build-app`, `/improve-app`, and `/fix-app` to determine QA behavior.

Then tell user you're starting research (in their language).

### Answer processing

After each answer, map to PRD sections:

| PRD Section | Source | Status |
|---|---|---|
| §1 Overview | initial idea + Q1 | filled / default / needs-research |
| §2 Goals | Q4 | filled / default / needs-research |
| §3 Target User | Q2 | filled / default / needs-research |
| §4 Core Features | Q3 | filled / default / needs-research |
| §5 Monetization | Q6, Q7 | filled / default / needs-research |
| §6 UX Philosophy | Q8 | filled / default / needs-research |
| §7 Tech Constraints | — | always default |
| §8 Quality Bars | — | always default |
| §9 Market Research | Q5 | always needs-research |
| §10 ASO | — | needs-research |

### Defaults

| Aspect | Default |
|---|---|
| Platform | iOS + Android (Expo) |
| Monetization model | Ask user (no default forced) |
| Price | $4.99/month or $29.99/year (if paid) |
| Data storage | Local-only, offline-first (SQLite) |
| Backend | None |
| Authentication | Guest-first (no login) |
| Visual style | Clean, modern, domain-appropriate |
| Language | English |
| Sync | None |

---

## PHASE 0b: WEB RESEARCH (MANDATORY)

Generate search queries from interview answers:
```
"[domain] app [ios/android]" → find competitors
"[competitor name] app reviews" → find pain points
"[competitor name] pricing" → validate pricing
"[audience] [problem] app" → find market size
```

Search for:
1. Competitors in the app's niche
2. Competitor reviews and pain points
3. Pricing benchmarks
4. Market demand signals

Save to `apps/<slug>/spec/research.md` with URLs, dates, key findings.

If WebSearch is unavailable, mark PRD sections as `[UNVALIDATED]`.

---

## PHASE 0c: GENERATE PRD

Write `apps/<slug>/spec/prd.md` following the structure in `pipeline/prd-schema.md`.

Every section must have a source tag:
- `[USER]` — from interview
- `[RESEARCH]` — from web search (with citation)
- `[DEFAULT]` — pipeline default (user skipped)
- `[INFERRED]` — derived from answers

**If user chose Stitch design:**
Follow `/design-app` — it is the source of truth for design generation.

**If user chose "Auto-approve":**
- Show brief one-line confirmation: "PRD saved to spec/prd.md. Starting build."
- Proceed directly. No review dialog.

**If user chose "Review PRD first":**

Show summary (in user's language):

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

Ask for approval via `AskUserQuestion`:
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

If "Need changes" — ask what to change, update PRD, show summary again.
If "Show full PRD" — output full prd.md, then ask again.
If "Start building" — proceed.

---

## RULES

- Use interview answers as primary source, validate with research, mark all sources
- Stay focused: 3-5 features for MVP
- Be specific and implementable
- Do NOT skip the interview or web research
- Do NOT hallucinate market data
- Do NOT proceed without user approval (unless auto-approve was chosen)
