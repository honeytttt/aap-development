import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:workout_app/core/models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (email.isNotEmpty && password.isNotEmpty) {
      // Extract name from email (everything before @)
      final name = email.split('@').first;
      _user = User(
        id: 'mock-user-1',
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = 'Please enter email and password';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String email, String password, String name) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
      _user = User(
        id: 'mock-user-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = 'Please fill all fields';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _user = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
