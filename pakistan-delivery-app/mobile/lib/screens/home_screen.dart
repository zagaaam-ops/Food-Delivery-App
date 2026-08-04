import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Pakistan Delivery', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.shopping_cart, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome back!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8),
            const Text('What would you like to order today?', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 24),
            
            // Mock Restaurant Card 1
            _buildRestaurantCard('Biryani House', '4.5 ★ • 30-45 min • Free Delivery', 'assets/fonts/NotoNastaliqUrdu-Regular.ttf'),
            const SizedBox(height: 16),
            
            // Mock Restaurant Card 2
            _buildRestaurantCard('Karachi BBQ', '4.8 ★ • 20-35 min • Rs 50 Delivery', 'assets/fonts/NotoNastaliqUrdu-Regular.ttf'),
            const SizedBox(height: 16),
            
            // Mock Restaurant Card 3
            _buildRestaurantCard('Lahori Charga', '4.2 ★ • 40-50 min • Free Delivery', 'assets/fonts/NotoNastaliqUrdu-Regular.ttf'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.orange,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildRestaurantCard(String name, String details, String font) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(color: Colors.orange[100], borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.restaurant, color: Colors.orange, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(details, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
