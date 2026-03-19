# Phase 5: Release

Build, capture screenshots, and submit to App Store / Google Play. All local, no cloud services.

---

## PRE-FLIGHT CHECKS

Before doing anything, verify:

1. **`.env.deploy` exists** — check with `test -f apps/<app-slug>/.env.deploy`. Do NOT read its contents (credentials).
2. **Tools installed** — check each with `which`:
   - `fastlane`
   - `maestro`
   - `xcrun simctl` (iOS)
   - `java` (Android)
3. **Expo prebuild not stale** — check `ios/` and `android/` exist

If `.env.deploy` is missing, generate `.env.deploy.example` and tell the user to fill it in. Stop and wait.

If a tool is missing, tell the user what to install and stop:
```
brew install fastlane
curl -fsSL "https://get.maestro.mobile.dev" | bash
```

---

## STEP 1: GENERATE FASTLANE CONFIG

Create from app.config.js and PRD:

### `fastlane/Appfile`

```ruby
app_identifier("<bundle-id-from-app-config>")
apple_id(ENV["APPLE_ID"])
team_id(ENV["APPLE_TEAM_ID"])
```

### `fastlane/Fastfile`

```ruby
default_platform(:ios)

platform :ios do
  lane :build do
    match(type: "appstore", readonly: true) if ENV["MATCH_GIT_URL"]
    build_app(
      workspace: "./ios/<AppName>.xcworkspace",
      scheme: "<AppName>",
      export_method: "app-store",
      output_directory: "./build"
    )
  end

  lane :screenshots do
    sh("maestro test --test-output-dir ../screenshots/raw .maestro/screenshots.yaml")
  end

  lane :release do
    build
    deliver(
      force: true,
      skip_screenshots: false,
      metadata_path: "./fastlane/metadata/ios",
      screenshots_path: "./screenshots/raw"
    )
  end
end

platform :android do
  lane :build do
    gradle(task: "bundle", build_type: "Release", project_dir: "./android")
  end

  lane :release do
    build
    supply(
      aab: "./android/app/build/outputs/bundle/release/app-release.aab",
      track: "production",
      metadata_path: "./fastlane/metadata/android"
    )
  end
end
```

Replace `<AppName>` with actual name from app.config.js.

---

## STEP 2: CONVERT ASO → FASTLANE METADATA

### iOS (`fastlane/metadata/ios/en-US/`)

| Source | Target | Transform |
|--------|--------|-----------|
| `aso/app_title.txt` | `name.txt` | Copy as-is |
| `aso/subtitle.txt` | `subtitle.txt` | Copy as-is |
| `aso/description.md` | `description.txt` | Strip markdown |
| `aso/keywords.txt` | `keywords.txt` | Copy as-is |
| privacy policy URL | `privacy_url.txt` | URL only |

### Android (`fastlane/metadata/android/en-US/`)

| Source | Target | Transform |
|--------|--------|-----------|
| `aso/app_title.txt` | `title.txt` | Copy as-is |
| `aso/subtitle.txt` | `short_description.txt` | Copy as-is |
| `aso/description.md` | `full_description.txt` | Strip markdown |

---

## STEP 3: GENERATE MAESTRO SCREENSHOT FLOWS

Create `.maestro/screenshots.yaml` based on the PRD's key screens (§6).

For each screen in the PRD, generate a step that:
1. Navigates to the screen
2. Waits for content to load
3. Takes a screenshot with a descriptive name

### Template

```yaml
appId: <bundle-id>
---
- launchApp:
    clearState: true

# Onboarding
- assertVisible: "<first onboarding element>"
- takeScreenshot: "01-onboarding"

# Home
- tapOn: "<skip/continue button>"
- assertVisible: "<home screen element>"
- takeScreenshot: "02-home"

# Core Feature
- tapOn: "<feature entry point>"
- assertVisible: "<feature screen element>"
- takeScreenshot: "03-feature"

# Settings
- tapOn: "<settings tab or button>"
- assertVisible: "Settings"
- takeScreenshot: "04-settings"
```

### Rules for generating flows

- Use `testID` props from the actual code (read the screens first)
- Use `assertVisible` before every `takeScreenshot` to ensure screen is loaded
- Name screenshots with numeric prefix for ordering: `01-`, `02-`, etc.
- Generate 4-6 screenshots covering: onboarding, home, core feature, detail, settings
- If monetization enabled: include paywall screenshot
- Keep the flow linear — no branching, no error scenarios

---

## STEP 4: GENERATE SUPPORT FILES

### `.env.deploy.example`

```
# Apple
APPLE_ID=
APPLE_TEAM_ID=
MATCH_GIT_URL=
MATCH_PASSWORD=

# Google Play
SUPPLY_JSON_KEY=./google-play-key.json

# Android Keystore
KEYSTORE_PATH=./release.keystore
KEYSTORE_PASSWORD=
KEY_ALIAS=
KEY_PASSWORD=
```

### `DEPLOY.md`

Generate with:

1. Prerequisites checklist (tools + accounts)
2. First-time setup (certificates, keystore, API keys)
3. Screenshot capture commands
4. Build commands (iOS + Android)
5. Submit commands

---

## STEP 5: RUN (Claude executes these)

After generating all config:

```bash
cd apps/<app-slug>

# 1. Prebuild native projects
npx expo prebuild --clean

# 2. Capture screenshots (requires running simulator)
maestro test --test-output-dir ./screenshots/raw .maestro/screenshots.yaml

# 3. Build iOS
fastlane ios build

# 4. Build Android
fastlane android build
```

**Stop before submit.** Ask the user:

```
Билды готовы. Скриншоты сохранены в screenshots/raw/.

Хотите отправить в App Store и Google Play?
- iOS: fastlane ios release
- Android: fastlane android release
```

Only run `release` lanes after explicit user confirmation.

---

## ERROR HANDLING

| Error | Recovery |
|-------|----------|
| `.env.deploy` missing | Generate example, ask user to fill in |
| `fastlane` not installed | Show install command, stop |
| `maestro` not installed | Skip screenshots, continue with build |
| Code signing fails | Check match setup, show `fastlane match appstore` |
| Prebuild fails | Check app.config.js, run `npx expo prebuild --clean` |
| Maestro flow fails | Read error, fix testID/selector, retry flow |
| Build fails | Read Xcode/Gradle error, fix, rebuild |
| Upload fails | Check credentials in .env.deploy |

If maestro is not installed, screenshots are optional — proceed without them and note in DEPLOY.md that user should capture manually.

---

## OUTPUT

After Phase 5, the build directory has:

```
apps/<app-slug>/
├── fastlane/
│   ├── Appfile
│   ├── Fastfile
│   └── metadata/
│       ├── ios/en-US/          # name, subtitle, description, keywords
│       └── android/en-US/      # title, short_description, full_description
├── .maestro/
│   └── screenshots.yaml        # Maestro flow for screenshots
├── screenshots/
│   └── raw/                    # Captured screenshots (PNG)
├── build/                      # Built IPA (iOS)
├── .env.deploy.example
└── DEPLOY.md
```
