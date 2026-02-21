import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/shop_provider.dart';
import '../../services/simple_auth_service.dart';
import '../../services/google_auth_service.dart';
import '../auth/phone_login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppTheme.primaryIndigo,
        foregroundColor: AppTheme.white,
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
                // Profile Header
                Container(
                  width: double.infinity,
                  color: AppTheme.primaryIndigo,
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Logo - Left Side
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: googleAccount?.photoUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  googleAccount!.photoUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.store,
                                      size: 30,
                                      color: AppTheme.primaryIndigo,
                                    );
                                  },
                                ),
                              )
                            : (shop?['imageUrl'] != null && shop!['imageUrl'].isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.network(
                                      shop['imageUrl'],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.store,
                                          size: 30,
                                          color: AppTheme.primaryIndigo,
                                        );
                                      },
                                    ),
                                  )
                                : const Icon(
                                    Icons.store,
                                    size: 30,
                                    color: AppTheme.primaryIndigo,
                                  )),
                      ),
                      const SizedBox(width: 16),
                      // Welcome Text and Email
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userEmail,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            if (shop != null)
                              Text(
                                shop['name'] ?? 'Shop Owner',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              )
                            else
                              const Text(
                                'Shop Owner',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.white,
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Shop Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkGrey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          icon: Icons.store,
                          title: 'Shop Name',
                          value: shop['name'] ?? 'N/A',
                        ),
                        _buildInfoCard(
                          icon: Icons.category,
                          title: 'Category',
                          value: shop['category'] ?? 'N/A',
                        ),
                        _buildInfoCard(
                          icon: Icons.location_on,
                          title: 'Address',
                          value: shop['address'] ?? 'N/A',
                        ),
                        _buildInfoCard(
                          icon: Icons.phone,
                          title: 'Phone',
                          value: shop['phone'] ?? 'N/A',
                        ),
                        _buildInfoCard(
                          icon: Icons.description,
                          title: 'Description',
                          value: shop['description'] ?? 'N/A',
                        ),
                        _buildInfoCard(
                          icon: Icons.star,
                          title: 'Rating',
                          value: '${shop['rating'] ?? 0.0} / 5.0',
                        ),
                        _buildInfoCard(
                          icon: Icons.toggle_on,
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
                  const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.store_outlined,
                            size: 80,
                            color: AppTheme.lightIndigo,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No Shop Registered',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppTheme.darkGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Please register your shop to continue',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.blueGrey,
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
                      if (shop != null)
                        _buildProfileOption(
                          icon: Icons.edit,
                          title: 'Edit Shop Details',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Feature coming soon!')),
                            );
                          },
                        ),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryIndigo, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.blueGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: valueColor ?? AppTheme.darkGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryIndigo),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.darkGrey,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppTheme.darkGrey,
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
