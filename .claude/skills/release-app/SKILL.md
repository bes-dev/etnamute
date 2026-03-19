---
name: release-app
description: Prepare an app for App Store submission with fastlane and screenshots
disable-model-invocation: true
---

Prepare an app for release. Read `pipeline/release.md` and follow the steps:

1. Pre-flight checks (`.env.deploy` exists, tools installed)
2. Generate fastlane config + metadata from `aso/`
3. Generate Maestro screenshot flows from PRD key screens
4. Run `npx expo prebuild --clean`
5. Capture screenshots via `maestro test`
6. Build with `fastlane ios build` and `fastlane android build`
7. Ask user confirmation before submitting to stores

App: $ARGUMENTS
