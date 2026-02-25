import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/shop_provider.dart';
import '../../services/simple_auth_service.dart';
import '../../services/google_auth_service.dart';
import '../auth/phone_login_screen.dart';
import '../location/shop_location_setup_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: AppTheme.primaryIndigo,
        foregroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: Consumer<ShopProvider>(
        builder: (context, shopProvider, child) {
          final shop = shopProvider.currentShop;
          final googleAuthService = GoogleAuthService();
          final currentOwner = googleAuthService.currentOwner;
          final googleAccount = googleAuthService.googleAccount;
          final userEmail = currentOwner?.email ?? shop?['phone'] ?? 'No email';

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header with Gradient
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryIndigo,
                        AppTheme.primaryIndigo.withOpacity(0.85),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Avatar with Shadow
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: googleAccount?.photoUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(35),
                                child: Image.network(
                                  googleAccount!.photoUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.store_outlined,
                                      size: 34,
                                      color: AppTheme.primaryIndigo,
                                    );
                                  },
                                ),
                              )
                            : (shop?['imageUrl'] != null && shop!['imageUrl'].isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(35),
                                    child: Image.network(
                                      shop['imageUrl'],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.store_outlined,
                                          size: 34,
                                          color: AppTheme.primaryIndigo,
                                        );
                                      },
                                    ),
                                  )
                                : const Icon(
                                    Icons.store_outlined,
                                    size: 34,
                                    color: AppTheme.primaryIndigo,
                                  )),
                      ),
                      const SizedBox(width: 18),
                      // Welcome Text and Email
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome',
                              style: TextStyle(
                                fontSize: 15,
                                color: AppTheme.white.withOpacity(0.9),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              userEmail,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            if (shop != null)
                              Row(
                                children: [
                                  Icon(Icons.store, size: 14, color: AppTheme.white.withOpacity(0.9)),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      shop['name'] ?? 'Shop Owner',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.white.withOpacity(0.9),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                            else
                              Text(
                                'Shop Owner',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.white.withOpacity(0.9),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Shop Information
                if (shop != null)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Shop Information',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          icon: Icons.store_outlined,
                          title: 'Shop Name',
                          value: shop['name'] ?? 'N/A',
                        ),
                        _buildInfoCard(
                          icon: Icons.category_outlined,
                          title: 'Category',
                          value: shop['category'] ?? 'N/A',
                        ),
                        _buildInfoCard(
                          icon: Icons.location_on_outlined,
                          title: 'Address',
                          value: shop['address'] ?? 'N/A',
                        ),
                        _buildInfoCard(
                          icon: Icons.phone_outlined,
                          title: 'Phone',
                          value: shop['phone'] ?? 'N/A',
                        ),
                        _buildInfoCard(
                          icon: Icons.description_outlined,
                          title: 'Description',
                          value: shop['description'] ?? 'N/A',
                        ),
                        _buildInfoCard(
                          icon: Icons.star_outline,
                          title: 'Rating',
                          value: '${shop['rating'] ?? 0.0} / 5.0',
                        ),
                        _buildInfoCard(
                          icon: Icons.toggle_on_outlined,
                          title: 'Status',
                          value: (shop['isActive'] ?? false) ? 'Active' : 'Inactive',
                          valueColor: (shop['isActive'] ?? false) 
                              ? AppTheme.successGreen 
                              : Colors.red,
                        ),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppTheme.lightIndigo.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: const Icon(
                              Icons.store_outlined,
                              size: 64,
                              color: AppTheme.lightIndigo,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'No Shop Registered',
                            style: TextStyle(
                              fontSize: 19,
                              color: Color(0xFF1A1A1A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Please register your shop to continue',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Profile Options
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (shop != null) ...[
                        _buildProfileOption(
                          icon: Icons.location_on,
                          title: 'Setup Shop Location',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ShopLocationSetupScreen(),
                              ),
                            );
                          },
                        ),
                        _buildProfileOption(
                          icon: Icons.edit,
                          title: 'Edit Shop Details',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Feature coming soon!')),
                            );
                          },
                        ),
                      ],
                      _buildProfileOption(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Feature coming soon!')),
                          );
                        },
                      ),
                      _buildProfileOption(
                        icon: Icons.info_outline,
                        title: 'About',
                        onTap: () {
                          _showAboutDialog(context);
                        },
                      ),
                      _buildProfileOption(
                        icon: Icons.logout,
                        title: 'Logout',
                        onTap: () {
                          _showLogoutDialog(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryIndigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primaryIndigo, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryIndigo.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primaryIndigo, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFF9CA3AF),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shop Owner App v1.0.0'),
            SizedBox(height: 16),
            Text('Manage your shop, products, and orders efficiently.'),
            SizedBox(height: 16),
            Text('Accept orders, update product availability, and track your business performance.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await SimpleAuthService().logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const PhoneLoginScreen(),
                  ),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: AppTheme.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
