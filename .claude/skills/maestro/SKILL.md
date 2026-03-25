# Maestro Skill

Maestro automates mobile UI on simulators. Used for functional testing, smoke testing, visual verification, and screenshots.

**MANDATORY: Fetch Maestro docs via mcpdoc before writing ANY flow.** Do NOT guess command names — commands like `clearText` don't exist. Use mcpdoc to verify available commands.

## Setup

- **Dev builds required** — Expo Go doesn't support `launchApp`, `clearState`, `killApp`
- **Always use `scripts/smoke.sh`** for running flows — handles build, simulator, Metro, cleanup
- App's `appId` = `ios.bundleIdentifier` / `android.package` from app.config.js

## Flow Template

Every flow MUST follow this structure. Copy and adapt — do NOT improvise from scratch:

```yaml
appId: <bundle-id-from-app.config.js>
tags:
  - <smoke|functional|persistence|errors>
---
- launchApp:
    clearState: true
- extendedWaitUntil:
    visible: "<first screen element>"
    timeout: 15000

# === Your test steps here ===
# After EVERY navigation or state change, use extendedWaitUntil:
- tapOn:
    id: "<testID>"
- extendedWaitUntil:
    visible: "<expected result>"
    timeout: 10000

# At the end, take a screenshot for visual verification:
- takeScreenshot: <descriptive_name>
```

**Rules:**
- NEVER use `waitForAnimationToEnd` as a wait — use `extendedWaitUntil` with a visible condition
- NEVER use `assertVisible` right after navigation — use `extendedWaitUntil` first, then `assertVisible` for secondary checks
- NEVER use commands you haven't verified in docs (e.g., `clearText` doesn't exist — use `eraseText`)

## Core Principle

**Every `tapOn` must be followed by an assertion proving something VISIBLY changed.**

```yaml
# BAD — proves nothing:
- tapOn: "Save"
- takeScreenshot: "after-save"

# GOOD — proves the tap worked:
- tapOn: "Save"
- extendedWaitUntil:
    visible: "Saved successfully"
    timeout: 5000
```

**`takeScreenshot` is documentation, NOT verification.**

## Tab Bar Navigation

Expo Router tab bars require point-based tapping. To find correct coordinates:

```bash
# Run ONCE before writing tab flows:
maestro hierarchy 2>&1 | grep -i "tab\|TabBar\|bottomTabBar"
```

**Calculate tab positions** from the number of tabs:

| Tabs | Tab 1 | Tab 2 | Tab 3 | Tab 4 | Tab 5 |
|------|-------|-------|-------|-------|-------|
| 2    | 25%   | 75%   | —     | —     | —     |
| 3    | 17%   | 50%   | 83%   | —     | —     |
| 4    | 12%   | 37%   | 63%   | 88%   | —     |
| 5    | 10%   | 30%   | 50%   | 70%   | 90%   |

Y-coordinate: **93%** (works for standard iOS tab bar with safe area).

```yaml
# Example: 3-tab app, tap middle tab
- tapOn:
    point: "50%,93%"
- extendedWaitUntil:
    visible:
      id: "<target-screen-testID>"
    timeout: 10000
```

**After tapping a tab, always wait for the target screen's testID** — not text that might appear on multiple screens.

## Keyboard Handling

```yaml
# Preferred: tap a label/header above the keyboard to dismiss
- tapOn: "SECTION LABEL"

# Fallback: tap top of screen
- tapOn:
    point: "50%,5%"

# For decimal/number pad (hideKeyboard often fails):
- tapOn: "NEXT FIELD LABEL"
```

**Do NOT use `hideKeyboard`** — it fails on custom keyboards, decimal pads, and formSheet modals.

## Functional Testing Patterns

### Button → verify effect
```yaml
- tapOn: "Add to Cart"
- extendedWaitUntil:
    visible: "Cart (1)"
    timeout: 5000
```

### Form → dismiss keyboard → submit
```yaml
- tapOn: { id: "input-name" }
- inputText: "Netflix"
- tapOn: "BILLING CYCLE"          # Dismiss keyboard by tapping a label
- tapOn: { id: "input-price" }
- inputText: "15.49"
- tapOn: "CATEGORY"               # Dismiss decimal pad
- scrollUntilVisible:
    element: { id: "btn-submit" }
    direction: DOWN
    timeout: 5000
- tapOn: { id: "btn-submit" }
- extendedWaitUntil:
    visible: "Netflix"
    timeout: 10000
```

### Persistence → kill and relaunch
```yaml
- tapOn: "Save Item"
- extendedWaitUntil:
    visible: "My Item"
    timeout: 5000
- killApp
- launchApp
- extendedWaitUntil:
    visible: "My Item"
    timeout: 15000
```

### Cross-screen settings
```yaml
# Change setting
- tapOn: { id: "btn-currency-eur" }
# Navigate to another screen
- tapOn:
    point: "17%,93%"
- extendedWaitUntil:
    visible: { id: "screen-home" }
    timeout: 10000
# Verify setting applied
- takeScreenshot: currency_cross_screen
```

### Delete → verify removed
```yaml
- tapOn: "Delete"
- extendedWaitUntil:
    visible: "No items yet"
    timeout: 10000
- assertNotVisible: "Item Name"
```

### Error path → fix → success
```yaml
- tapOn: { id: "btn-submit" }
- extendedWaitUntil:
    visible: "Name is required"
    timeout: 5000
- tapOn: { id: "input-name" }
- inputText: "valid name"
- tapOn: { id: "btn-submit" }
- extendedWaitUntil:
    visible: "Success"
    timeout: 10000
```

## Expo Router Gotchas

- **Tab bar**: point-based tapping only (see table above)
- **accessibilityLabel hides children**: assert on `id` (testID), not inner text
- **accessibilityRole="button"**: aggregates child text — add `accessibilityLabel` to the component, or assert on testID
- **Reanimated views**: invisible to Maestro — use `id` or nearby static elements
- **Flows must run sequentially**: use `config.yaml` with `continueOnFailure: false`
- **formSheet modals**: `tapOn: { point: "50%,5%" }` may tap OUTSIDE the modal — tap a label inside the form instead

## Flow Organization

```
.maestro/
├── config.yaml
├── smoke-*.yaml          # Navigation + crash detection
├── func-*.yaml           # Functional flows
├── persist-*.yaml        # killApp → relaunch → verify
└── error-*.yaml          # Error paths
```

Tag flows: `tags: [smoke]`, `tags: [functional]`, `tags: [persistence]`, `tags: [errors]`

## Scripts

- `scripts/smoke.sh apps/<slug>` — dev build + headless simulator + Metro + Maestro + cleanup
- `scripts/smoke.sh apps/<slug> smoke` — run only smoke-tagged flows
- `scripts/verify.sh apps/<slug>` — unit tests + build + runtime (no Maestro)
