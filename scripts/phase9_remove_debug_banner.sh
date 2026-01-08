#!/bin/bash
# Remove Debug Banner from the App

echo "🔧 Removing debug banner..."

# Update main.dart to remove debug banner
cat > lib/main.dart << 'MAIN_DART'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/auth/providers/auth_provider.dart';
import 'package:workout_app/features/auth/screens/auth_wrapper_screen.dart';
import 'package:workout_app/features/feed/providers/feed_provider.dart';
import 'package:workout_app/features/profile/providers/profile_provider.dart';
import 'package:workout_app/features/create_post/providers/create_post_provider.dart';
import 'package:workout_app/features/notifications/providers/notifications_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => CreatePostProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
      ],
      child: MaterialApp(
        title: 'Workout App',
        theme: ThemeData(
          primaryColor: const Color(0xFF4CAF50),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
          useMaterial3: true,
        ),
        home: const AuthWrapperScreen(),
        debugShowCheckedModeBanner: false, // This removes the debug banner
      ),
    );
  }
}
MAIN_DART

# Also update MaterialApp in AuthWrapperScreen if needed
sed -i 's/MaterialApp(/MaterialApp(debugShowCheckedModeBanner: false, /g' lib/features/auth/screens/auth_wrapper_screen.dart 2>/dev/null || true

echo "✅ Debug banner removed!"
echo "🔄 Running flutter clean..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo ""
echo "🎉 Debug banner has been removed!"
echo "👉 The app will now run without the 'DEBUG' label in the corner."
echo ""
echo "🚀 Run: flutter run"
echo ""
echo "📝 Additional ways to remove debug banner:"
echo "   1. Add 'debugShowCheckedModeBanner: false' to MaterialApp"
echo "   2. Run with 'flutter run --release' flag"
echo "   3. Build release APK: 'flutter build apk --release'"
