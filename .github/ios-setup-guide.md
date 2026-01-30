# iOS TestFlight Deployment Setup Guide

This guide will help you set up automatic TestFlight deployment for your iOS app.

## Step 1: Find Your Provisioning Profile Name

### Option A: Using Xcode (Easiest)

1. Open your project in Xcode:
   ```bash
   cd /Users/mac/Documents/Tobi/nlwc_biblegame/bible-game/ios
   open Runner.xcworkspace
   ```

2. In Xcode:
   - Select the **Runner** project in the left sidebar
   - Select the **Runner** target
   - Go to **Signing & Capabilities** tab
   - Under **Release** configuration, you'll see the provisioning profile name

3. Copy the exact name shown (e.g., "Bible Game App Store Profile" or similar)

### Option B: Using Apple Developer Portal

1. Go to [Apple Developer Portal](https://developer.apple.com/account/resources/profiles/list)
2. Sign in with your Apple Developer account
3. Click on **Certificates, IDs & Profiles**
4. Click on **Profiles** in the left sidebar
5. Find your **App Store** or **Ad Hoc** profile for `com.nlwc.bible.game`
6. Click on it and copy the **Profile Name** (not the UUID)

### Option C: Check Existing Provisioning Profile File

If you have the `.mobileprovision` file:

```bash
# Find all provisioning profiles on your Mac
ls ~/Library/MobileDevice/Provisioning\ Profiles/

# View details of a specific profile (replace UUID with actual file name)
security cms -D -i ~/Library/MobileDevice/Provisioning\ Profiles/YOUR_UUID.mobileprovision
```

Look for the `<key>Name</key>` entry in the output.

---

## Step 2: Create App Store Connect API Key

> [!IMPORTANT]
> You need **Admin**, **App Manager**, or **Account Holder** role in App Store Connect to create API keys.

### 2.1 Generate the API Key

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Sign in with your Apple ID
3. Click on **Users and Access** (in the top navigation)
4. Click on the **Integrations** tab
5. Under **App Store Connect API**, click the **+** button (or "Generate API Key")
6. Fill in the details:
   - **Name**: `GitHub Actions CI/CD` (or any descriptive name)
   - **Access**: Select **App Manager** (this allows uploading builds)
7. Click **Generate**

### 2.2 Download and Save the Key

> [!CAUTION]
> You can only download the API key **ONCE**. If you lose it, you'll need to create a new one.

1. After generating, click **Download API Key**
2. Save the `.p8` file securely (e.g., `AuthKey_XXXXXXXXXX.p8`)
3. Note down these three values (you'll need them for GitHub Secrets):
   - **Issuer ID** (shown at the top, looks like: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`)
   - **Key ID** (shown in the key list, looks like: `XXXXXXXXXX`)
   - **Key File Content** (the contents of the `.p8` file)

### 2.3 Prepare the Key for GitHub

Convert the `.p8` file to base64:

```bash
# Replace with your actual key file path
base64 -i ~/Downloads/AuthKey_XXXXXXXXXX.p8 | pbcopy
```

This copies the base64-encoded key to your clipboard.

---

## Step 3: Add GitHub Secrets

Go to your GitHub repository:
1. Navigate to **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret** for each of the following:

### Required Secrets for iOS Build

| Secret Name | Value | How to Get |
|-------------|-------|------------|
| `IOS_CERTIFICATE_BASE64` | Base64 of your .p12 certificate | Export from Keychain Access, then `base64 -i cert.p12` |
| `IOS_CERTIFICATE_PASSWORD` | Password for the .p12 file | Password you set when exporting |
| `IOS_PROVISIONING_PROFILE_BASE64` | Base64 of .mobileprovision | Download from Apple Developer, then `base64 -i profile.mobileprovision` |

### Required Secrets for TestFlight Deployment

| Secret Name | Value | How to Get |
|-------------|-------|------------|
| `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID from Step 2.2 | From App Store Connect API page |
| `APP_STORE_CONNECT_KEY_ID` | Key ID from Step 2.2 | From App Store Connect API page |
| `APP_STORE_CONNECT_KEY_BASE64` | Base64 of .p8 file from Step 2.3 | `base64 -i AuthKey_XXX.p8` |

---

## Step 4: Update ExportOptions.plist

Once you have your provisioning profile name from Step 1, update the file:

```bash
# Open the file
open /Users/mac/Documents/Tobi/nlwc_biblegame/bible-game/ios/ExportOptions.plist
```

Replace `YOUR_PROVISIONING_PROFILE_NAME` with the actual name you found.

---

## Step 5: Test the Workflow

After setting up all secrets:

1. Update `pubspec.yaml` version if needed
2. Create and push a tag:
   ```bash
   git tag v2.2.15-ios-test
   git push origin v2.2.15-ios-test
   ```

3. Monitor the GitHub Actions workflow
4. Check TestFlight for the new build (may take 5-10 minutes to process)

---

## Troubleshooting

### "No signing certificate found"
- Verify `IOS_CERTIFICATE_BASE64` is correct
- Ensure certificate is a **Distribution** certificate, not Development

### "No matching provisioning profile found"
- Check that the profile name in `ExportOptions.plist` exactly matches
- Ensure the profile is for **App Store** distribution
- Verify the profile includes your certificate

### "Authentication failed"
- Double-check all three App Store Connect API values
- Ensure the API key has **App Manager** access
- Verify the base64 encoding is correct (no extra newlines)

### Build succeeds but doesn't appear in TestFlight
- Check that the bundle identifier matches: `com.nlwc.bible.game`
- Ensure the app exists in App Store Connect
- Verify the API key has access to this specific app
