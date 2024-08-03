import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:soundscape/models/user_model.dart';
import 'package:soundscape/service/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soundscape/service/firestore_service.dart';
import 'package:soundscape/service/storage_service.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final TextEditingController _usernameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  final String _profileImage = 'assets/images/profile.jpg';
  AuthService authService = AuthService();
  File? _selectedImage;
  bool _updateImgage = false;
  bool saveChanges = false;

  @override
  Widget build(BuildContext context) {
    Future<void> editUsername(String text) async {
      setState(() {
        saveChanges = true;
      });
      if (_usernameController.text.trim().isEmpty) {
        setState(() {
          saveChanges = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Username cannot be empty',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        return;
      }
      try {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .update({'username': text});
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  'Username updated successfully',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        }
        setState(() {
          saveChanges = false;
        });
      } catch (e) {
        setState(() {
          saveChanges = false;
        });
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Error updating username',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
        debugPrint('Error: $e');
      }
    }

    Future<void> updateImage() async {
      setState(() {
        _updateImgage = true;
      });
      StorageService storageService = StorageService();
      DocumentReference users = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);

      try {
        final ImagePicker picker = ImagePicker();

        final XFile? pickedImage = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 50,
        );

        UserModel result =
            await getUser(FirebaseAuth.instance.currentUser!.uid).first;
        if (pickedImage != null) {
          // deleting previous image url
          final storageRef = FirebaseStorage.instance.refFromURL(result.url);
          await storageRef.delete();
          String imageUrl =
              await storageService.uploadFile(File(pickedImage.path));

          users.update({'url': imageUrl});

          setState(() {
            _updateImgage = false;
          });

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  'Image uploaded successfully',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        } else {
          setState(() {
            _updateImgage = false;
          });
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  'No image selected',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        }
      } catch (e) {
        debugPrint('Error: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: const Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('Account Settings',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(_profileImage),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: () {
                        updateImage();
                        // Handle profile picture change
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            TextField(
              enabled: false,
              decoration: InputDecoration(
                labelText: FirebaseAuth.instance.currentUser!.email,
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 40),

            // saves all the changes made
            ElevatedButton(
              onPressed: () async {
                await editUsername(_usernameController.text);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
                // Handle save changes
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
