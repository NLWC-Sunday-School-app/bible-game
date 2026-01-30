# CI/CD Setup Guide

This guide will help you set up automated builds for Android and iOS using GitHub Actions.

## Prerequisites

1. GitHub repository with the code
2. Android keystore file
3. iOS signing certificates and provisioning profiles

## Android Setup

### 1. Prepare Your Keystore

Convert your keystore to base64:
```bash
base64 -i android/app/keystore.jks | pbcopy
```

### 2. Add GitHub Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions

Add these secrets:
- `KEYSTORE_BASE64`: Paste the base64 string from step 1
- `KEYSTORE_PASSWORD`: Your keystore password
- `KEY_PASSWORD`: Your key password
- `KEY_ALIAS`: Your key alias (usually from key.properties)

### 3. Verify key.properties

Make sure `android/key.properties` is in `.gitignore` (it should NOT be committed)

## iOS Setup

### 1. Export Certificates

Export your iOS distribution certificate (.p12):
1. Open Keychain Access
2. Find your distribution certificate
3. Right-click → Export
4. Save as .p12 with a password

Convert to base64:
```bash
base64 -i YourCertificate.p12 | pbcopy
```

### 2. Export Provisioning Profile

1. Download your provisioning profile from Apple Developer Portal
2. Convert to base64:
```bash
base64 -i YourProfile.mobileprovision | pbcopy
```

### 3. Add GitHub Secrets

Add these secrets:
- `IOS_CERTIFICATE_BASE64`: Certificate base64 from step 1
- `IOS_CERTIFICATE_PASSWORD`: The password you set when exporting
- `IOS_PROVISIONING_PROFILE_BASE64`: Profile base64 from step 2

### 4. Update ExportOptions.plist

Edit `ios/ExportOptions.plist` and replace:
- `YOUR_PROVISIONING_PROFILE_NAME` with your actual profile name

## Usage

### Automatic Builds (Recommended)

Create and push a version tag:
```bash
git tag v1.0.0
git push origin v1.0.0
```

This will trigger both Android and iOS builds automatically.

### Manual Builds

1. Go to GitHub → Actions
2. Select "Android Release Build" or "iOS Release Build"
3. Click "Run workflow"
4. Select branch and click "Run workflow"

## Build Artifacts

After a successful build:
1. Go to Actions tab
2. Click on the workflow run
3. Download artifacts from the "Artifacts" section

## Releases

When you push a version tag, the builds will automatically:
1. Build the app
2. Create a GitHub Release
3. Upload the .aab (Android) or .ipa (iOS) to the release

## Troubleshooting

### Android Build Fails
- Verify keystore secrets are correct
- Check that key.properties format matches the workflow

### iOS Build Fails
- Ensure certificate and provisioning profile are valid
- Verify team ID in ExportOptions.plist matches your Apple Developer account
- Check that provisioning profile name is correct

### PR Checks Fail
- Run `flutter analyze` locally to fix issues
- Run `dart format .` to fix formatting
- Ensure all tests pass with `flutter test`

## Advanced: Deploy to Stores

### Android - Google Play

Add Fastlane or use Google Play Console API:
```yaml
- name: Deploy to Play Store
  uses: r0adkll/upload-google-play@v1
  with:
    serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
    packageName: com.nlwc.bible.game
    releaseFiles: build/app/outputs/bundle/release/app-release.aab
    track: internal
```

### iOS - App Store

Use Fastlane:
```yaml
- name: Deploy to App Store
  run: |
    cd ios
    fastlane release
```

## Security Notes

⚠️ **NEVER commit:**
- `key.properties`
- Keystore files (.jks, .keystore)
- Certificates (.p12)
- Provisioning profiles (.mobileprovision)
- API keys or secrets

✅ **Always:**
- Use GitHub Secrets for sensitive data
- Keep `.gitignore` updated
- Rotate secrets if compromised
