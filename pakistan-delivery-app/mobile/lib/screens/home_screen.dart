import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../providers/cart_provider.dart';
import '../localization/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const OrdersScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: loc.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: loc.orders,
          ),
          NavigationDestination(
            icon: const Icon(Icons.shopping_cart_outlined),
            selectedIcon: const Icon(Icons.shopping_cart),
            label: loc.cart,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: loc.profile,
          ),
        ],
      ),
    );
  }
}

// Home Tab - Store Listing
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              loc.appName,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.green.shade700,
                    Colors.green.shade900,
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.delivery_dining,
                  size: 100,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.language),
              onPressed: () {
                final langProvider = Provider.of<LanguageProvider>(context, listen: false);
                langProvider.toggleLanguage();
              },
            ),
          ],
        ),
        
        // Search Bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: loc.searchStores,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
            ),
          ),
        ),
        
        // Categories
        SliverToBoxAdapter(
          child: SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _categoryChip(loc.grocery, Icons.shopping_bag),
                _categoryChip(loc.restaurant, Icons.restaurant),
                _categoryChip(loc.pharmacy, Icons.local_pharmacy),
                _categoryChip(loc.bakery, Icons.cake),
                _categoryChip(loc.food, Icons.fastfood),
              ],
            ),
          ),
        ),
        
        const SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
        
        // Stores Grid
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _storeCard(context, index),
              childCount: 6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _categoryChip(String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: Colors.green.shade700),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: Colors.green.shade700)),
        ],
      ),
    );
  }

  Widget _storeCard(BuildContext context, int index) {
    final loc = AppLocalizations.of(context);
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Icon(Icons.store, size: 50, color: Colors.grey.shade500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Store ${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    Text(' 4.${index + 2}'),
                    const Spacer(),
                    Text('30-45 min', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Orders Screen
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(title: Text(loc.myOrders)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(loc.noData, style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}

// Cart Screen
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final cartProvider = Provider.of<CartProvider>(context);
    
    if (cartProvider.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(loc.cart)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(loc.noData, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(title: Text(loc.cart)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final item = cartProvider.items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('PKR ${item.price.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => cartProvider.decrementQuantity(item.id),
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => cartProvider.incrementQuantity(item.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(loc.total, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('PKR ${cartProvider.total.toStringAsFixed(2)}', 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to checkout
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(loc.checkout.toUpperCase()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Profile Screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(title: Text(loc.profile)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 16),
          Text(
            authProvider.user?['name'] ?? 'User',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            authProvider.user?['phone'] ?? '',
            style: TextStyle(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _profileTile(loc.settings, Icons.settings),
          _profileTile(loc.language, Icons.language, 
            onTap: () {
              final langProvider = Provider.of<LanguageProvider>(context, listen: false);
              langProvider.toggleLanguage();
            }),
          _profileTile(loc.helpSupport, Icons.help_outline),
          _profileTile(loc.about, Icons.info_outline),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(loc.logout, style: const TextStyle(color: Colors.red)),
            onTap: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          const SizedBox(height: 32),
          Text(
            loc.madeInPakistan,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _profileTile(String title, IconData icon, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
