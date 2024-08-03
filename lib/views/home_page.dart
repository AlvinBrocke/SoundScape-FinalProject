import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soundscape/models/user_model.dart';
import 'package:soundscape/service/firestore_service.dart';
import 'package:soundscape/views/Simple_player.dart';
import 'package:soundscape/views/account_settings.dart';
import 'package:soundscape/views/singlebeat_page.dart';
import 'package:soundscape/widgets/LikedButton.dart';
import '/models/beat_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection('beats')
        .orderBy('timestamp')
        .limit(5);

    final allBeats = FirebaseFirestore.instance.collection('beats');
    Query<Beat> collection = query.withConverter<Beat>(
      fromFirestore: (snapshot, _) => Beat.fromJson(snapshot.data()!),
      toFirestore: (beat, _) => beat.toJson(),
    );

    CollectionReference<Beat> allBeatsCollection = allBeats.withConverter<Beat>(
      fromFirestore: (snapshot, _) => Beat.fromJson(snapshot.data()!),
      toFirestore: (beat, _) => beat.toJson(),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset('assets/images/main logo.png', height: 40),
            ),
            const Center(
              child: Text('Home',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    onPressed: () {
                      // Handle notifications
                    },
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/album1.jpg'),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AccountSettings(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 130,
              child: FirestoreListView<Beat>(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                query: collection,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      'An error occurred: $error',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
                itemBuilder: (context, beat) {
                  if (!beat.exists) {
                    return const Text(
                      "No beats found",
                      style: TextStyle(color: Colors.red),
                    );
                  }
                  return _buildRecentActivityItem(context, beat.data());
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Activity Feed',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            FirestoreListView<Beat>(
              shrinkWrap: true,
              query: allBeatsCollection,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Text(
                    'An error occurred: $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              },
              itemBuilder: (context, beat) {
                if (!beat.exists) {
                  return const Text(
                    "No beats found",
                    style: TextStyle(color: Colors.red),
                  );
                }
                return _buildActivityFeedItem(beat.data());
              },
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF121212),
    );
  }

  Widget _buildRecentActivityItem(BuildContext context, Beat beat) {
    return Container(
      width: 150,
      height: 200,
      margin: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleBeatPage(beat: beat),
            ),
          );
        },
        child: Container(
          color: const Color(0xFF121212),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                beat.imageUrl.isEmpty
                    ? const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 60,
                      )
                    : CachedNetworkImage(
                        height: 50,
                        imageUrl: beat.imageUrl,
                        placeholder: (context, url) => const Icon(
                          Icons.camera_alt,
                          size: 60,
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.camera_alt,
                          size: 60,
                        ),
                      ),
                const SizedBox(height: 8.0),
                Text(
                  beat.title,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  beat.artist,
                  style: const TextStyle(color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityFeedItem(Beat beat) {
    void toggleLike(Beat beat, UserModel currentUser, bool isLiked) async {
      try {
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('users').doc(currentUser.id);
        DocumentReference beatRef =
            FirebaseFirestore.instance.collection('beats').doc(beat.beatId);

        if (isLiked) {
          // Unlike the beat
          await userRef.update({
            'likedBeats': FieldValue.arrayRemove([beat.beatId])
          });
          await beatRef.update({'likes': FieldValue.increment(-1)});
        } else {
          // Like the beat
          await userRef.update({
            'likedBeats': FieldValue.arrayUnion([beat.beatId])
          });
          await beatRef.update({'likes': FieldValue.increment(1)});
        }
      } catch (e) {
        if (context.mounted) {
          print('Error toggling like: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('An error occurred while liking/unliking the beat',
                  style: TextStyle(color: Colors.white)),
            ),
          );
        }
      }
    }

    return Column(
      children: [
        Container(
          color: const Color(0xFF121212),
          child: Column(
            children: [
              ListTile(
                leading: CachedNetworkImage(
                  imageUrl: beat.imageUrl,
                  placeholder: (context, url) => const Icon(
                    Icons.camera_alt,
                    size: 60,
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.camera_alt,
                    size: 60,
                  ),
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
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SimplePlayer(beat: beat),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder<UserModel>(
                    stream: getUser(FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Icon(Icons.favorite_border,
                            color: Colors.grey);
                      }

                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }

                      UserModel user = snapshot.data!;

                      bool isLiked = user.likedBeatsId.contains(beat.beatId);
                      return Likedbutton(
                          isLiked: isLiked,
                          onTap: () => toggleLike(beat, user, isLiked));
                    },
                  ),
                  FirebaseAuth.instance.currentUser!.uid != beat.userId
                      ? const SizedBox.shrink()
                      : IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text('Delete Beat'),
                                      content: const Text(
                                          'Are you sure you want to delete this beat?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            try {
                                              FirebaseFirestore.instance
                                                  .collection('beats')
                                                  .doc(beat.beatId)
                                                  .delete();
                                              Navigator.pop(context);
                                              FirebaseStorage.instance
                                                  .refFromURL(beat.imageUrl)
                                                  .delete();
                                            } catch (e) {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Text(
                                                        'An error occurred while deleting the beat',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )));
                                            }
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ));
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                ],
              ),
            ],
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
