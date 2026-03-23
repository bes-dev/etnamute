---
name: build-native
description: Build native binary (IPA/AAB/APK) locally without publishing to stores
disable-model-invocation: true
---

Build a native binary for an existing app. No store submission.

1. Check tools: `xcrun` for iOS, `java` + Android SDK for Android
2. Ask which platform via AskUserQuestion: iOS / Android / Both
3. Run `npx expo prebuild --clean`
4. iOS: build IPA via `xcodebuild` or `fastlane gym`
5. Android: build AAB via `./gradlew bundleRelease` or APK via `./gradlew assembleRelease`
6. Report output paths

Does NOT require .env.deploy, store accounts, or fastlane setup.
For signing: uses development certificates (iOS) or debug keystore (Android) by default.

App: $ARGUMENTS
