#!/usr/bin/env bash
set -euo pipefail

xcodebuild \
  -scheme RecipeEngine \
  -sdk iphonesimulator \
  -destination "platform=iOS Simulator,name=iPhone 15,OS=latest" \
  clean test

echo "✅ Build and tests completed successfully!"
