#!/usr/bin/env bash
set -euo pipefail

echo "🔄 Cleaning..."
swift package clean

echo "🔨 Building..."
swift build

echo "🧪 Running tests..."
swift test

echo "✅ Build and tests completed successfully!"
