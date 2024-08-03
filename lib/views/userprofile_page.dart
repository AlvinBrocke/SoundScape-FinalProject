import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Implement additional options
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      FirebaseAuth.instance.currentUser!.photoURL.toString()),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Username
            Text(
              FirebaseAuth.instance.currentUser!.displayName.toString(),
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            // Follow Button
            ElevatedButton(
              onPressed: () {
                // Implement follow functionality
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue, // Background color
                backgroundColor: Colors.white, // Text color
              ),
              child: const Text('+ Follow'),
            ),
            const SizedBox(height: 20),
            // Stats
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // joined date maybe ??
                  // Column(
                  //   children: [
                  //     const Icon(Icons.calendar_today, color: Colors.grey),
                  //     const SizedBox(height: 5),
                  //     Text(
                  //       joinDate,
                  //       style: const TextStyle(color: Colors.grey),
                  //     ),
                  //   ],
                  // ),

                  // total number of beats maybe ??
                  // Column(
                  //   children: [
                  //     const Icon(Icons.music_note, color: Colors.grey),
                  //     const SizedBox(height: 5),
                  //     Text(
                  //       '$numberOfTracks Tracks',
                  //       style: const TextStyle(color: Colors.grey),
                  //     ),
                  //   ],
                  // ),

                  // total number of likes maybe ??
                  // Column(
                  //   children: [
                  //     const Icon(Icons.favorite, color: Colors.grey),
                  //     const SizedBox(height: 5),
                  //     Text(
                  //       '$likes Likes',
                  //       style: const TextStyle(color: Colors.grey),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
