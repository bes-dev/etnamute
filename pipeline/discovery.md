# Discovery Interview

You are conducting a step-by-step discovery interview to gather requirements for a mobile app.

---

## PURPOSE

Replace guesswork with user input. Every answer directly fills a section of the PRD (prd.md). Questions the user skips get filled with defaults, marked as `[DEFAULT]` in the PRD.

---

## INTERVIEW RULES

1. **Detect the user's language** from their initial message — all questions, options, and messages MUST be in that language
2. **Read the user's initial idea first** — analyze it before asking anything
3. **Generate questions and options dynamically** based on the specific idea
4. Ask questions **one at a time** using the `AskUserQuestion` tool
5. Maximum 2 questions per call — only when tightly related
6. Wait for the answer before asking the next question
7. Adapt follow-up questions based on previous answers
8. Do NOT ask about things the user already specified in their initial message
9. Do NOT lecture, explain the pipeline, or sell — just ask
10. Total: 5-8 questions (fewer if the initial idea is detailed)
11. After the last question, tell the user you're starting research (in their language)

---

## BEFORE ASKING: ANALYZE THE IDEA

Read the user's initial message and extract what's already known:

```
Initial idea → Parse for:
  - App category / domain (what kind of app)
  - Core action (what the user does)
  - Target audience (if mentioned)
  - Specific features (if mentioned)
  - Visual references (if mentioned)
  - Monetization preferences (if mentioned)
  - Anti-scope / constraints (if mentioned)
```

**Skip any question that the initial idea already answers.** If the user said "I want a free habit tracker for students with dark theme" — you already know: category (tracker), audience (students), monetization (free), visual style (dark). Don't ask about these again.

---

## QUESTION SEQUENCE

Ask these topics in order. For each one, **generate options relevant to the user's specific idea**. Skip topics already covered by the initial message.

**All examples below are in English. Generate actual questions in the user's language.**

### Q1: Clarify the Core (if the idea is vague)

> Maps to: PRD §1 Overview, §4 Core Features

Ask only if the initial idea is ambiguous or could mean different things. Generate 3-4 interpretations specific to their idea.

**Example for "app for runners":**
```
question: "What kind of running app do you have in mind?"
header: "Core"
options:
  - label: "Run tracker"
    description: "GPS tracking of route, pace, distance in real time"
  - label: "Training plans"
    description: "Pre-built programs for 5K, 10K, marathon prep"
  - label: "Running log"
    description: "Manual entry of workouts, notes, progress tracking"
  - label: "Social running"
    description: "Find partners, group runs, challenges"
```

**Do NOT ask this if the idea is already specific** (e.g., "GPS tracker for runs with pace alerts").

### Q2: Target Audience (if not specified)

> Maps to: PRD §3 Target User

Generate audience options relevant to the app's domain.

**Example for a cooking app:**
```
question: "Who is this app for?"
header: "Audience"
options:
  - label: "Beginner cooks"
    description: "Simple recipes, step-by-step instructions, basic techniques"
  - label: "Home chefs"
    description: "Complex recipes, experimentation, meal planning"
  - label: "Diet-conscious"
    description: "Calorie counting, allergen filters, healthy recipes"
  - label: "Busy people"
    description: "Quick recipes under 30 min, minimal ingredients"
```

### Q3: Must-Have Features

> Maps to: PRD §4 Core Features

Generate 3-4 feature options **specific to the app's domain**. Always use `multiSelect: true`.

**Example for a meditation app:**
```
question: "Which features are must-have for v1?"
header: "Features"
multiSelect: true
options:
  - label: "Meditation timer"
    description: "Customizable timer with ambient sounds and intervals"
  - label: "Guided sessions"
    description: "Library of meditations by duration and theme"
  - label: "Habit tracker"
    description: "Streak, calendar, practice regularity stats"
  - label: "Breathing exercises"
    description: "Visual guide for breathing techniques (4-7-8, box, etc.)"
```

### Q4: Anti-Scope

> Maps to: PRD §2 Non-Goals

Generate anti-scope options **relevant to the domain** — things that users of similar apps might expect but this app won't do.

**Example for a finance tracker:**
```
question: "What should this app NOT do?"
header: "Anti-scope"
multiSelect: true
options:
  - label: "No bank connections"
    description: "Manual entry only, no bank APIs or aggregators"
  - label: "No investments"
    description: "Expenses/income only, no portfolios or stocks"
  - label: "No family sharing"
    description: "Personal budget only, no shared accounts"
  - label: "No tax calculations"
    description: "No tax filing or accounting features"
```

### Q5: Competitors

> Maps to: PRD §9 Market Research, Phase 0b search queries

Ask about user's experience with existing apps in the same domain.

