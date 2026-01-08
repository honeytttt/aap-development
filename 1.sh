echo "🧪 Testing the app..."
flutter clean
flutter pub get

echo ""
echo "🔍 Checking for compilation errors..."
if flutter analyze 2>&1 | grep -q "error -"; then
    echo "❌ Compilation errors found:"
    flutter analyze 2>&1 | grep "error -"
else
    echo "✅ No compilation errors!"
    echo ""
    echo "🚀 Running app..."
    echo "================="
    echo "Test these features:"
    echo "1. Login with any email/password (mock)"
    echo "2. Sign up with any details (mock)"
    echo "3. Logout"
    echo "4. All data is mock - no Firebase yet!"
    echo ""
    flutter run -d chrome
fi