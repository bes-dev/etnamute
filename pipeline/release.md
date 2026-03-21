# Phase 5: Release

Single command: build, sign, upload, submit for review. Both platforms.

**One-time setup required** (see FIRST-TIME SETUP below). After that, `/release-app` handles everything.

---

## PRE-FLIGHT CHECKS

1. **`.env.deploy` exists** — `test -f apps/<slug>/.env.deploy`. Do NOT read contents.
2. **ASO artifacts exist** — check `apps/<slug>/aso/ios/` and `apps/<slug>/aso/android/` exist. If not → tell user to run `/optimize-aso` first and stop.
3. **Tools installed** — check with `which`: `fastlane`, `xcrun` (iOS), `java` (Android)
4. **App records exist** — ask user: "Have you created the app in App Store Connect and Google Play Console?" If no → show FIRST-TIME SETUP and stop.

If `.env.deploy` missing → generate `.env.deploy.example` and stop.

---

## EXECUTION

### Step 1: Generate fastlane config

Create `apps/<slug>/fastlane/` with:

**Appfile** — from app.config.js + env:
```ruby
for_platform :ios do
  app_identifier(ENV["APP_IDENTIFIER"])
  team_id(ENV["TEAM_ID"])
  itc_team_id(ENV["ITC_TEAM_ID"])
end

for_platform :android do
  json_key_file(ENV["SUPPLY_JSON_KEY"])
  package_name(ENV["ANDROID_PACKAGE_NAME"])
end
```

**Fastfile** — generate the production Fastfile with:

