import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userId;
  String? _username;
  String? _email;

  bool get isLoggedIn => _isLoggedIn;
  String? get userId => _userId;
  String? get username => _username;
  String? get email => _email;

  AuthProvider() {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _userId = prefs.getString('userId');
    _username = prefs.getString('username');
    _email = prefs.getString('email');
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    // Mock login - in real app, call API
    await Future.delayed(const Duration(seconds: 1));
    
    _isLoggedIn = true;
    _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    _username = email.split('@').first;
    _email = email;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', _userId!);
    await prefs.setString('username', _username!);
    await prefs.setString('email', _email!);
    
    notifyListeners();
  }

  Future<void> register(String email, String password, String username) async {
    // Mock registration
    await Future.delayed(const Duration(seconds: 1));
    
    _isLoggedIn = true;
    _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    _username = username;
    _email = email;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', _userId!);
    await prefs.setString('username', _username!);
    await prefs.setString('email', _email!);
    
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userId = null;
    _username = null;
    _email = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    notifyListeners();
  }
}
