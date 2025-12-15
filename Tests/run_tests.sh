#!/usr/bin/env bash
set -euo pipefail

PREFERRED_DEVICES=("iPhone 17" "iPhone 16" "iPhone 15")

TARGET_DEVICE=""

echo "Looking for available simulators..."

for DEVICE in "${PREFERRED_DEVICES[@]}"; do
    if xcrun simctl list devices available | grep -q "$DEVICE"; then
        TARGET_DEVICE="$DEVICE"
        echo "Found available device: $TARGET_DEVICE"
        break
    fi
done

# validation
if [[ -z "$TARGET_DEVICE" ]]; then
    echo "Error: No preferred simulators found!"
    echo "   Please install one of: ${PREFERRED_DEVICES[*]}"
    exit 1
fi

echo "Starting tests on $TARGET_DEVICE..."

xcodebuild \
  -scheme RecipeEngine \
  -sdk iphonesimulator \
  -destination "platform=iOS Simulator,name=$TARGET_DEVICE" \
  clean test \
  | xcbeatify

echo "✅ Build and tests completed successfully!"
