import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  Map<String, dynamic>? _user;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get user => _user;
  String? get token => _token;

  // Customer Credentials
  final String customerPhone = "03454762207";
  final String customerPassword = "123456";

  // Restaurant Supplier Credentials
  final String restaurantEmail = "restaurant@food.com";
  final String restaurantPassword = "123456";

  Future<bool> login(String identifier, String password) async {
    try {
      // Check if logging in as Customer (phone number)
      if (identifier.trim() == customerPhone && password.trim() == customerPassword) {
        _isLoggedIn = true;
        _user = {
          'id': '1',
          'name': 'Zagaaam (Customer)',
          'phone': customerPhone,
          'role': 'customer',
          'email': null,
        };
        _token = 'mock_customer_jwt';
        notifyListeners();
        return true;
      }
      
      // Check if logging in as Restaurant (email)
      if (identifier.trim().toLowerCase() == restaurantEmail && password.trim() == restaurantPassword) {
        _isLoggedIn = true;
        _user = {
          'id': '2',
          'name': 'Food Paradise (Restaurant)',
          'phone': null,
          'role': 'restaurant',
          'email': restaurantEmail,
        };
        _token = 'mock_restaurant_jwt';
        notifyListeners();
        return true;
      }
      
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
