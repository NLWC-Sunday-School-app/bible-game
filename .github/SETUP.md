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

## Automated Deployment to Stores

Both Android and iOS workflows now include **automatic deployment** when you push version tags.

### Android - Google Play Store

**Status**: ✅ Enabled and configured

The workflow automatically deploys to Google Play's **internal testing track** after a successful build.

**Required Secrets** (already configured):
- `PLAY_STORE_SERVICE_ACCOUNT_JSON`: Service account JSON from Google Play Console

**How it works**:
1. Push a version tag: `git tag v2.2.14 && git push origin v2.2.14`
2. Workflow builds the AAB with auto-incremented version code
3. Automatically uploads to Play Store internal track
4. Build appears in Google Play Console → Internal testing

### iOS - TestFlight

**Status**: ⚠️ Requires setup (see below)

The workflow automatically deploys to TestFlight after a successful build.

**Required Secrets** (need to be added):
- `APP_STORE_CONNECT_ISSUER_ID`: From App Store Connect → Users and Access → Integrations
- `APP_STORE_CONNECT_KEY_ID`: API Key ID from App Store Connect
- `APP_STORE_CONNECT_KEY_BASE64`: Base64-encoded .p8 API key file

**Setup Instructions**:

1. **Create App Store Connect API Key**:
   - Go to [App Store Connect](https://appstoreconnect.apple.com)
   - Navigate to **Users and Access** → **Integrations** tab
   - Click **+** to generate a new API key
   - Name: `GitHub Actions CI/CD`
   - Access: **App Manager**
   - Download the `.p8` file (you can only do this once!)
   - Note the **Issuer ID** and **Key ID**

2. **Convert .p8 to Base64**:
   ```bash
   base64 -i ~/Downloads/AuthKey_XXXXXXXXXX.p8 | pbcopy
   ```

3. **Add GitHub Secrets**:
   - Go to repository Settings → Secrets and variables → Actions
   - Add the three secrets listed above

4. **Update Provisioning Profile Name**:
   - Open `ios/ExportOptions.plist`
   - Replace `YOUR_PROVISIONING_PROFILE_NAME` with your actual profile name
   - Find your profile name in Xcode (Signing & Capabilities) or Apple Developer Portal

**How it works**:
1. Push a version tag: `git tag v2.2.14 && git push origin v2.2.14`
2. Workflow builds the IPA with auto-incremented build number
3. Automatically uploads to TestFlight
4. Build appears in App Store Connect → TestFlight (processing takes 5-10 minutes)

**Detailed Setup Guide**: See the comprehensive [iOS Setup Guide](ios-setup-guide.md) for step-by-step instructions.

## Security Notes

⚠️ **NEVER commit:**
- `key.properties`
- Keystore files (.jks, .keystore)
- Certificates (.p12)
- Provisioning profiles (.mobileprovision)
- App Store Connect API keys (.p8)
- API keys or secrets

✅ **Always:**
- Use GitHub Secrets for sensitive data
- Keep `.gitignore` updated
- Rotate secrets if compromised
