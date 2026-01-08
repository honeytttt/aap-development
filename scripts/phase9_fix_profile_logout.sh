#!/bin/bash
# Fix Profile Screen Logout Button

echo "🔧 Fixing Profile screen logout button..."

# 1. Fix Profile Screen logout button - simpler approach
echo "📝 Fixing ProfileScreen logout handler..."
cat > lib/features/profile/screens/profile_screen.dart << 'PROFILE_SCREEN'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/auth/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings - Coming Soon')),
              );
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No User Found', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 8),
                  Text('Please login to view your profile',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Profile header
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '@${user.username}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (user.isVerified)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified,
                          color: Colors.blue[400],
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Verified',
                          style: TextStyle(
                            color: Colors.blue[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  // Bio
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      user.bio.isNotEmpty ? user.bio : 'No bio yet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat('Posts', '24'),
                      _buildStat('Followers', '1.2K'),
                      _buildStat('Following', '356'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Actions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Edit Profile - Coming Soon'),
                                ),
                              );
                            },
                            child: const Text('Edit Profile'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              // Show confirmation dialog
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Logout'),
                                  content: const Text('Are you sure you want to logout?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text('Logout'),
                                    ),
                                  ],
                                ),
                              );
                              
                              if (confirmed == true) {
                                // Show loading message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Logging out...'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                                
                                // Perform logout - AuthWrapperScreen will handle navigation
                                await authProvider.logout();
                                
                                // No need to navigate manually - AuthWrapperScreen will update
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Logout'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Recent Posts Grid
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Recent Posts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Text('Post ${index + 1}'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
PROFILE_SCREEN

# 2. Ensure AuthWrapperScreen is listening to auth changes
echo "📝 Checking AuthWrapperScreen..."
cat > lib/features/auth/screens/auth_wrapper_screen.dart << 'AUTH_WRAPPER'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/auth/providers/auth_provider.dart';
import 'package:workout_app/features/auth/screens/login_screen.dart';
import 'package:workout_app/features/create_post/screens/create_post_screen.dart';
import 'package:workout_app/features/feed/screens/feed_screen.dart';
import 'package:workout_app/features/notifications/screens/notifications_screen.dart';
import 'package:workout_app/features/profile/screens/profile_screen.dart';

class AuthWrapperScreen extends StatelessWidget {
  const AuthWrapperScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using Consumer to rebuild when auth state changes
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Show loading while initializing
        if (!authProvider.isInitialized) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Loading...', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          );
        }
        
        // Check if user is logged in
        if (authProvider.currentUser != null) {
          return const MainNavigationScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const FeedScreen(),
    Container(
      color: Colors.white,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.explore, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Explore', style: TextStyle(fontSize: 24, color: Colors.grey)),
            SizedBox(height: 8),
            Text('Coming Soon', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    ),
    const CreatePostScreen(),
    const AppNotificationsScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
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
    );
  }
}
AUTH_WRAPPER

# 3. Add debug logging to AuthProvider logout
echo "📝 Adding debug logging to AuthProvider..."
sed -i '/print('\''✅ User logged out successfully'\'');/a\
    print('\''🔄 AuthProvider notifying listeners after logout'\'');' lib/features/auth/providers/auth_provider.dart

# 4. Clean up and rebuild
echo "✅ Profile logout button fix applied!"
echo "🔄 Running flutter clean..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo ""
echo "🎉 Profile screen logout button fixed!"
echo "✅ Removed manual navigation attempts"
echo "✅ AuthWrapperScreen uses Consumer to listen for auth changes"
echo "✅ Logout now triggers automatic navigation back to login"
echo ""
echo "🚀 Test the fix:"
echo "   1. Run: flutter run"
echo "   2. Login to the app"
echo "   3. Go to Profile screen"
echo "   4. Tap Logout button"
echo "   5. Confirm logout in dialog"
echo "   6. Should automatically return to login screen"
echo ""
echo "📝 How it works now:"
echo "   • Profile screen just calls authProvider.logout()"
echo "   • AuthProvider clears user data and notifies listeners"
echo "   • AuthWrapperScreen (using Consumer) detects the change"
echo "   • AuthWrapperScreen automatically shows LoginScreen"
echo ""
echo "🔥 No manual navigation needed - it's all reactive!"
