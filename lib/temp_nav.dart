import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/auth/providers/auth_provider.dart';
import 'package:workout_app/features/auth/screens/login_screen.dart';
import 'package:workout_app/features/auth/screens/register_screen.dart';
import 'package:workout_app/features/feed/screens/feed_screen.dart';
import 'package:workout_app/features/profile/screens/profile_screen.dart';
import 'package:workout_app/features/notifications/screens/notifications_screen.dart';
import 'package:workout_app/features/search/screens/search_screen.dart';
import 'package:workout_app/features/create_post/screens/create_post_screen.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return authProvider.isAuthenticated
        ? _buildAuthenticatedApp()
        : _buildUnauthenticatedApp();
  }

  Widget _buildAuthenticatedApp() {
    return MaterialApp(
      title: 'Workout App',
      theme: ThemeData(
        primaryColor: const Color(0xFF4CAF50),
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: _buildHomeScreen(),
      routes: {
        '/create-post': (context) => const CreatePostScreen(),
      },
    );
  }

  Widget _buildUnauthenticatedApp() {
    return MaterialApp(
      title: 'Workout App',
      theme: ThemeData(
        primaryColor: const Color(0xFF4CAF50),
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }

  Widget _buildHomeScreen() {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: IndexedStack(
          index: 0, // Default to feed screen
          children: const [
            FeedScreen(),
            SearchScreen(),
            CreatePostScreen(),
            NotificationsScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF4CAF50),
          unselectedItemColor: Colors.grey,
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
          onTap: (index) {
            // Navigation handled by IndexedStack
          },
        ),
      ),
    );
  }
}
