import 'package:flutter/foundation.dart';
import 'package:workout_app/core/models/user.dart';

// Auth Provider with MOCK implementation
// Later we'll replace with Firebase
class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  
  // MOCK: Simulate login
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Please enter email and password';
      _isLoading = false;
      notifyListeners();
      return;
    }
    
    // Mock successful login
    _currentUser = User.mock();
    _isLoading = false;
    notifyListeners();
  }
  
  // MOCK: Simulate signup
  Future<void> signup(String email, String password, String displayName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    await Future.delayed(const Duration(seconds: 1));
    
    if (email.isEmpty || password.isEmpty || displayName.isEmpty) {
      _errorMessage = 'Please fill all fields';
      _isLoading = false;
      notifyListeners();
      return;
    }
    
    // Mock successful signup
    _currentUser = User(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: displayName,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    _isLoading = false;
    notifyListeners();
  }
  
  // MOCK: Simulate logout
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    notifyListeners();
  }
  
  // MOCK: Simulate Google login
  Future<void> loginWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = User.mock();
    _isLoading = false;
    notifyListeners();
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
