# Maestro Skill

Maestro automates mobile UI on simulators: tap, type, scroll, screenshot. Used for smoke testing, visual verification, and App Store screenshots.

## Setup

- **Dev builds required** — Expo Go doesn't support `launchApp`, `clearState`, or lifecycle control
- Build with `npx expo run:ios` or `eas build --profile development-simulator`
- App's `appId` = `ios.bundleIdentifier` / `android.package` from app.json

## Core Commands

```yaml
- launchApp:
    clearState: true        # Fresh install state
- waitForAnimationToEnd     # ALWAYS use after navigation
- assertVisible: "Text"     # Verify element exists
- tapOn:
    id: "testID-value"      # By testID (most stable)
- tapOn: "Button Text"      # By visible text
- inputText: "hello"        # Type into focused field
- scroll                    # Scroll down
- swipe:
    direction: LEFT
- back                      # Android back / iOS swipe-back
- takeScreenshot: name      # Saves name.png
- hideKeyboard              # Unreliable on iOS — use tapOn point instead
- stopApp                   # Kill app process
```

## Waiting Patterns

```yaml
# After navigation — always
- waitForAnimationToEnd:
    timeout: 5000

# For async data
- extendedWaitUntil:
    visible: "Data loaded"
    timeout: 15000

# For element to disappear (splash screen)
- extendedWaitUntil:
    notVisible:
      id: "splash"
    timeout: 10000
```

## Element Selection

| React Native Prop | Maestro Selector | Stability |
|---|---|---|
| `testID="btn"` | `id: "btn"` | Most stable |
| `accessibilityLabel="Submit"` | `label: "Submit"` | Stable but changes with translations |
| Visible text | `text: "Submit"` or just `"Submit"` | Least stable |

Always use `testID` for elements Maestro will interact with.

## Known Limitations

- **Expo Go**: doesn't work reliably — use dev builds
- **iOS hideKeyboard**: unreliable — use `tapOn: { point: "50%,10%" }` instead
- **@gorhom/bottom-sheet**: renders as single accessibility element, children not interactable — use coordinate taps
- **Android inputText**: can skip characters on debug builds — use release or type slowly
- **takeScreenshot**: captures visible viewport only, not full scroll content
- **Canvas/Skia/Maps**: invisible to Maestro (no accessibility tree)
- **waitForAnimationToEnd on Android**: may not respect timeout parameter with New Architecture

## Smoke Test Patterns

### Crash detection
```yaml
- launchApp:
    clearState: true
- extendedWaitUntil:
    visible: ".*"
    timeout: 15000
- assertNotVisible: "Invariant Violation"
- assertNotVisible: "TypeError"
```

### Data persistence test
```yaml
# Add data
- tapOn: { id: "add-btn" }
- inputText: "Test Item"
- tapOn: { id: "save-btn" }
- assertVisible: "Test Item"
# Kill and relaunch
- stopApp
- launchApp
- extendedWaitUntil:
    visible: "Test Item"
    timeout: 10000
```

## Visual Verification

### assertWithAI (experimental)
```yaml
- assertWithAI:
    assertion: "A home feed with card items and bottom navigation is visible"
    optional: false
```

### Screenshot comparison (v2.2.0+)
```yaml
- assertScreenshot:
    path: "baseline/home"
    threshold: 95
```

## Dark Mode Capture

Maestro has no built-in dark mode toggle. Use shell commands:
```bash
# iOS
xcrun simctl ui booted appearance dark
maestro test flows/capture.yaml
xcrun simctl ui booted appearance light

# Android
adb shell "cmd uimode night yes"
maestro test flows/capture.yaml
adb shell "cmd uimode night no"
```

## CLI for Pipelines

```bash
maestro test \
  --no-ansi \
  --include-tags smoke \
  --test-output-dir ./screenshots \
  --debug-output ./debug \
  --flatten-debug-output \
  --retry-on-failure 2 \
  .maestro/
```

Exit code 0 = all pass, 1 = failure.

## Directory Structure

```
.maestro/
├── config.yaml
├── subflows/              # Not auto-executed
│   ├── login.yaml
│   └── dismiss-onboarding.yaml
├── m1-scaffold-smoke.yaml
├── m2-navigation-smoke.yaml
├── m3-features-smoke.yaml
├── m5-polish-smoke.yaml
└── capture-all-screens.yaml
```
