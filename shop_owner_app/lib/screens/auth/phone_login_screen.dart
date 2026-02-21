import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/user_provider.dart';
import '../../providers/shop_provider.dart';
import '../../services/simple_auth_service.dart';
import '../home/main_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ownerNameController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _simpleAuthService = SimpleAuthService();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  
  bool _isLoading = false;
  bool _showForm = false;
  String? _googleEmail;

  @override
  void dispose() {
    _ownerNameController.dispose();
    _shopNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      // Step 1: Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Google Sign-In cancelled');
      }

      print('✅ Google Sign-In successful');
      print('Email: ${googleUser.email}');
      print('Name: ${googleUser.displayName}');
      print('ID: ${googleUser.id}');

      // Check if user already has shop
      final existingShop = await _simpleAuthService.checkExistingShop(googleUser.id);
      
      if (existingShop != null) {
        // User already has shop - direct login
        print('✅ Existing shop found - direct login');
        
        if (!mounted) return;
        
        // Update providers
        Provider.of<UserProvider>(context, listen: false).setUser(existingShop['owner']);
        Provider.of<ShopProvider>(context, listen: false).setShopId(existingShop['shopId']);

        // Navigate to main screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        // New user - show form
        setState(() {
          _showForm = true;
          _googleEmail = googleUser.email;
          if (googleUser.displayName != null) {
            _ownerNameController.text = googleUser.displayName!;
          }
        });
      }
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: AppTheme.errorRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleCreateShop() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    try {
      final googleUser = await _googleSignIn.signInSilently();
      if (googleUser == null) {
        throw Exception('Google session expired. Please sign in again.');
      }

      final ownerName = _ownerNameController.text.trim();
      final shopName = _shopNameController.text.trim();
      final phone = '+91${_phoneController.text.trim()}';
      
      // Create shop with Google account
      final result = await _simpleAuthService.loginWithGoogle(
        googleUser: googleUser,
        ownerName: ownerName,
        shopName: shopName,
        phone: phone,
      );
      
      if (!mounted) return;
      
      // Update providers
      Provider.of<UserProvider>(context, listen: false).setUser(result['owner']);
      Provider.of<ShopProvider>(context, listen: false).setShopId(result['shopId']);

      // Navigate to main screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      
      String errorMessage = e.toString().replaceAll('Exception: ', '');
      if (errorMessage.contains('timeout')) {
        errorMessage = 'Server is taking longer than usual. Please wait and try again.';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppTheme.errorRed,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _showForm ? _buildForm() : _buildGoogleSignIn(),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignIn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Logo/Icon
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppTheme.primaryIndigo.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.store,
            size: 60,
            color: AppTheme.primaryIndigo,
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Title
        const Text(
          'Shop Owner Login',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkGrey,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 8),
        
        const Text(
          'Manage your shop and products',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.mediumGrey,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 64),
        
        // Google Sign-In Button
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _handleGoogleSignIn,
          icon: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.darkGrey),
                  ),
                )
              : Image.asset(
                  'assets/google_logo.png',
                  height: 24,
                  width: 24,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.g_mobiledata, size: 24);
                  },
                ),
          label: Text(
            _isLoading ? 'Signing in...' : 'Continue with Google',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.white,
            foregroundColor: AppTheme.darkGrey,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppTheme.lightGrey, width: 2),
            ),
            elevation: 0,
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Info text
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryIndigo.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppTheme.primaryIndigo, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Sign in with Google to manage your shop',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.darkGrey.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo/Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.primaryIndigo.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.store,
              size: 60,
              color: AppTheme.primaryIndigo,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Title
          const Text(
            'Setup Your Shop',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGrey,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          const Text(
            'Enter your shop details',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.mediumGrey,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Google Email Display
          if (_googleEmail != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryIndigo.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryIndigo.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppTheme.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.email,
                      color: AppTheme.primaryIndigo,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Signed in as',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.mediumGrey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _googleEmail!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
          
          // Owner Name Field
          TextFormField(
            controller: _ownerNameController,
            decoration: InputDecoration(
              labelText: 'Your Name',
              hintText: 'Enter your name',
              prefixIcon: const Icon(Icons.person, color: AppTheme.primaryIndigo),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.lightGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryIndigo, width: 2),
              ),
            ),
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your name';
              }
              if (value.trim().length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // Shop Name Field
          TextFormField(
            controller: _shopNameController,
            decoration: InputDecoration(
              labelText: 'Shop Name',
              hintText: 'Enter your shop name',
              prefixIcon: const Icon(Icons.store, color: AppTheme.primaryIndigo),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.lightGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryIndigo, width: 2),
              ),
            ),
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter shop name';
              }
              if (value.trim().length < 2) {
                return 'Shop name must be at least 2 characters';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // Phone Number Field
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: 'Enter your phone number',
              prefixText: '+91 ',
              prefixIcon: const Icon(Icons.phone, color: AppTheme.primaryIndigo),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.lightGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryIndigo, width: 2),
              ),
            ),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter phone number';
              }
              if (value.trim().length != 10) {
                return 'Phone number must be 10 digits';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 24),
          
          // Create Shop Button
          ElevatedButton(
            onPressed: _isLoading ? null : _handleCreateShop,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryIndigo,
              foregroundColor: AppTheme.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.white),
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Create Shop',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
          ),
          
          const SizedBox(height: 16),
          
          // Back Button
          TextButton(
            onPressed: _isLoading ? null : () {
              setState(() {
                _showForm = false;
                _ownerNameController.clear();
                _shopNameController.clear();
                _phoneController.clear();
              });
            },
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
