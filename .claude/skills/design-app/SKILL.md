---
name: design-app
description: Generate a complete design system (DESIGN.md) for an app before building code
disable-model-invocation: true
---

Generate a design system for an app. Read `pipeline/design.md` and follow all steps:

1. Read PRD (§1, §3, §4, §6) — understand app, users, features, visual direction
2. If Stitch MCP available → generate screens via Stitch, extract design system
3. If Stitch unavailable → generate design system from PRD + design rules
4. Write `apps/<slug>/spec/DESIGN.md` with: colors (full palette + dark mode), typography, spacing, corners, elevation, component specs, screen layouts
5. Show summary and ask for user review

DESIGN.md becomes the visual source of truth — all code must follow it.

App: $ARGUMENTS
