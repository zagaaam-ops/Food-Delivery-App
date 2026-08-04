import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  Map<String, dynamic>? _user;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get user => _user;
  String? get token => _token;

  // ⚠️ ONLY THESE CREDENTIALS WILL WORK ⚠️
  final String validPhone = "03454762207";
  final String validPassword = "123456";

  Future<bool> login(String phone, String password) async {
    try {
      // 🔒 STRICT CHECK: Only your phone number and password work
      if (phone.trim() == validPhone && password.trim() == validPassword) {
        _isLoggedIn = true;
        _user = {
          'id': '1',
          'name': 'Zagaaam (Customer)',
          'phone': validPhone,
          'role': 'customer'
        };
        _token = 'mock_customer_jwt';
        notifyListeners();
        return true;
      }
      
      // ❌ Any other credentials will fail
      return false;
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
}
