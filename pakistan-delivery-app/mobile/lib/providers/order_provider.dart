import 'package:flutter/material.dart';
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
  String status; // pending, accepted, preparing, ready, delivered, cancelled
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
      'name': i.name,
      'price': i.price,
      'quantity': i.quantity,
      'total': i.total,
    }).toList(),
    'total': total,
    'createdAt': createdAt.toIso8601String(),
    'status': status,
    'riderName': riderName,
    'riderPhone': riderPhone,
  };
}

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;
  List<Order> get pendingOrders => _orders.where((o) => o.status == 'pending').toList();
  List<Order> get activeOrders => _orders.where((o) => 
    o.status == 'accepted' || o.status == 'preparing' || o.status == 'ready'
  ).toList();
  List<Order> get completedOrders => _orders.where((o) => 
    o.status == 'delivered' || o.status == 'cancelled'
  ).toList();

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
    _orders.insert(0, order); // Newest first
    notifyListeners();
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].status = newStatus;
      notifyListeners();
    }
  }

  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }
}
