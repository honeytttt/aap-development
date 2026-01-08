import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/auth/providers/auth_provider.dart';
import 'package:workout_app/features/auth/screens/login_screen.dart';
import 'package:workout_app/features/auth/screens/signup_screen.dart';
import 'package:workout_app/features/feed/screens/feed_screen.dart';

class AuthWrapperScreen extends StatefulWidget {
  const AuthWrapperScreen({super.key});

  @override
  State<AuthWrapperScreen> createState() => _AuthWrapperScreenState();
}

class _AuthWrapperScreenState extends State<AuthWrapperScreen> {
  bool _showSignup = false;

  void _toggleAuthMode() {
    setState(() {
      _showSignup = !_showSignup;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return authProvider.isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : authProvider.user != null
            ? const FeedScreen()
            : _showSignup
                ? SignupScreen(onLoginPressed: _toggleAuthMode)
                : LoginScreen(onSignupPressed: _toggleAuthMode);
  }
}
