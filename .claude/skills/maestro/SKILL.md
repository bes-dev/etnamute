# Maestro Skill

Maestro automates mobile UI on simulators. Used for smoke testing, visual verification, and screenshots.

**Always fetch Maestro docs via mcpdoc before writing flows** — API evolves between versions.

## Setup

- **Dev builds required** — Expo Go doesn't support `launchApp`, `clearState`, or lifecycle control
- Build with `npx expo run:ios` or `eas build --profile development-simulator`
- App's `appId` = `ios.bundleIdentifier` / `android.package` from app.json

## Expo Router + React Native Gotchas (learned from real usage)

### Tab bar navigation doesn't work by text
Expo Router tab labels render as accessibility elements like `"History, tab, 3 of 4"`. Plain `tapOn: "History"` won't work.

**Solution**: use `maestro hierarchy` to find exact tab bar coordinates, then point-based tapping:
```yaml
- tapOn:
    point: "50%,93%"   # Center of tab bar, adjust per app
```

### accessibilityLabel hides children from Maestro
A Pressable with `accessibilityLabel` groups all children into one element. Inner Text components become invisible to Maestro's text matcher.

**Solution**: assert on `id` (testID) instead of text, or assert on text that lives OUTSIDE the grouped component.

### Reanimated/animated views invisible to Maestro
Text inside scaled or animated Reanimated views may not be found by Maestro — especially at non-1.0 scale.

**Solution**: don't assert on text inside animated views. Use `id` selector on the containing view, or assert on static elements nearby.

### Flows must run sequentially, not in parallel
Multiple flows with `launchApp: clearState: true` fight for the same simulator. Default `maestro test` on a directory may run them in parallel.

**Solution**: run one flow at a time, or use `config.yaml` with `continueOnFailure: false` and explicit `flowsOrder`.

### waitForAnimationToEnd is not a sleep
Returns immediately if no animation is detected. Cannot be used to "wait 8 seconds for a timer".

**Solution**: use `extendedWaitUntil` with a visible condition, or restructure the test.

## Scripts

- `scripts/smoke.sh apps/<slug>` — handles prebuild, simulator boot, Metro, Maestro execution, cleanup
- `scripts/verify.sh apps/<slug>` — unit tests + build + runtime check (no Maestro)

## Writing Flows

Fetch Maestro docs via mcpdoc for current command syntax. Key principles:

- Use `id` selector (testID) over text — most stable
- `waitForAnimationToEnd` after every navigation
- `extendedWaitUntil` for async content — never arbitrary sleeps
- `assertNotVisible: "Invariant Violation"` for crash detection
- Tag all flows: `tags: [smoke]`
- Use `maestro hierarchy` to debug element visibility issues
- Capture debug screenshots: `--debug-output ./debug`

## Directory Structure

```
.maestro/
├── config.yaml
├── m-smoke.yaml        # Full navigation smoke test
├── m-home.yaml         # Home screen details
├── m-history.yaml      # History screen
├── m-settings.yaml     # Settings screen
└── subflows/           # Not auto-executed
```
