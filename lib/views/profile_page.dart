import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:soundscape/service/auth_service.dart';
import 'package:soundscape/views/userprofile_page.dart';
import 'package:soundscape/widgets/navbar.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              // child: Image.asset('assets/images/main logo.png', height: 40),
              child: CachedNetworkImage(
                imageUrl:
                    'https://i.ibb.co/7vZ3bJt/main-logo.png', // Replace with actual image path
                height: 40,
              ),
            ),
            const Center(
              child: Text('Profile', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture and Name
            const Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                      'assets/images/profile_picture.png'), // Replace with actual image path
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Username',
                        style: TextStyle(color: Colors.white, fontSize: 24)),
                    Text('Bio', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Profile Options
            Expanded(
              child: ListView(
                children: [
                  // editing user profiles
                  _buildProfileOption('Edit Profile', Icons.edit, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserProfilePage(),
                        ));
                  }),
                  _buildProfileOption('My Uploads', Icons.upload,
                      () {}), // its for beats ( show all the users beats )
                  _buildProfileOption('Settings', Icons.settings, () {}),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(
        currentIndex: 4,
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildProfileOption(String title, IconData icon, Function()? onTap) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
          onTap: onTap,
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
        ),
      ],
    );
  }
}
