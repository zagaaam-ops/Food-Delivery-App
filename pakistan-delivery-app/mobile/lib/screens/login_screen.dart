import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isUrdu = false;
  bool _obscurePassword = true;
  String _errorMessage = '';

  Future<void> _handleLogin() async {
    if (_phoneController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = _isUrdu ? 'براہ کرم تمام فیلڈز پُر کریں' : 'Please fill in all fields';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool success = await authProvider.login(
      _phoneController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const HomeScreen())
      );
    } else {
      setState(() {
        _errorMessage = _isUrdu 
          ? 'غلط فون نمبر یا پاس ورڈ' 
          : 'Invalid phone number or password';
      });
    }
  }

  void _toggleLanguage() {
    setState(() {
      _isUrdu = !_isUrdu;
      _errorMessage = ''; // Clear error on language switch
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Language Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(_isUrdu ? 'EN' : 'اردو', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Switch(
                    value: _isUrdu,
                    onChanged: (value) => _toggleLanguage(),
                    activeColor: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(_isUrdu ? 'اردو' : 'EN', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 40),
              
              const Icon(Icons.restaurant_menu, size: 80, color: Colors.orange),
              const SizedBox(height: 20),
              Text(
                _isUrdu ? 'خوش آمدید!' : 'Welcome Back!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              Text(
                _isUrdu ? 'اپنے اکاؤنٹ میں لاگ ان کریں' : 'Login to your account',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              
              // Error Message
              if (_errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[400], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red[800], fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              
              // Phone Field
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: _isUrdu ? 'فون نمبر' : 'Phone Number',
                  prefixIcon: const Icon(Icons.phone, color: Colors.orange),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.orange), borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              
              // Password Field with Show/Hide
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: _isUrdu ? 'پاس ورڈ' : 'Password',
                  prefixIcon: const Icon(Icons.lock, color: Colors.orange),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.orange), borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 30),
              
              // Login Button
              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(_isUrdu ? 'لاگ ان' : 'Login', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
              Text(
                _isUrdu ? 'پاکستان فوڈ اور گروسری ڈیلیوری' : 'Pakistan Food & Grocery Delivery',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
