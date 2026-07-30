import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final String? nameUrdu;
  final double price;
  int quantity;
  final String storeId;

  CartItem({
    required this.id,
    required this.name,
    this.nameUrdu,
    required this.price,
    this.quantity = 1,
    required this.storeId,
  });

  double get total => price * quantity;
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  
  int get itemCount => _items.length;
  
  double get subtotal {
    return _items.fold(0, (sum, item) => sum + item.total);
  }

  double get deliveryFee => 50.0; // Mock delivery fee
  
  double get tax => subtotal * 0.13; // 13% GST in Pakistan
  
  double get total => subtotal + deliveryFee + tax;

  void addItem(CartItem item) {
    final existingIndex = _items.indexWhere((i) => i.id == item.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }

    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  void incrementQuantity(String itemId) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String itemId) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
        notifyListeners();
      } else {
        removeItem(itemId);
      }
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Check if all items are from the same store
  bool isSingleStore() {
    if (_items.isEmpty) return true;
    final firstStoreId = _items.first.storeId;
    return _items.every((item) => item.storeId == firstStoreId);
  }
}
