# ASO Optimization

Analyze and optimize App Store Optimization artifacts. Can be run independently from code changes.

---

## WHEN TO USE

- After initial build (review generated ASO quality)
- Periodic optimization (every 4-8 weeks post-launch)
- After adding/removing features (ASO must reflect current app)
- Before release (`/release-app`)

---

## EXECUTION

### Step 1: Read current state

1. `apps/<slug>/spec/prd.md` — current features, target user, positioning
2. `apps/<slug>/aso/` — current title, subtitle, description, keywords
3. `apps/<slug>/research/` — competitors, market positioning

### Step 2: Audit

Run platform-specific checks (see `.claude/rules/aso-quality.md`):

**iOS audit:**
- [ ] Title ≤30 chars, contains primary keyword, no filler
- [ ] Subtitle ≤30 chars, no word overlap with title
- [ ] Keywords: all 100 chars used, no duplicates from title/subtitle, singular forms, no stop words, comma-separated without spaces
- [ ] Description: structured for conversion (hook → features → social proof → CTA)

**Google Play audit:**
- [ ] Title ≤30 chars, no ALL CAPS, no emoji
- [ ] Short description ≤80 chars, contains primary keyword, ≥70 chars
- [ ] Long description 2,500-4,000 chars, primary keyword density 2.5-3%, keywords in first/last 180 chars
- [ ] Formatting used (bold, bullet points)

**Cross-platform audit:**
- [ ] iOS and Google Play metadata are different (not identical copies)
- [ ] All features from PRD §4 reflected in descriptions
- [ ] No outdated features mentioned (removed in improve mode)
- [ ] Keywords match actual app functionality

### Step 3: Research (if optimizing keywords)

Search for:
1. Competitor apps in the same category — extract their keywords, titles, descriptions
2. Related search terms users might use
3. Long-tail keywords with lower competition

Use WebSearch — do not hallucinate keyword volume data.

### Step 4: Generate improvements

Show the user a comparison (in their language):

```
## ASO Audit: <app-name>

### iOS
| Field | Current | Proposed | Why |
|-------|---------|----------|-----|
| Title | ... | ... | ... |
| Subtitle | ... | ... | ... |
| Keywords | ...chars used | ...chars used | ... |

### Google Play
| Field | Current | Proposed | Why |
|-------|---------|----------|-----|
| Title | ... | ... | ... |
| Short desc | ... | ... | ... |
| Description | ...density | ...density | ... |

### Issues found
- [list of rule violations]

Apply changes?
```

Ask for approval via `AskUserQuestion`:
```
question: "Apply ASO improvements?"
header: "ASO"
options:
  - label: "Apply all"
    description: "Update all ASO artifacts with proposed changes"
  - label: "Review individually"
    description: "Go through each change one by one"
  - label: "Skip"
    description: "Keep current ASO as is"
```

### Step 5: Apply

1. Update `aso/` files
2. If fastlane metadata exists — sync `fastlane/metadata/` with new ASO
3. Bump version in `app.config.js` (patch)
4. Note: iOS title/subtitle changes require a new build submission. Google Play can update anytime.

### Step 6: Report

```
## ASO Updated

### Changes
- [what changed and why]

### Validation
- iOS keyword field: <X>/100 chars used
- Google Play description: <X> chars, <Y>% primary keyword density
- No rule violations

### Next steps
- iOS: changes take effect after next build submission (1-3 day review)
- Google Play: changes take effect in 4-8 weeks (indexing delay)
- Recommend re-audit in 4-8 weeks
```

---

## PLATFORM-SPECIFIC GENERATION

When generating ASO from scratch (during `/build-app`), generate separate artifacts for each platform:

### For iOS

```
aso/
├── ios/
│   ├── title.txt          # ≤30 chars, primary keyword
│   ├── subtitle.txt       # ≤30 chars, secondary keywords (no overlap with title)
│   ├── keywords.txt       # 100 chars, comma-no-space, deduplicated
│   └── description.txt    # Conversion-focused (NOT indexed for search)
```

### For Google Play

```
aso/
├── android/
│   ├── title.txt           # ≤30 chars, primary keyword
│   ├── short_description.txt  # ≤80 chars, primary keyword
│   └── full_description.txt   # 2,500-4,000 chars, keyword-optimized
```

If the current app has a flat `aso/` structure (legacy), migrate to platform-specific on first optimization.

---

## RULES

- iOS and Google Play are DIFFERENT systems — never copy-paste between them
- iOS keyword field is hidden and not shown to users — optimize purely for search
- iOS description is NOT indexed — optimize purely for conversion
- Google Play description IS indexed — balance keywords and readability
- Do not hallucinate keyword volumes — use WebSearch for competitive data
- Flag apps targeting US without Spanish (Mexico) locale — doubles iOS keyword capacity for free
