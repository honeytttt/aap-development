#!/bin/bash

echo "🚀 Building and Running Workout App..."
echo "======================================"

echo "1. Cleaning previous builds..."
flutter clean

echo "2. Getting packages..."
flutter pub get

echo "3. Analyzing code..."
if flutter analyze; then
  echo "✅ Code analysis passed!"
else
  echo "⚠️  Code analysis found issues"
fi

echo "4. Running app on Chrome..."
echo ""
echo "📱 Open your browser to: http://localhost:PORT"
echo ""
echo "🎯 Features to test:"
echo "   ✅ Notifications tab - should work now"
echo "   ✅ Search tab - with 3 content tabs"
echo "   ✅ Post likes - tap heart icons"
echo "   ✅ Nested comment likes - in comments screen"
echo "   ✅ Post creation - from Create tab or FAB"
echo ""
flutter run -d chrome
