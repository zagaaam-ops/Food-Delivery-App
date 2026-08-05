import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'cart_provider.dart';

class Order {
  final String id;
  final String customerName;
  final String customerPhone;
  final String restaurantId;
  final String restaurantName;
  final List<CartItem> items;
  final double total;
  final DateTime createdAt;
  String status;
  String? riderName;
  String? riderPhone;

  Order({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.total,
    required this.createdAt,
    this.status = 'pending',
    this.riderName,
    this.riderPhone,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'customerName': customerName,
    'customerPhone': customerPhone,
    'restaurantId': restaurantId,
    'restaurantName': restaurantName,
    'items': items.map((i) => {
      'id': i.id,
      'name': i.name,
      'price': i.price,
      'quantity': i.quantity,
      'restaurantId': i.restaurantId,
      'restaurantName': i.restaurantName,
    }).toList(),
    'total': total,
    'createdAt': createdAt.toIso8601String(),
    'status': status,
    'riderName': riderName,
    'riderPhone': riderPhone,
  };

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      restaurantId: json['restaurantId'],
      restaurantName: json['restaurantName'],
      items: (json['items'] as List).map((i) => CartItem(
        id: i['id'],
        name: i['name'],
        price: i['price'].toDouble(),
        restaurantId: i['restaurantId'],
        restaurantName: i['restaurantName'],
        quantity: i['quantity'],
      )).toList(),
      total: json['total'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'],
      riderName: json['riderName'],
      riderPhone: json['riderPhone'],
    );
  }
}

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];
  static const String _storageKey = 'orders';

  OrderProvider() {
    _loadOrders();
  }

  List<Order> get orders => _orders;
  
  List<Order> get pendingOrders => _orders.where((o) => o.status == 'pending').toList();
  
  List<Order> get activeOrders => _orders.where((o) => 
    o.status == 'accepted' || o.status == 'preparing' || o.status == 'ready'
  ).toList();
  
  List<Order> get completedOrders => _orders.where((o) => 
    o.status == 'delivered' || o.status == 'cancelled'
  ).toList();

  // Get orders for a specific restaurant
  List<Order> getOrdersForRestaurant(String restaurantId) {
    return _orders.where((o) => o.restaurantId == restaurantId).toList();
  }

  // Get orders for a specific customer
  List<Order> getOrdersForCustomer(String customerPhone) {
    return _orders.where((o) => o.customerPhone == customerPhone).toList();
  }

  void placeOrder({
    required String customerName,
    required String customerPhone,
    required String restaurantId,
    required String restaurantName,
    required List<CartItem> items,
    required double total,
  }) {
    final order = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      customerName: customerName,
      customerPhone: customerPhone,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      items: items,
      total: total,
      createdAt: DateTime.now(),
    );
    _orders.insert(0, order);
    _saveOrders();
    notifyListeners();
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].status = newStatus;
      _saveOrders();
      notifyListeners();
    }
  }

  void clearOrders() {
    _orders.clear();
    _saveOrders();
    notifyListeners();
  }

  // Persistence methods
  Future<void> _loadOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? ordersJson = prefs.getString(_storageKey);
      if (ordersJson != null) {
        final List<dynamic> decoded = jsonDecode(ordersJson);
        _orders = decoded.map((o) => Order.fromJson(o as Map<String, dynamic>)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading orders: $e');
    }
  }

  Future<void> _saveOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String ordersJson = jsonEncode(_orders.map((o) => o.toJson()).toList());
      await prefs.setString(_storageKey, ordersJson);
    } catch (e) {
      print('Error saving orders: $e');
    }
  }
}
