import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class MenuScreen extends StatefulWidget {
  final String restaurantName;
  final String restaurantId;

  const MenuScreen({
    super.key,
    required this.restaurantName,
    required this.restaurantId,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<Map<String, dynamic>> _menuItems = [
    {'id': '1', 'name': 'Chicken Biryani', 'price': 450, 'description': 'Fragrant rice with spiced chicken', 'category': 'Main'},
    {'id': '2', 'name': 'Mutton Karahi', 'price': 850, 'description': 'Traditional karahi with tender mutton', 'category': 'Main'},
    {'id': '3', 'name': 'Garlic Naan', 'price': 120, 'description': 'Fresh baked naan with garlic butter', 'category': 'Bread'},
    {'id': '4', 'name': 'Cold Drink', 'price': 80, 'description': 'Refreshing beverage', 'category': 'Drinks'},
    {'id': '5', 'name': 'Chicken Tikka', 'price': 350, 'description': 'Grilled chicken with spices', 'category': 'Appetizer'},
    {'id': '6', 'name': 'Kulfi', 'price': 180, 'description': 'Traditional Pakistani ice cream', 'category': 'Dessert'},
  ];

  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Main', 'Bread', 'Appetizer', 'Drinks', 'Dessert'];

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    
    List<Map<String, dynamic>> filteredItems = _menuItems;
    if (_selectedCategory != 'All') {
      filteredItems = _menuItems.where((item) => item['category'] == _selectedCategory).toList();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context), // 👈 Back button
        ),
        title: Text(widget.restaurantName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartScreen()),
                      );
                    },
                  ),
                  if (cart.itemCount > 0)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                String category = _categories[index];
                bool isSelected = category == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = category),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.orange : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Menu Items List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                var item = filteredItems[index];
                return _buildMenuItem(item, cartProvider);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item, CartProvider cartProvider) {
    bool isInCart = cartProvider.items.any((i) => i.id == item['id']);
    
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
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getIconForCategory(item['category']),
              color: Colors.orange,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  item['description'],
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rs ${item['price']}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (isInCart) {
                cartProvider.removeItem(item['id']);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item['name']} removed from cart')),
                );
              } else {
                cartProvider.addItem(
                  CartItem(
                    id: item['id'],
                    name: item['name'],
                    price: item['price'].toDouble(),
                    restaurantId: widget.restaurantId,
                    restaurantName: widget.restaurantName,
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item['name']} added to cart!')),
                );
              }
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isInCart ? Colors.red : Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(isInCart ? 'Remove' : 'Add'),
          ),
        ],
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Main': return Icons.restaurant;
      case 'Bread': return Icons.bakery_dining;
      case 'Appetizer': return Icons.fastfood;
      case 'Drinks': return Icons.local_drink;
      case 'Dessert': return Icons.icecream;
      default: return Icons.restaurant_menu;
    }
  }
}
