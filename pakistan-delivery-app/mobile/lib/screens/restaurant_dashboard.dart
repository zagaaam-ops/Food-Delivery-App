import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart';

class RestaurantDashboard extends StatefulWidget {
  const RestaurantDashboard({super.key});

  @override
  State<RestaurantDashboard> createState() => _RestaurantDashboardState();
}

class _RestaurantDashboardState extends State<RestaurantDashboard> {
  int _selectedTab = 0; // 0 = Pending, 1 = Active, 2 = History

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    // Get the restaurant ID from the logged-in user
    final restaurantId = authProvider.user?['id'] ?? 'restaurant_1';
    
    // Filter orders for this restaurant only
    List<Order> restaurantOrders = orderProvider.getOrdersForRestaurant(restaurantId);
    
    List<Order> pendingOrders = restaurantOrders.where((o) => o.status == 'pending').toList();
    List<Order> activeOrders = restaurantOrders.where((o) => 
      o.status == 'accepted' || o.status == 'preparing' || o.status == 'ready'
    ).toList();
    List<Order> completedOrders = restaurantOrders.where((o) => 
      o.status == 'delivered' || o.status == 'cancelled'
    ).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Restaurant Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Orders refreshed!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Cards
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildStatCard('Pending', pendingOrders.length.toString(), Colors.orange),
                const SizedBox(width: 12),
                _buildStatCard('Active', activeOrders.length.toString(), Colors.green),
                const SizedBox(width: 12),
                _buildStatCard('Today', (pendingOrders.length + activeOrders.length + completedOrders.length).toString(), Colors.blue),
              ],
            ),
          ),
          
          // Tab Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildTab('🕐 Pending (${pendingOrders.length})', 0),
                const SizedBox(width: 8),
                _buildTab('⚡ Active (${activeOrders.length})', 1),
                const SizedBox(width: 8),
                _buildTab('📋 History (${completedOrders.length})', 2),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Order List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _selectedTab == 0
                  ? _buildOrderList(pendingOrders, 'No pending orders')
                  : _selectedTab == 1
                      ? _buildOrderList(activeOrders, 'No active orders')
                      : _buildOrderList(completedOrders, 'No completed orders'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.orange : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders, String emptyMessage) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(emptyMessage, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text(
              'Orders placed by customers will appear here',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(orders[index]);
      },
    );
  }

  Widget _buildOrderCard(Order order) {
    bool isPending = order.status == 'pending';
    bool isActive = order.status == 'accepted' || order.status == 'preparing' || order.status == 'ready';
    
    Color statusColor = isPending ? Colors.orange : (isActive ? Colors.green : Colors.grey);
    String statusText = order.status.toUpperCase();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.id,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('👤 ${order.customerName}', style: const TextStyle(fontSize: 14)),
          Text('📱 ${order.customerPhone}', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(
            '📦 ${order.items.map((i) => '${i.quantity}x ${i.name}').join(', ')}',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('💰 Rs ${order.total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('⏱️ ${_timeAgo(order.createdAt)}', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            ],
          ),
          if (isPending) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<OrderProvider>(context, listen: false)
                          .updateOrderStatus(order.id, 'accepted');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('✅ Order accepted! Customer notified.')),
                      );
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('✅ Accept'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<OrderProvider>(context, listen: false)
                          .updateOrderStatus(order.id, 'cancelled');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('❌ Order rejected. Customer notified.')),
                      );
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('❌ Reject'),
                  ),
                ),
              ],
            ),
          ],
          if (order.status == 'accepted') ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<OrderProvider>(context, listen: false)
                      .updateOrderStatus(order.id, 'preparing');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('👨‍🍳 Order is being prepared!')),
                  );
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('👨‍🍳 Start Preparing'),
              ),
            ),
          ],
          if (order.status == 'preparing') ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<OrderProvider>(context, listen: false)
                      .updateOrderStatus(order.id, 'ready');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('🚀 Order ready for delivery!')),
                  );
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('🚀 Ready for Delivery'),
              ),
            ),
          ],
          if (order.status == 'ready') ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<OrderProvider>(context, listen: false)
                      .updateOrderStatus(order.id, 'delivered');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ Order delivered!')),
                  );
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('✅ Mark Delivered'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }
}
