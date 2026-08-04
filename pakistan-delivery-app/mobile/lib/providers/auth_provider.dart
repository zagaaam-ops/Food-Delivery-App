import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  Map<String, dynamic>? _user;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get user => _user;
  String? get token => _token;

  // YOUR SPECIFIC CREDENTIALS
  final String testPhone = "03454762207";
  final String testPassword = "123456";

  // Restaurant Owner Credentials (Supplier)
  final String restaurantEmail = "restaurant@food.com";
  final String restaurantPassword = "123456";

  Future<bool> login(String identifier, String password, {bool isRestaurant = false}) async {
    try {
      // In a real app, we call the backend:
      // final response = await http.post(
      //   Uri.parse('YOUR_BACKEND_URL/api/auth/login'),
      //   body: jsonEncode({'phone': identifier, 'password': password}),
      //   headers: {'Content-Type': 'application/json'},
      // );

      // For now, we hardcode your credentials for instant testing:
      if (identifier == testPhone && password == testPassword) {
        _isLoggedIn = true;
        _user = {
          'id': '1',
          'name': 'Zagaaam (Customer)',
          'phone': testPhone,
          'role': 'customer'
        };
        _token = 'mock_customer_jwt';
        notifyListeners();
        return true;
      } 
      else if (identifier == restaurantEmail && password == restaurantPassword && isRestaurant) {
        _isLoggedIn = true;
        _user = {
          'id': '2',
          'name': 'Food Paradise (Restaurant)',
          'email': restaurantEmail,
          'role': 'restaurant'
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
