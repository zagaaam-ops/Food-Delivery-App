import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../localization/app_localizations.dart';

class SupplierRegisterScreen extends StatefulWidget {
  const SupplierRegisterScreen({super.key});

  @override
  State<SupplierRegisterScreen> createState() => _SupplierRegisterScreenState();
}

class _SupplierRegisterScreenState extends State<SupplierRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Personal Info Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Store Info Controllers
  final _storeNameController = TextEditingController();
  final _streetController = TextEditingController();
  final _areaController = TextEditingController();
  
  String _selectedCity = 'Karachi';
  String _selectedCategory = 'grocery';
  bool _isLoading = false;

  final List<String> _cities = [
    'Karachi', 'Lahore', 'Islamabad', 'Rawalpindi', 
    'Faisalabad', 'Multan', 'Peshawar', 'Quetta'
  ];

  final List<String> _categories = [
    'grocery', 'restaurant', 'supermarket', 'pharmacy', 'bakery', 'other'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _storeNameController.dispose();
    _streetController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _registerSupplier() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Call API to register supplier
      // POST /api/stores/supplier/register
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Supplier registration successful! Please login.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Register as Supplier'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.storefront, size: 60, color: Colors.green.shade700),
                      const SizedBox(height: 8),
                      Text(
                        'Start Your Business',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Register your store and sell products online',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Personal Information Section
              Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(Icons.phone),
                  hintText: '03XXXXXXXXX',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  if (!RegExp(r'^03\d{9}$').hasMatch(value)) {
                    return 'Enter valid Pakistani phone (03XXXXXXXXX)';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email (Optional)',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Store Information Section
              Text(
                'Store Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _storeNameController,
                decoration: InputDecoration(
                  labelText: 'Store Name',
                  prefixIcon: const Icon(Icons.store),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter store name';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 12),
              
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Store Category',
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value!);
                },
              ),
              
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _streetController,
                decoration: InputDecoration(
                  labelText: 'Street Address',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter street address';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _areaController,
                decoration: InputDecoration(
                  labelText: 'Area/Locality',
                  prefixIcon: const Icon(Icons.map),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter area';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 12),
              
              DropdownButtonFormField<String>(
                value: _selectedCity,
                decoration: InputDecoration(
                  labelText: 'City',
                  prefixIcon: const Icon(Icons.location_city),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _cities.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCity = value!);
                },
              ),
              
              const SizedBox(height: 32),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _registerSupplier,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'REGISTER STORE',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Login Link
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Already have a store? Login here'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
