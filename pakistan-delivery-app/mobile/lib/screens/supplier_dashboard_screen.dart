import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../localization/app_localizations.dart';

class SupplierDashboardScreen extends StatefulWidget {
  const SupplierDashboardScreen({super.key});

  @override
  State<SupplierDashboardScreen> createState() => _SupplierDashboardScreenState();
}

class _SupplierDashboardScreenState extends State<SupplierDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const SupplierProductsScreen(),
    const SupplierOrdersScreen(),
    const SupplierProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplier Dashboard'),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              // Navigate to add product screen
              _showAddProductDialog();
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Products',
          ),
          const NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => AddProductDialog(),
    );
  }
}

// Products Management Screen
class SupplierProductsScreen extends StatelessWidget {
  const SupplierProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    // Sample products - In real app, fetch from API
    final products = [
      {'name': 'Basmati Rice', 'nameUrdu': 'باسمتی چاول', 'price': 250, 'stock': 100, 'category': 'grocery'},
      {'name': 'Sugar', 'nameUrdu': 'چینی', 'price': 120, 'stock': 50, 'category': 'grocery'},
      {'name': 'Flour', 'nameUrdu': 'آٹا', 'price': 90, 'stock': 200, 'category': 'grocery'},
      {'name': 'Cooking Oil', 'nameUrdu': 'کھانا پکانے کا تیل', 'price': 450, 'stock': 30, 'category': 'grocery'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.shopping_bag, color: Colors.grey.shade500),
            ),
            title: Text(product['name'] as String),
            subtitle: Text(
              product['nameUrdu'] as String,
              style: const TextStyle(fontFamily: 'NotoNastaliqUrdu'),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'PKR ${product['price']}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
                Text(
                  'Stock: ${product['stock']}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            onTap: () {
              // Navigate to edit product
            },
          ),
        );
      },
    );
  }
}

// Orders Management Screen
class SupplierOrdersScreen extends StatelessWidget {
  const SupplierOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    // Sample orders - In real app, fetch from API
    final orders = [
      {'id': '#ORD001', 'customer': 'Ahmed Khan', 'items': 3, 'total': 1250, 'status': 'pending'},
      {'id': '#ORD002', 'customer': 'Fatima Ali', 'items': 5, 'total': 2100, 'status': 'confirmed'},
      {'id': '#ORD003', 'customer': 'Hassan Raza', 'items': 2, 'total': 680, 'status': 'delivered'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final statusColor = order['status'] == 'pending' 
            ? Colors.orange 
            : order['status'] == 'confirmed' 
                ? Colors.blue 
                : Colors.green;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order['id'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        (order['status'] as String).toUpperCase(),
                        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Customer: ${order['customer']}'),
                Text('Items: ${order['items']} | Total: PKR ${order['total']}'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (order['status'] == 'pending')
                      ElevatedButton(
                        onPressed: () {
                          // Confirm order
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(100, 36),
                        ),
                        child: const Text('CONFIRM'),
                      ),
                    if (order['status'] == 'pending')
                      const SizedBox(width: 8),
                    if (order['status'] == 'pending')
                      OutlinedButton(
                        onPressed: () {
                          // Reject order
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          minimumSize: const Size(100, 36),
                        ),
                        child: const Text('REJECT'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Supplier Profile Screen
class SupplierProfileScreen extends StatelessWidget {
  const SupplierProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CircleAvatar(
          radius: 50,
          child: Icon(Icons.storefront, size: 50),
        ),
        const SizedBox(height: 16),
        const Text(
          'Ali General Store',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          'Owner: Ali Khan',
          style: TextStyle(color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        
        // Store Stats
        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(Icons.inventory_2, color: Colors.green, size: 30),
                      const SizedBox(height: 8),
                      Text('24', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Products', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(Icons.shopping_cart, color: Colors.blue, size: 30),
                      const SizedBox(height: 8),
                      Text('156', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Orders', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Menu Items
        ListTile(
          leading: const Icon(Icons.add_circle, color: Colors.green),
          title: const Text('Add New Product'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to add product
          },
        ),
        ListTile(
          leading: const Icon(Icons.edit, color: Colors.blue),
          title: const Text('Edit Store Information'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to edit store
          },
        ),
        ListTile(
          leading: const Icon(Icons.analytics, color: Colors.purple),
          title: const Text('View Sales Report'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to analytics
          },
        ),
        const Divider(height: 32),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Logout', style: TextStyle(color: Colors.red)),
          onTap: () {
            // Logout logic
          },
        ),
      ],
    );
  }
}

// Add Product Dialog
class AddProductDialog extends StatefulWidget {
  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nameUrduController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  
  String _selectedCategory = 'grocery';
  String _selectedUnit = 'kg';

  @override
  void dispose() {
    _nameController.dispose();
    _nameUrduController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Product'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name (English)'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameUrduController,
                decoration: const InputDecoration(labelText: 'Product Name (Urdu)'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: ['grocery', 'vegetables', 'fruits', 'dairy', 'bakery']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.toUpperCase())))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price (PKR)'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedUnit,
                      decoration: const InputDecoration(labelText: 'Unit'),
                      items: ['kg', 'g', 'liter', 'ml', 'piece', 'dozen']
                          .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedUnit = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stock Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // TODO: Call API to add product
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product added successfully!')),
              );
            }
          },
          child: const Text('ADD PRODUCT'),
        ),
      ],
    );
  }
}
