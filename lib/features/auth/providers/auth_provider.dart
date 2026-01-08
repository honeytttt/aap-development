import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_app/core/models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  // Mock user data for development
  static final User mockUser = User(
    id: '1',
    username: 'fitness_john',
    displayName: 'John Fitness',
    avatarUrl: 'https://ui-avatars.com/api/?name=John+Fitness&background=4CAF50&color=fff',
    bio: 'Fitness enthusiast | Personal trainer',
    followersCount: 1243,
    followingCount: 342,
    postsCount: 56,
    joinedDate: DateTime(2023, 1, 15),
  );

  AuthProvider() {
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('currentUser');
      
      if (userJson != null) {
        final userData = json.decode(userJson);
        _user = User.fromJson(userData);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading user from prefs: $e');
    }
  }

  Future<void> _saveUserToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_user != null) {
        final userJson = json.encode(_user!.toJson());
        await prefs.setString('currentUser', userJson);
      }
    } catch (e) {
      print('Error saving user to prefs: $e');
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    try {
      if (username.isEmpty || password.isEmpty) {
        throw Exception('Please enter username and password');
      }

      // Mock login - in real app, this would call an API
      _user = mockUser;
      await _saveUserToPrefs();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String displayName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    try {
      if (username.isEmpty || email.isEmpty || password.isEmpty || displayName.isEmpty) {
        throw Exception('Please fill all fields');
      }

      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      // Mock registration - in real app, this would call an API
      _user = User(
        id: 'new_${DateTime.now().millisecondsSinceEpoch}',
        username: username,
        displayName: displayName,
        avatarUrl: 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(displayName)}&background=4CAF50&color=fff',
        bio: 'New fitness enthusiast',
        followersCount: 0,
        followingCount: 0,
        postsCount: 0,
        joinedDate: DateTime.now(),
      );
      
      await _saveUserToPrefs();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('currentUser');
      _user = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? bio,
    String? avatarUrl,
  }) async {
    if (_user == null) return;

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    try {
      _user = _user!.copyWith(
        displayName: displayName ?? _user!.displayName,
        bio: bio ?? _user!.bio,
        avatarUrl: avatarUrl ?? _user!.avatarUrl,
      );
      
      await _saveUserToPrefs();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
