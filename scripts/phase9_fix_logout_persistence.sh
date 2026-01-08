#!/bin/bash
# Fix Logout and Authentication Persistence

echo "🔧 Fixing logout and authentication persistence..."

# 1. Fix Auth Provider with persistence
echo "📝 Fixing AuthProvider with SharedPreferences..."
cat > lib/features/auth/providers/auth_provider.dart << 'AUTH_PROVIDER'
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_app/core/models/user.dart';

class AuthProvider with ChangeNotifier {
  AppUser? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isInitialized => _isInitialized;

  static const String _userKey = 'current_user';

  AuthProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();
    
    await _loadUserFromStorage();
    
    _isLoading = false;
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson != null && userJson.isNotEmpty) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        _currentUser = AppUser(
          id: userMap['id'],
          username: userMap['username'],
          email: userMap['email'],
          fullName: userMap['fullName'],
          avatarUrl: userMap['avatarUrl'],
          bio: userMap['bio'],
          isVerified: userMap['isVerified'] ?? false,
        );
        print('✅ User loaded from storage: ${_currentUser?.username}');
      } else {
        print('ℹ️ No user found in storage');
      }
    } catch (e) {
      print('❌ Error loading user from storage: $e');
    }
  }

  Future<void> _saveUserToStorage(AppUser? user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (user == null) {
        await prefs.remove(_userKey);
        print('✅ User removed from storage');
      } else {
        final userJson = json.encode({
          'id': user.id,
          'username': user.username,
          'email': user.email,
          'fullName': user.fullName,
          'avatarUrl': user.avatarUrl,
          'bio': user.bio,
          'isVerified': user.isVerified,
        });
        await prefs.setString(_userKey, userJson);
        print('✅ User saved to storage: ${user.username}');
      }
    } catch (e) {
      print('❌ Error saving user to storage: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // For testing, accept any email/password
      if (email.isNotEmpty && password.isNotEmpty) {
        _currentUser = AppUser(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          username: email.split('@')[0],
          email: email,
          fullName: 'Test User',
          avatarUrl: 'https://picsum.photos/100/100?random=0',
          bio: 'Fitness enthusiast',
          isVerified: true,
        );

        // Save to storage
        await _saveUserToStorage(_currentUser);

        _isLoading = false;
        notifyListeners();
        
        print('✅ User logged in: ${_currentUser?.username}');
        return true;
      } else {
        _error = 'Invalid credentials';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Login failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password, String username, String fullName) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _currentUser = AppUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        username: username,
        email: email,
        fullName: fullName,
        avatarUrl: 'https://picsum.photos/100/100?random=0',
        bio: '',
        isVerified: false,
      );

      // Save to storage
      await _saveUserToStorage(_currentUser);

      _isLoading = false;
      notifyListeners();
      
      print('✅ User registered: ${_currentUser?.username}');
      return true;
    } catch (e) {
      _error = 'Registration failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    print('🚪 Logging out...');
    
    // Clear from storage
    await _saveUserToStorage(null);
    
    // Clear from memory
    _currentUser = null;
    notifyListeners();
    
    print('✅ User logged out');
  }

  Future<void> updateProfile(AppUser user) async {
    _currentUser = user;
    await _saveUserToStorage(user);
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
AUTH_PROVIDER

# 2. Fix Profile Screen logout button
echo "📝 Fixing ProfileScreen logout..."
cat > lib/features/profile/screens/profile_screen.dart << 'PROFILE_SCREEN'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/auth/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('No user found'))
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
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Edit profile
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Edit Profile - Coming Soon'),
                                ),
                              );
                            },
                            child: const Text('Edit Profile'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
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
                                await authProvider.logout();
                                // Navigation is handled by AuthWrapperScreen
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

# 3. Fix Auth Wrapper Screen to handle loading better
echo "📝 Improving AuthWrapperScreen..."
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
    final authProvider = Provider.of<AuthProvider>(context);
    
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

# 4. Add SharedPreferences dependency
echo "📝 Adding SharedPreferences dependency..."
if grep -q "shared_preferences:" pubspec.yaml; then
    echo "✅ SharedPreferences already in pubspec.yaml"
else
    # Add shared_preferences to dependencies
    sed -i '/dependencies:/a\  shared_preferences: ^2.2.2' pubspec.yaml
    echo "✅ Added shared_preferences to pubspec.yaml"
fi

# 5. Clean up and rebuild
echo "✅ All fixes applied!"
echo "🔄 Running flutter clean..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🔍 Running flutter analyze..."
flutter analyze

echo ""
echo "🎉 Logout and authentication persistence fixed!"
echo "✅ Logout now works properly"
echo "✅ Authentication state persists across app restarts"
echo "✅ User data saved locally using SharedPreferences"
echo "✅ Better loading states"
echo ""
echo "🚀 Test the fixes:"
echo "   1. Run: flutter run"
echo "   2. Login with any credentials"
echo "   3. Close and restart the app - should stay logged in"
echo "   4. Go to Profile screen"
echo "   5. Tap Logout button"
echo "   6. Should return to login screen"
echo ""
echo "📋 Key Changes:"
echo "   • Added SharedPreferences for data persistence"
echo "   • Fixed logout button in Profile screen"
echo "   • Improved AuthWrapperScreen loading states"
echo "   • Better error handling and logging"
