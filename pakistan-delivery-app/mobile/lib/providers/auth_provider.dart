import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  Map<String, dynamic>? _user;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get user => _user;
  String? get token => _token;

  // Mock login - replace with actual API call
  Future<bool> login(String phone, String password) async {
    try {
      // TODO: Call backend API
      // final response = await http.post(...);
      
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      _isLoggedIn = true;
      _user = {
        'id': '1',
        'name': 'Test User',
        'phone': phone,
        'role': 'customer'
      };
      _token = 'mock_jwt_token';
      
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Mock register - replace with actual API call
  Future<bool> register({
    required String name,
    required String phone,
    required String password,
    String? email,
  }) async {
    try {
      // TODO: Call backend API
      await Future.delayed(const Duration(seconds: 1));
      
      _isLoggedIn = true;
      _user = {
        'id': '1',
        'name': name,
        'phone': phone,
        'email': email,
        'role': 'customer'
      };
      _token = 'mock_jwt_token';
      
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _isLoggedIn = false;
    _user = null;
    _token = null;
    notifyListeners();
  }

  // Pakistani phone number validation
  bool isValidPakistaniPhone(String phone) {
    // Format: 03XXXXXXXXX (11 digits starting with 03)
    final regex = RegExp(r'^03\d{9}$');
    return regex.hasMatch(phone);
  }
}
