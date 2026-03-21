# Market Preparation

Generate all marketing and store materials for a finalized app: ASO metadata (platform-specific), market research, and launch content. Run after code is complete, before `/release-app`.

---

## EXECUTION

### Step 1: Read current state

1. `apps/<slug>/spec/prd.md` — features, positioning, target user
2. `apps/<slug>/spec/research.md` — initial market research from Phase 0b
3. Scan the app code — understand what was actually built (may differ from original PRD after iterations)

### Step 2: Web research

Refresh and deepen the initial Phase 0b research:

1. Search for current competitors — may have changed since initial build
2. Competitor ASO: extract their titles, descriptions, keywords
3. Keyword opportunities: long-tail terms with lower competition
4. Market positioning validation

Save updated findings to `apps/<slug>/research/`:
- `market_research.md` — market size, trends, opportunities
- `competitor_analysis.md` — direct/indirect competitors, strengths/weaknesses
- `positioning.md` — unique value proposition, differentiation

Use WebSearch — do not hallucinate market data.

### Step 3: Generate ASO (platform-specific)

iOS and Google Play are different systems — generate separate metadata.

**iOS** (`apps/<slug>/aso/ios/`):
- `title.txt` — ≤30 chars, primary keyword
- `subtitle.txt` — ≤30 chars, no word overlap with title
- `keywords.txt` — 100 chars, comma-no-space, deduplicated from title+subtitle, singular forms
- `description.txt` — conversion-focused (NOT indexed for search on iOS)

**Android** (`apps/<slug>/aso/android/`):
- `title.txt` — ≤30 chars, primary keyword
- `short_description.txt` — ≤80 chars, contains primary keyword
- `full_description.txt` — 2,500-4,000 chars, primary keyword density 2.5-3%, keywords in first/last 180 chars

See `.claude/rules/aso-quality.md` for full validation rules.

### Step 4: Generate marketing content

**Marketing artifacts** (`apps/<slug>/marketing/`):
- `launch_thread.md` — Twitter/X thread (10+ posts)
- `landing_copy.md` — landing page headline + body copy
- `press_blurb.md` — press one-pager
- `social_assets.md` — social media descriptions for different platforms

All content must reflect the **actual app** as built, not the original PRD if features changed.

### Step 5: Review with user

Show summary (in user's language):

```
## Market Prep: <app-name>

### ASO (iOS)
- Title: <title> (<N>/30 chars)
- Subtitle: <subtitle> (<N>/30 chars)
- Keywords: <N>/100 chars used, <N> unique tokens

### ASO (Android)
- Title: <title> (<N>/30 chars)
- Short desc: <N>/80 chars
- Description: <N> chars, <X>% primary keyword density

### Research
- <key market insights>
- <top competitors>

### Marketing
- Launch thread: <N> posts
- Landing copy: ready
- Press blurb: ready

Apply all?
```

Ask via `AskUserQuestion`:
```
question: "Market materials ready. Apply?"
header: "Market"
options:
  - label: "Apply all"
    description: "Save all research, ASO, and marketing artifacts"
  - label: "Need changes"
    description: "Want to adjust something first"
  - label: "Show details"
    description: "Display all generated content for review"
```

---

## RULES

- iOS and Google Play ASO must be DIFFERENT — never copy-paste between platforms
- Content must reflect actual built features, not original PRD
- Use web research for market data — don't hallucinate
- Generate in the language appropriate for the target market (from PRD §7)
- Flag US-targeted iOS apps without Spanish (Mexico) locale — doubles keyword capacity for free
