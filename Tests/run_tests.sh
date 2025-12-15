#!/usr/bin/env bash
set -euo pipefail

xcodebuild \
  -scheme RecipeEngine \
  -sdk iphonesimulator \
  -destination "platform=iOS Simulator,name=iPhone 16,OS=18.4" \
  clean test

echo "✅ Build and tests completed successfully!"
