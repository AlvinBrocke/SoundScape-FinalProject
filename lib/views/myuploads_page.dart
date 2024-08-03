import 'package:flutter/material.dart';

class MyUploadsPage extends StatefulWidget {
  const MyUploadsPage({super.key});
  @override
  _MyUploadsPageState createState() => _MyUploadsPageState();
}

class _MyUploadsPageState extends State<MyUploadsPage> {
  List<String> uploadedBeats = [
    'Beat 1',
    'Beat 2',
    'Beat 3',
    // Add more uploaded beats here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: const Stack(
          children: [
            Center(
              child: Text('My Uploads',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // List of Favorited Beats
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Number of favorited beats
                itemBuilder: (context, index) {
                  return _buildListItem(
                    title: 'Beat Title $index',
                    artist: 'Artist Name $index',
                    imageUrl:
                        'assets/images/album2.jpg', // Replace with actual image path
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: const NavBar(currentIndex: 3,),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildListItem({
    required String title,
    required String artist,
    required String imageUrl,
  }) {
    return Column(
      children: [
        Card(
          color: Colors.black,
          child: ListTile(
            leading: Image.asset(
              imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
            title: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'by $artist',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
        ),
      ],
    );
  }
}
