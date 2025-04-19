#!/bin/bash
set -e

# Load config
source ./config/build-config.yaml

echo "🔧 Starting GrapheneOS build for $DEVICE on branch $BRANCH"

# Set up GPG
echo "$GPG_PRIVATE_KEY" | base64 --decode | gpg --batch --import
echo "$GPG_PASSPHRASE" | gpg --batch --passphrase-fd 0 --pinentry-mode loopback

# Init repo
mkdir -p ~/grapheneos && cd ~/grapheneos
repo init -u https://github.com/GrapheneOS/platform_manifest.git -b "$BRANCH"
repo sync -j$(nproc)

source build/envsetup.sh
lunch aosp_${DEVICE}-user
make -j$(nproc)

mkdir -p ../output
cp out/target/product/${DEVICE}/*.zip ../output/
cp out/target/product/${DEVICE}/*.img ../output/

cd ../output

# Sign OTA + images
for file in *; do
  echo "🔏 Signing $file"
  gpg --batch --yes --pinentry-mode loopback --passphrase "$GPG_PASSPHRASE" --output "$file.sig" --detach-sign "$file"
done

echo "✅ Build and signing complete"

