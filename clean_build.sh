#!/bin/bash

echo "🧹 Cleaning and rebuilding..."
echo "============================="

echo "1. Stopping any running Flutter processes..."
pkill -f flutter 2>/dev/null || true

echo "2. Cleaning Flutter build..."
flutter clean

echo "3. Getting packages..."
flutter pub get

echo "4. Analyzing code..."
flutter analyze

echo "5. Building for web..."
flutter build web --release

echo "✅ Build complete!"
echo ""
echo "🚀 To run: flutter run -d chrome"
echo "📱 To build for production: flutter build web --release"
echo "🌐 Output in: build/web/"