iOS `deploy` lane:
1. Load API key from env (base64-encoded .p8)
2. Query latest build number from App Store Connect, increment
3. Create temporary keychain, import base64 cert + provisioning profile from env
4. Run `cocoapods` for ios/Podfile
5. Build IPA with manual signing via xcargs (don't mutate .xcodeproj)
6. Upload metadata + screenshots + IPA via `deliver`
7. Submit for review with compliance flags pre-answered
8. Cleanup: delete temporary keychain and decoded files

Android `deploy` lane:
1. Decode keystore from base64 env to temp file
2. Read and increment versionCode in build.gradle
3. Build AAB with injected signing properties
4. Upload to Google Play via `supply`
5. Cleanup: delete temp keystore

Combined `deploy_all` lane that runs both sequentially.

**Key Fastfile details:**
- iOS signing: temporary keychain + `xcargs: "CODE_SIGN_STYLE='Manual'"` — never mutate .xcodeproj
- iOS compliance: `submission_information` hash with `export_compliance_uses_encryption: false`
- iOS: always include `release_notes.txt` (required for submit_for_review)
- iOS: set `precheck_include_in_app_purchases: false` when using API keys
- Android: use `changes_not_sent_for_review: true` to avoid common supply error
- Android: AAB format mandatory (not APK)
- Build numbers: auto-increment from store (iOS: `app_store_build_number`, Android: parse build.gradle)
- Error retry: wrap deliver/supply in retry block (3 attempts, 30s delay)

### Step 2: Convert ASO to fastlane metadata

Read `apps/<slug>/aso/` and generate:

**iOS metadata** (`fastlane/metadata/en-US/`):
| Source | Target |
|--------|--------|
| `aso/ios/title.txt` | `name.txt` |
| `aso/ios/subtitle.txt` | `subtitle.txt` |
| `aso/ios/keywords.txt` | `keywords.txt` |
| `aso/ios/description.txt` | `description.txt` |
| privacy policy URL | `privacy_url.txt` |
| version change notes | `release_notes.txt` |

**Android metadata** (`fastlane/metadata/android/en-US/`):
| Source | Target |
|--------|--------|
| `aso/android/title.txt` | `title.txt` |
| `aso/android/short_description.txt` | `short_description.txt` |
| `aso/android/full_description.txt` | `full_description.txt` |
| version change notes | `changelogs/default.txt` |

Also generate: `copyright.txt`, `primary_category.txt` from PRD.

### Step 3: Capture screenshots (if Maestro installed)

Generate `.maestro/screenshots.yaml` from PRD key screens (§6).

Run on correct simulator for required sizes:
- **iOS**: iPhone 16 Pro Max simulator (1320×2868) — mandatory base size
- **Android**: 1080×1920 recommended

```bash
maestro test --test-output-dir ./screenshots/raw .maestro/screenshots.yaml
```

Map output to fastlane directory: `fastlane/screenshots/en-US/<Device>-<Name>.png`

Skip if Maestro not installed — note in output that screenshots need manual capture.

### Step 4: Prebuild native projects

```bash
npx expo prebuild --clean
```

Add `ITSAppUsesNonExemptEncryption = NO` to `ios/<AppName>/Info.plist` if not present (skips encryption compliance question).

### Step 5: Build and submit

Ask user confirmation via `AskUserQuestion`:
```
question: "Ready to build and submit to stores?"
header: "Release"
options:
  - label: "Both platforms"
    description: "Build and submit iOS + Android"
  - label: "iOS only"
    description: "Build and submit to App Store only"
  - label: "Android only"
    description: "Build and submit to Google Play only"
  - label: "Build only (don't submit)"
    description: "Build binaries but don't upload to stores"
```

Then run:
```bash
cd apps/<slug>
bundle exec fastlane deploy_all --env deploy
# or: bundle exec fastlane ios deploy --env deploy
# or: bundle exec fastlane android deploy --env deploy
```

### Step 6: Report

```
## Release Complete

### iOS
- Build number: <N>
- Status: Submitted for review
- Phased release: enabled
- Estimated review: 1-3 days

### Android
- Version code: <N>
- Track: production
- Status: Under review

### Next steps
- Monitor review status in App Store Connect / Play Console
- iOS changes to title/subtitle take effect after review approval
- Google Play metadata changes take 4-8 weeks for full indexing
```

---

## .env.deploy.example

```bash
# ──── iOS ────
APP_IDENTIFIER=com.example.myapp
TEAM_ID=ABCDE12345
ITC_TEAM_ID=18742801
XCODE_SCHEME=MyApp

# App Store Connect API Key
APP_STORE_CONNECT_API_KEY_KEY_ID=
APP_STORE_CONNECT_API_KEY_ISSUER_ID=
APP_STORE_CONNECT_API_KEY_KEY=          # base64-encoded .p8 content
APP_STORE_CONNECT_API_KEY_IS_KEY_CONTENT_BASE64=true

# Code Signing
CERTIFICATE_BASE64=                     # base64-encoded .p12
CERT_PASSWORD=
PROVISIONING_PROFILE_BASE64=            # base64-encoded .mobileprovision
PROVISIONING_PROFILE_NAME=              # profile name as shown in Xcode
KEYCHAIN_PASSWORD=temp_keychain_pass

# ──── Android ────
ANDROID_PACKAGE_NAME=com.example.myapp
SUPPLY_JSON_KEY=fastlane/play-store-key.json

# Signing
ANDROID_KEYSTORE_BASE64=               # base64-encoded .keystore
ANDROID_KEYSTORE_PASSWORD=
ANDROID_KEY_ALIAS=
ANDROID_KEY_PASSWORD=
```

---

## FIRST-TIME SETUP

Show this to the user if they haven't set up before. These steps are manual and done once.

### Apple (≈15 min)

1. Enroll in Apple Developer Program ($99/year) at developer.apple.com
2. Create App Store Connect API Key:
   - App Store Connect → Users → Integrations → App Store Connect API
   - Create Team Key with **App Manager** role
   - Note Key ID + Issuer ID, download .p8 file (one-time download!)
   - Base64 encode: `base64 -i AuthKey_XXXXX.p8`
3. Create app record in App Store Connect (bundle ID, name, SKU)
4. Create Distribution certificate in Developer Portal → export as .p12
   - Base64 encode: `base64 -i Distribution.p12`
5. Create App Store provisioning profile → download
   - Base64 encode: `base64 -i AppStore.mobileprovision`
6. Set App Privacy Details in App Store Connect (cannot be automated)
7. Add all values to `.env.deploy`

### Google Play (≈15 min)

1. Register Google Play Developer account ($25 one-time)
2. Create app in Play Console (All apps → Create app)
3. Complete App Content sections: privacy policy, content rating (IARC), data safety, target audience
4. **Upload first AAB manually** to internal testing track (required — API cannot do first upload)
5. Create Google Cloud service account:
   - Cloud Console → enable "Google Play Android Developer API"
   - IAM → Service Accounts → Create → download JSON key
6. Link service account in Play Console → Users & Permissions → Invite → paste email → Admin permissions
7. Generate upload keystore: `keytool -genkeypair -v -storetype PKCS12 -keystore upload.keystore -alias my-key -keyalg RSA -keysize 2048 -validity 10000`
   - Base64 encode: `base64 -i upload.keystore`
8. Add all values to `.env.deploy`

---

## ERROR HANDLING

| Error | Cause | Fix |
|-------|-------|-----|
| `.env.deploy` missing | Not configured | Generate example, show FIRST-TIME SETUP |
| "No suitable application records" | Wrong bundle ID or team | Check APP_IDENTIFIER and ITC_TEAM_ID |
| "Redundant Binary Upload" | Duplicate build number | Auto-handled by build number auto-increment |
| "Missing attribute 'whatsNew'" | No release notes | Always generate release_notes.txt |
| "Changes cannot be sent for review" (Android) | App in review state | Auto-handled by `changes_not_sent_for_review: true` |
| "applicationNotFound" (Android) | No first manual upload | Tell user to upload first AAB via Play Console |
| Certificate expired | Annual expiration | Tell user to renew in Developer Portal |

---

## WHAT CANNOT BE AUTOMATED

- App record creation in App Store Connect (fastlane `produce` doesn't support API keys)
- First AAB upload to Google Play (API limitation)
- App Privacy Details / Nutrition Labels in ASC
- Content rating questionnaire (IARC) in Play Console
- Data safety form in Play Console
- Certificate/profile renewal (annual, manual in Developer Portal)
