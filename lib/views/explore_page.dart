import 'package:flutter/material.dart';

import '../models/beat_model.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: const Stack(
          children: [
            Center(
              child: Text('Explore',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color.fromARGB(255, 30, 30, 30),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // List of Items
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: 4, // Number of items
            //     itemBuilder: (context, index) {
            //       return _buildListItem(beat6);
            //     },
            //   ),
            // ),
          ],
        ),
      ),
      // bottomNavigationBar: const NavBar(
      //   currentIndex: 1,
      // ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildListItem(Beat beat) {
    return Column(
      children: [
        ListTile(
          leading: Image.asset(beat.imageUrl), // Replace with actual image path
          title: Text(beat.title, style: const TextStyle(color: Colors.white)),
          subtitle:
              Text(beat.artist, style: const TextStyle(color: Colors.grey)),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
        ),
      ],
    );
  }
}
