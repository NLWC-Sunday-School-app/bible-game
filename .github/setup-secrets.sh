#!/bin/bash
# CI/CD Setup Helper Script
# This script helps prepare secrets for GitHub Actions

set -e

echo "🔐 GitHub Actions CI/CD Setup Helper"
echo "===================================="
echo ""

# Check if keystore exists
if [ ! -f "game-keystore.jks" ]; then
    echo "❌ Error: Keystore not found at game-keystore.jks"
    exit 1
fi

# Check if key.properties exists
if [ ! -f "key.properties" ]; then
    echo "❌ Error: key.properties not found at key.properties"
    echo "Please create this file with your keystore credentials"
    exit 1
fi

echo "✅ Found keystore and key.properties"
echo ""

# Convert keystore to base64
echo "📦 Converting keystore to base64..."
KEYSTORE_BASE64=$(base64 -i game-keystore.jks)
echo "$KEYSTORE_BASE64" | pbcopy
echo "✅ Keystore base64 copied to clipboard!"
echo ""

# Extract values from key.properties
echo "🔑 Reading key.properties..."
STORE_PASSWORD=$(grep "storePassword=" key.properties | cut -d'=' -f2)
KEY_PASSWORD=$(grep "keyPassword=" key.properties | cut -d'=' -f2)
KEY_ALIAS=$(grep "keyAlias=" key.properties | cut -d'=' -f2)

echo ""
echo "📋 GitHub Secrets to Add"
echo "========================"
echo ""
echo "Go to: https://github.com/YOUR_USERNAME/YOUR_REPO/settings/secrets/actions"
echo ""
echo "Add these secrets:"
echo ""
echo "1. KEYSTORE_BASE64"
echo "   Value: (already in clipboard - paste it)"
echo ""
echo "2. KEYSTORE_PASSWORD"
echo "   Value: $STORE_PASSWORD"
echo ""
echo "3. KEY_PASSWORD"
echo "   Value: $KEY_PASSWORD"
echo ""
echo "4. KEY_ALIAS"
echo "   Value: $KEY_ALIAS"
echo ""
echo "✅ Setup complete! Follow the instructions above to add secrets to GitHub."
echo ""
echo "💡 Tip: After adding secrets, test with:"
echo "   git tag v1.0.0-test"
echo "   git push origin v1.0.0-test"
