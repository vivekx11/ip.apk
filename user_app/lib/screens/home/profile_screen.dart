import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/user_provider.dart';
import '../../services/simple_auth_service.dart';
import '../auth/simple_login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppTheme.primaryPink,
        foregroundColor: AppTheme.white,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Container(
                  width: double.infinity,
                  color: AppTheme.primaryPink,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: AppTheme.primaryPink,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userProvider.username ?? 'Welcome User!',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.white,
                        ),
                      ),
                      const Text(
                        'Local Marketplace Customer',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.white,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Profile Options
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildProfileOption(
                        icon: Icons.person_outline,
                        title: 'Change Name',
                        onTap: () {
                          _showEditNameDialog(context, userProvider);
                        },
                      ),
                      _buildProfileOption(
                        icon: Icons.location_on_outlined,
                        title: 'Manage Addresses',
                        onTap: () {
                          // TODO: Navigate to addresses
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Feature coming soon!')),
                          );
                        },
                      ),
                      _buildProfileOption(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        onTap: () {
                          // TODO: Navigate to notifications settings
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Feature coming soon!')),
                          );
                        },
                      ),
                      _buildProfileOption(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        onTap: () {
                          // TODO: Navigate to help
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
                          _showLogoutDialog(context, userProvider);
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

  void _showLogoutDialog(BuildContext context, UserProvider userProvider) {
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
                    builder: (context) => const SimpleLoginScreen(),
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

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryPink),
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

  void _showEditNameDialog(BuildContext context, UserProvider userProvider) {
    final nameController = TextEditingController(text: userProvider.username ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Name'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Your Name',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameController.text.trim();
              if (newName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Name cannot be empty'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                await userProvider.saveUsername(newName);
                
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Name updated successfully'),
                      backgroundColor: AppTheme.primaryPink,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update name: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
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
            Text('Local Marketplace v1.0.0'),
            SizedBox(height: 16),
            Text('A local marketplace app for customers to browse and purchase from local shops.'),
            SizedBox(height: 16),
            Text('No login required - just enter your name and start shopping!'),
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
}