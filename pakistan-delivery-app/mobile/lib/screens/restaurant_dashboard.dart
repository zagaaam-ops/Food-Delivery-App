import 'package:flutter/material.dart';

class RestaurantDashboard extends StatefulWidget {
  const RestaurantDashboard({super.key});

  @override
  State<RestaurantDashboard> createState() => _RestaurantDashboardState();
}

class _RestaurantDashboardState extends State<RestaurantDashboard> {
  int _selectedTab = 0; // 0 = Pending, 1 = Active, 2 = History

  // Mock orders data
  final List<Map<String, dynamic>> _pendingOrders = [
    {
      'id': 'ORD-001',
      'customer': 'Ahmed Khan',
      'items': '2x Biryani, 1x Cold Drink',
      'total': 'Rs 1,250',
      'time': '10 min ago',
      'status': 'pending',
    },
    {
      'id': 'ORD-002',
      'customer': 'Sara Ali',
      'items': '1x Pizza, 2x Garlic Bread',
      'total': 'Rs 1,800',
      'time': '25 min ago',
      'status': 'pending',
    },
    {
      'id': 'ORD-003',
      'customer': 'Usman Malik',
      'items': '3x Burger, 3x Fries',
      'total': 'Rs 2,100',
      'time': '45 min ago',
      'status': 'pending',
    },
  ];

  final List<Map<String, dynamic>> _activeOrders = [
    {
      'id': 'ORD-004',
      'customer': 'Fatima Noor',
      'items': '1x BBQ Platter',
      'total': 'Rs 3,500',
      'time': '15 min ago',
      'status': 'preparing',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Restaurant Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Logout logic
              Navigator.pop(context);
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
                _buildStatCard('Pending', '3', Colors.orange),
                const SizedBox(width: 12),
                _buildStatCard('Active', '1', Colors.green),
                const SizedBox(width: 12),
                _buildStatCard('Today', '12', Colors.blue),
              ],
            ),
          ),
          
          // Tab Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildTab('🕐 Pending', 0),
                const SizedBox(width: 8),
                _buildTab('⚡ Active', 1),
                const SizedBox(width: 8),
                _buildTab('📋 History', 2),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Order List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: _getCurrentOrders().map((order) => _buildOrderCard(order)).toList(),
              ),
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

  List<Map<String, dynamic>> _getCurrentOrders() {
    if (_selectedTab == 0) return _pendingOrders;
    if (_selectedTab == 1) return _activeOrders;
    return []; // History (empty for now)
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    bool isPending = order['status'] == 'pending';
    bool isPreparing = order['status'] == 'preparing';
    
    Color statusColor = isPending ? Colors.orange : (isPreparing ? Colors.green : Colors.grey);
    String statusText = isPending ? 'Pending' : (isPreparing ? 'Preparing' : 'Completed');
    
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
                order['id'],
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
          Text('👤 ${order['customer']}', style: const TextStyle(fontSize: 14)),
          Text('📦 ${order['items']}', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('💰 ${order['total']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('⏱️ ${order['time']}', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            ],
          ),
          if (isPending) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Accept order
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order accepted! Customer will be notified.')),
                      );
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
                      // Reject order
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order rejected. Customer notified.')),
                      );
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
          if (isPreparing) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order marked as ready for delivery!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('🚀 Ready for Delivery'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
