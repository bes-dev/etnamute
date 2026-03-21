# Launch Preparation

Generate marketing materials and launch content based on the finalized app. Run after code is complete and before release.

---

## EXECUTION

### Step 1: Read current state

1. `apps/<slug>/spec/prd.md` — features, positioning, target user
2. `apps/<slug>/spec/research.md` — competitors, market data
3. Scan the app code — understand what was actually built (may differ from original PRD after /improve-app iterations)

### Step 2: Generate materials

**Research artifacts** (`apps/<slug>/research/`):
- `market_research.md` — market size, trends, opportunities (refresh from Phase 0b data + current state)
- `competitor_analysis.md` — direct/indirect competitors, strengths/weaknesses
- `positioning.md` — unique value proposition, differentiation

**Marketing artifacts** (`apps/<slug>/marketing/`):
- `launch_thread.md` — Twitter/X thread (10+ posts)
- `landing_copy.md` — landing page headline + body copy
- `press_blurb.md` — press one-pager
- `social_assets.md` — social media descriptions for different platforms

All content must reflect the **actual app** as built, not the original PRD if features changed during /improve-app.

Use WebSearch to validate market claims and competitor data — do not hallucinate.

### Step 3: Review with user

Show summary of generated materials (in user's language). Ask for approval via `AskUserQuestion`:

```
question: "Launch materials ready. Review?"
header: "Launch"
options:
  - label: "Looks good"
    description: "Approve all materials"
  - label: "Need changes"
    description: "Want to adjust tone, messaging, or content"
  - label: "Show full content"
    description: "Display all generated materials for review"
```

---

## RULES

- Content must reflect actual built features, not original PRD
- Use web research for market data — don't make up statistics
- Marketing copy should match the app's language and tone from PRD §6
- Generate in the language appropriate for the target market (from PRD §7)
