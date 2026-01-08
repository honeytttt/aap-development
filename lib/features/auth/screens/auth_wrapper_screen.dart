import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/auth/providers/auth_provider.dart';
import 'package:workout_app/features/auth/screens/login_screen.dart';
import 'package:workout_app/features/feed/screens/feed_screen.dart';
import 'package:workout_app/features/notifications/screens/notifications_screen.dart';
import 'package:workout_app/features/create_post/screens/create_post_screen.dart';
import 'package:workout_app/features/profile/screens/profile_screen.dart';
import 'package:workout_app/features/search/screens/search_screen.dart';

class AuthWrapperScreen extends StatefulWidget {
  const AuthWrapperScreen({super.key});

  @override
  State<AuthWrapperScreen> createState() => _AuthWrapperScreenState();
}

class _AuthWrapperScreenState extends State<AuthWrapperScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    // Check if user is authenticated
    if (!authProvider.isAuthenticated) {
      return const LoginScreen();
    }

    final screens = [
      const FeedScreen(),
      const SearchScreen(),
      const CreatePostScreen(),
      const NotificationsScreen(),
      ProfileScreen(userId: authProvider.currentUser?.id ?? ''),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      // Add logout button in app bar
      appBar: AppBar(
        title: const Text('Workout App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              // Navigator will automatically show LoginScreen
              // because authProvider.isAuthenticated will be false
            },
            tooltip: 'Logout',
          ),
        ],
      ),
    );
  }
}
