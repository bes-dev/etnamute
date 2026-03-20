---
paths:
  - "apps/*/aso/**"
---

# ASO Quality Rules

Triggered when working with ASO artifacts. iOS and Google Play have different algorithms — rules branch by platform.

## iOS: app_title.txt

- Max 30 characters
- Must contain primary keyword (not brand-only)
- No filler words ("best", "the", "your", "amazing", "new")
- No price references ("free", "$0.99")
- No status claims ("#1", "top", "leading")
- Primary keyword should be front-loaded (earlier = more weight)

## iOS: subtitle.txt

- Max 30 characters
- Must contain secondary keywords not present in title (Apple deduplicates)
- No word overlap with title — every word should be unique
- No filler words

## iOS: keywords.txt

- Max 100 characters total
- Comma-separated, NO spaces after commas
- No words that already appear in title or subtitle (Apple deduplicates — repeating wastes space)
- Singular forms only (Apple auto-indexes regular plurals)
- No stop words ("the", "and", "for", "a", "an")
- No words under 3 characters
- No competitor brand names
- No words Apple auto-indexes: "app", "free", "iphone", "ipad", category name, developer name
- All 100 characters should be used — flag unused capacity
- Higher priority keywords placed earlier in the field

## Google Play: app_title.txt

- Max 30 characters
- No ALL CAPS (except acronyms)
- No emoji
- No "free" or "#1"
- Must contain primary keyword

## Google Play: description.md

- 2,500–4,000 characters recommended
- Primary keywords at 2.5–3% density — flag below 2% or above 5%
- Primary keywords must appear in first 180 characters AND last 180 characters
- Secondary keywords at 1–2% density
- Supported formatting: bold, italic, underline, line breaks
- Flag descriptions under 2,000 characters as under-optimized

## Google Play: subtitle.txt (maps to short_description, 80 chars)

- Max 80 characters
- Must contain primary keyword
- No emoji, no special characters, no ALL CAPS
- No call-to-actions ("Download now!", "Try free!")
- Flag if under 70 characters (under-utilized)

## Cross-platform

- Title and description must reflect actual features from PRD §4
- iOS and Google Play metadata should be DIFFERENT — not identical copies
- No year or version numbers in titles
- Screenshots should have benefit-driven text overlays (not just raw UI)
