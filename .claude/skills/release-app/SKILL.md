---
name: release-app
description: Build, sign, and submit app to App Store and Google Play — fully automated
disable-model-invocation: true
---

Release an app to stores. Read `pipeline/release.md` and follow ALL steps:

1. Pre-flight: check .env.deploy exists (don't read it), check tools, check app records exist
2. Generate fastlane Appfile + Fastfile + metadata from aso/
3. Capture screenshots via Maestro (if installed)
4. Run `npx expo prebuild --clean`
5. Ask user which platforms to submit
6. Run `fastlane deploy_all --env deploy`
7. Report submission status

If first-time setup needed — show setup guide and stop.

App: $ARGUMENTS
