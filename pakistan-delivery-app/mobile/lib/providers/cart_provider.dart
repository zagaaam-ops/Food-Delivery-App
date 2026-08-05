import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final String restaurantId;
  final String restaurantName;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.restaurantId,
    required this.restaurantName,
    this.quantity = 1,
  });

  double get total => price * quantity;
}

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  String? _currentRestaurantId;

  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount => _items.fold(0, (sum, item) => sum + item.total);
  bool get isEmpty => _items.isEmpty;
  String? get currentRestaurantId => _currentRestaurantId;

  void addItem(CartItem item) {
    // Check if adding from a different restaurant
    if (_currentRestaurantId != null && _currentRestaurantId != item.restaurantId) {
      // Clear cart if switching restaurants
      _items.clear();
    }
    
    _currentRestaurantId = item.restaurantId;
    
    // Check if item already exists
    int index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    if (_items.isEmpty) {
      _currentRestaurantId = null;
    }
    notifyListeners();
  }

  void updateQuantity(String itemId, int newQuantity) {
    int index = _items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
      if (_items.isEmpty) {
        _currentRestaurantId = null;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _currentRestaurantId = null;
    notifyListeners();
  }
}