```
question: "Have you tried similar apps? What didn't work?"
header: "Competitors"
options:
  - label: "Haven't tried any"
    description: "No experience with alternatives"
  - label: "Too expensive"
    description: "Alternatives exist but overpriced"
  - label: "Too complex"
    description: "Alternatives exist but bloated with features"
  - label: "Outdated"
    description: "Alternatives exist but UI/UX feels old"
```

The user should name specific apps in "Other" — this feeds Phase 0b search queries.

### Q6: Monetization

> Maps to: PRD §5 Monetization
> If user chooses free — skip Q7

```
question: "Free or paid app?"
header: "Monetization"
options:
  - label: "Free"
    description: "Completely free, no subscriptions or purchases"
  - label: "Freemium"
    description: "Basic features free, advanced behind subscription"
  - label: "Subscription"
    description: "Everything behind subscription"
  - label: "One-time purchase"
    description: "Single payment, no subscription"
```

### Q7: Premium Features (SKIP if free)

> Maps to: PRD §5 Monetization — paywall triggers

Generate premium feature options **based on the features from Q3**. Always use `multiSelect: true`.

**Example for a meditation app (based on Q3 answers):**
```
question: "What exactly should be behind the paywall?"
header: "Paywall"
multiSelect: true
options:
  - label: "Premium sessions"
    description: "Extended library of meditations and courses"
  - label: "Advanced stats"
    description: "Detailed charts, trends, data export"
  - label: "Customization"
    description: "Custom sounds, themes, timer settings"
  - label: "Remove limits"
    description: "Unlimited saved sessions"
```

### Q8: Visual Style (CONDITIONAL — skip if already clear)

> Maps to: PRD §6 UX Philosophy

Generate style options **appropriate for the app's domain**.

**Example for a finance app:**
```
question: "What visual style do you prefer?"
header: "Design"
options:
  - label: "Dark and professional"
    description: "Like Bloomberg or Revolut — dark tones, sharp charts"
  - label: "Minimalist"
    description: "Like Mint — light, clean, lots of whitespace"
  - label: "Friendly"
    description: "Like YNAB — bright accents, approachable tone"
```

### Q9: Language (ALWAYS)

> Maps to: PRD §7 Technical Constraints — localization

```
question: "What language should the app UI be in?"
header: "Language"
options:
  - label: "English"
    description: "English only"
  - label: "Same as this conversation"
    description: "Use the language you're writing in right now"
  - label: "Multiple languages"
    description: "Several languages with in-app switching"
```

If "Multiple languages" — ask which languages in a follow-up.

---

## WHAT NOT TO ASK

- **Platform** — always iOS + Android (Expo), don't ask
- **Tech stack** — always Expo/TypeScript/Zustand, don't ask
- **Data storage** — default local-only, ask only if user mentioned sync/cloud
- **Priority** — ask only if scope from Q3 is clearly too ambitious for MVP
- **Authentication** — default guest-first, ask only if user mentioned accounts/login

---

## ANSWER PROCESSING

After each answer, internally map it to PRD sections:

```
User answer → PRD section → Filled / Default / Needs research
```

Track which PRD sections are covered:

| PRD Section         | Source        | Status                            |
| ------------------- | ------------- | --------------------------------- |
| §1 Overview         | initial idea + Q1 | filled / default / needs-research |
| §2 Goals            | Q4            | filled / default / needs-research |
| §3 Target User      | Q2            | filled / default / needs-research |
| §4 Core Features    | Q3            | filled / default / needs-research |
| §5 Monetization     | Q6, Q7        | filled / default / needs-research |
| §6 UX Philosophy    | Q8            | filled / default / needs-research |
| §7 Tech Constraints | —             | always default                    |
| §8 Quality Bars     | —             | always default                    |
| §9 Market Research  | Q5            | always needs-research             |
| §10 ASO             | —             | needs-research                    |

---

## RESEARCH QUERIES GENERATION

After interview, generate search queries based on answers:

```
From the app domain: "[domain] app [ios/android]" → find competitors
From Q5 (competitors): "[competitor name] app reviews" → find pain points
From Q5 (competitors): "[competitor name] pricing" → validate pricing
From Q2 (audience): "[audience] [problem] app" → find market size
```

---

## DEFAULTS TABLE

When user skips a question or it's not asked, use these defaults and mark as `[DEFAULT]` in PRD:

| Aspect             | Default Value                        |
| ------------------ | ------------------------------------ |
| Platform           | iOS + Android (Expo)                 |
| Monetization model | Ask user (no default forced)         |
| Price              | $4.99/month or $29.99/year (if paid) |
| Data storage       | Local-only, offline-first (SQLite)   |
| Backend            | None                                 |
| Authentication     | Guest-first (no login)               |
| Visual style       | Clean, modern, domain-appropriate    |
| Language           | English                              |
| Sync               | None                                 |
