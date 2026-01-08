import 'package:flutter/foundation.dart';
import 'package:workout_app/core/models/user_profile.dart';
import 'package:workout_app/core/models/user_settings.dart';

class ProfileProvider with ChangeNotifier {
  UserProfile? _currentUserProfile;
  UserSettings _userSettings = UserSettings();
  bool _isLoading = false;
  Map<String, UserProfile> _userProfiles = {}; // Cache for other users' profiles

  UserProfile? get currentUserProfile => _currentUserProfile;
  UserSettings get userSettings => _userSettings;
  bool get isLoading => _isLoading;
  Map<String, UserProfile> get userProfiles => _userProfiles;

  ProfileProvider() {
    _loadMockData();
  }

  void _loadMockData() {
    _isLoading = true;
    notifyListeners();

    // Mock current user profile
    _currentUserProfile = UserProfile(
      userId: 'current-user',
      displayName: 'Yoga Enthusiast',
      bio: 'Passionate about yoga, meditation, and mindful living. Sharing my peaceful journey one pose at a time.',
      avatarUrl: 'https://via.placeholder.com/150/4CAF50/FFFFFF?text=YE',
      followerCount: 245,
      followingCount: 189,
      postCount: 42,
      joinedDate: DateTime.now().subtract(const Duration(days: 365)),
      interests: ['Yoga', 'Meditation', 'Mindfulness', 'Healthy Living'],
      isFollowing: false,
    );

    // Mock other users' profiles
    _userProfiles = {
      'user1': UserProfile(
        userId: 'user1',
        displayName: 'Meditation Guide',
        bio: 'Helping others find inner peace through meditation practices.',
        avatarUrl: 'https://via.placeholder.com/150/4CAF50/FFFFFF?text=MG',
        followerCount: 1200,
        followingCount: 450,
        postCount: 156,
        joinedDate: DateTime.now().subtract(const Duration(days: 500)),
        interests: ['Meditation', 'Mindfulness', 'Breathing Exercises'],
        isFollowing: true,
      ),
      'user2': UserProfile(
        userId: 'user2',
        displayName: 'Wellness Warrior',
        bio: 'Fitness enthusiast focused on holistic wellness and balanced living.',
        avatarUrl: 'https://via.placeholder.com/150/4CAF50/FFFFFF?text=WW',
        followerCount: 890,
        followingCount: 320,
        postCount: 78,
        joinedDate: DateTime.now().subtract(const Duration(days: 300)),
        interests: ['Fitness', 'Nutrition', 'Wellness', 'Workouts'],
        isFollowing: false,
      ),
      'user3': UserProfile(
        userId: 'user3',
        displayName: 'Mindful Runner',
        bio: 'Combining running with mindfulness for the ultimate mental and physical workout.',
        avatarUrl: 'https://via.placeholder.com/150/4CAF50/FFFFFF?text=MR',
        followerCount: 560,
        followingCount: 210,
        postCount: 34,
        joinedDate: DateTime.now().subtract(const Duration(days: 200)),
        interests: ['Running', 'Mindfulness', 'Cardio', 'Outdoor Activities'],
        isFollowing: true,
      ),
    };

    Future.delayed(const Duration(milliseconds: 500), () {
      _isLoading = false;
      notifyListeners();
    });
  }

  void updateProfile({
    String? displayName,
    String? bio,
    String? avatarUrl,
  }) {
    if (_currentUserProfile != null) {
      _currentUserProfile = _currentUserProfile!.copyWith(
        displayName: displayName,
        bio: bio,
        avatarUrl: avatarUrl,
      );
      notifyListeners();
    }
  }

  void updateSettings(UserSettings newSettings) {
    _userSettings = newSettings;
    notifyListeners();
  }

  void toggleFollowUser(String userId) {
    final profile = _userProfiles[userId];
    if (profile != null) {
      final newFollowingStatus = !profile.isFollowing;
      final newFollowerCount = newFollowingStatus 
          ? profile.followerCount + 1 
          : profile.followerCount - 1;
      
      _userProfiles[userId] = profile.copyWith(
        isFollowing: newFollowingStatus,
        followerCount: newFollowerCount,
      );
      notifyListeners();
    }
  }

  UserProfile? getUserProfile(String userId) {
    if (userId == 'current-user') {
      return _currentUserProfile;
    }
    return _userProfiles[userId];
  }

  void setAvatarUrl(String avatarUrl) {
    if (_currentUserProfile != null) {
      _currentUserProfile = _currentUserProfile!.copyWith(avatarUrl: avatarUrl);
      notifyListeners();
    }
  }

  // Mock avatar upload simulation
  Future<void> uploadAvatar(String imagePath) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    // Simulate uploaded avatar URL
    const mockAvatarUrl = 'https://via.placeholder.com/150/4CAF50/FFFFFF?text=AV';
    setAvatarUrl(mockAvatarUrl);

    _isLoading = false;
    notifyListeners();
  }

  void refreshProfile() {
    _isLoading = true;
    notifyListeners();
    
    Future.delayed(const Duration(seconds: 1), () {
      _isLoading = false;
      notifyListeners();
    });
  }
}
