import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:soundscape/models/beat_model.dart';
import 'package:soundscape/models/user_model.dart';
import 'package:soundscape/service/firestore_service.dart';
import 'package:soundscape/views/singlebeat_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: const Text('Favorites',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        centerTitle: true,
      ),
      body: StreamBuilder<UserModel>(
        stream: getUser(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.likedBeatsId.isEmpty) {
            return const Center(
                child: Text('No favorite beats yet.',
                    style: TextStyle(color: Colors.white)));
          }

          List<String> favoriteBeats = snapshot.data!.likedBeatsId;
          return ListView.builder(
            itemCount: favoriteBeats.length,
            itemBuilder: (context, index) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('beats')
                    .doc(favoriteBeats[index])
                    .get(),
                builder: (context, beatSnapshot) {
                  if (beatSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                        title: Text('Loading...',
                            style: TextStyle(color: Colors.grey)));
                  }
                  if (beatSnapshot.hasError) {
                    debugPrint('Error: ${beatSnapshot.error}');
                    return const SizedBox.shrink();
                  }
                  if (!beatSnapshot.hasData || !beatSnapshot.data!.exists) {
                    return const SizedBox.shrink();
                  }

                  Beat beat = Beat.fromJson(
                      beatSnapshot.data!.data() as Map<String, dynamic>);
                  return _buildListItem(context, beat);
                },
              );
            },
          );
        },
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildListItem(BuildContext context, Beat beat) {
    return Column(
      children: [
        Card(
          color: Colors.black,
          child: ListTile(
            leading: CachedNetworkImage(
              imageUrl: beat.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Icon(Icons.music_note, size: 70, color: Colors.grey),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, size: 70, color: Colors.red),
            ),
            title: Text(
              beat.title,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'by ${beat.artist}',
                  style: const TextStyle(color: Colors.grey),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${beat.genre} ${beat.bpm} BPM',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.red, size: 20),
                        SizedBox(width: 4),
                        Text(
                          'Favorited',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SingleBeatPage(beat: beat),
                ),
              );
            },
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
