import 'package:flutter/material.dart';
import 'package:soundscape/service/auth_service.dart';
import 'package:soundscape/views/auth/login_page.dart';
import 'account_settings.dart'; // Adjust the import path as needed
// Adjust the import path as needed

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: const Stack(
          children: [
            Center(
              child: Text('Settings',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar not needed in this page
            // List of Settings
            Expanded(
              child: ListView(
                children: [
                  _buildSettingsItem(
                    'Account',
                    Icons.person,
                    const AccountSettings(),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.red, // Ensuring the icon color stands out
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors
                            .red, // Ensuring text color is visible on dark backgrounds
                      ),
                    ),
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: const NavBar(
      //   currentIndex: 4,
      // ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, Widget page) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => page,
              ),
            );
          },
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900], // Dark background for the dialog
          title: const Text(
            'Logout',
            style: TextStyle(
                color: Colors.white), // Light color for the title text
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(
                color: Colors.white), // Light color for the content text
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.blueGrey), // Light color for button text
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  AuthService authService = AuthService();
                  await authService.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                    color: Colors.red), // Red color for the logout button
              ),
            ),
          ],
        );
      },
    );
  }
}
