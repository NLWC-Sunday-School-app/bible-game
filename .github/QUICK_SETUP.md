# Quick CI/CD Setup Guide

## Step 1: Prepare Your Keystore for GitHub

Run these commands to get your keystore ready:

```bash
# Convert keystore to base64 (this will copy to clipboard)
base64 -i game-keystore.jks | pbcopy
```

The base64 string is now in your clipboard!

## Step 2: Get Your Signing Credentials

You need these values from when you created your keystore:
- **Store Password**: The password for the keystore file
- **Key Password**: The password for the key
- **Key Alias**: The alias name you used

If you don't remember these, check your `key.properties` file or your notes.

## Step 3: Add Secrets to GitHub

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**

Add these 4 secrets:

### Secret 1: KEYSTORE_BASE64
- Name: `KEYSTORE_BASE64`
- Value: Paste the base64 string from your clipboard

### Secret 2: KEYSTORE_PASSWORD
- Name: `KEYSTORE_PASSWORD`
- Value: Your keystore password

### Secret 3: KEY_PASSWORD
- Name: `KEY_PASSWORD`
- Value: Your key password

### Secret 4: KEY_ALIAS
- Name: `KEY_ALIAS`
- Value: Your key alias

## Step 4: Test the CI/CD

### Option A: Manual Trigger (Safest)
1. Go to **Actions** tab in GitHub
2. Click **Android Release Build**
3. Click **Run workflow**
4. Select your branch
5. Click **Run workflow**

### Option B: Tag-Based Release (Automatic)
```bash
git tag v1.0.0
git push origin v1.0.0
```

This will automatically:
- Build the Android AAB
- Create a GitHub Release
- Attach the AAB to the release

## Step 5: Download Your Build

After the workflow completes:
1. Go to **Actions** tab
2. Click on the completed workflow run
3. Scroll to **Artifacts**
4. Download `app-release`

Or if you used a tag, go to **Releases** and download from there!

## Troubleshooting

### Build fails with "keystore not found"
- Make sure all 4 secrets are added correctly
- Check that KEYSTORE_BASE64 is the full base64 string

### Build fails with "signing failed"
- Verify your passwords and alias are correct
- Try building locally first to confirm credentials work

### Workflow doesn't trigger
- Make sure you pushed the tag: `git push origin v1.0.0`
- Check that workflows are enabled in Settings → Actions

## Security Notes

✅ **Safe:**
- Keystore base64 in GitHub Secrets (encrypted)
- Passwords in GitHub Secrets (encrypted)
- Workflows only run on your repository

❌ **Never:**
- Commit `game-keystore.jks` to git
- Commit `key.properties` to git
- Share your secrets publicly

## Next Steps

Once Android CI/CD works:
- Set up iOS builds (optional)
- Add automatic Play Store deployment
- Configure Slack/Discord notifications
