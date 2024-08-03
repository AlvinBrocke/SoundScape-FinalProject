import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soundscape/models/review_model.dart';
import 'package:soundscape/service/auth_service.dart';
import 'package:soundscape/service/firestore_service.dart';
import '../models/beat_model.dart';
import '../models/comment_model.dart'; // Adjust the import to the correct location

class SingleBeatPage extends StatelessWidget {
  final Beat beat;

  const SingleBeatPage({
    super.key,
    required this.beat,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    final query = FirebaseFirestore.instance
        .collection("beats")
        .doc(beat.beatId)
        .collection("reviews")
        .orderBy("timestamp", descending: true);

    Query<ReviewModel> collection = query.withConverter<ReviewModel>(
      fromFirestore: (snapshot, _) => ReviewModel.fromJson(snapshot.data()!),
      toFirestore: (review, _) => review.toJson(),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: Text(
          beat.title,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          // TODO: Implement favorite functionality
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              // Implement favorite functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image
            // add cover image later kraaa ( Container plus Cached network image )
            beat.imageUrl.isEmpty
                ? const Column(
                    children: [
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 60,
                          ),
                        ],
                      ),
                    ],
                  )
                : CachedNetworkImage(
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

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Artist
                  Text(
                    beat.title,
                    style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'by ${beat.artist}',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  // Genre and BPM
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Genre: ${beat.genre}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'BPM: ${beat.bpm}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Key and Release Date
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Key: ${beat.key}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Release Date: ${beat.releaseDate}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Description
                  Text(
                    beat.description,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  // Comment Section
                  const Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Add comment input field
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () async {
                          if (controller.text.trim().isEmpty) {
                            return;
                          } else {
                            try {
                              AuthService authService = AuthService();
                              // Implement send comment functionality
                              final review = ReviewModel(
                                reviewId: '',
                                beatId: beat.beatId,
                                userId: authService
                                    .currentUser()
                                    .then((value) => value!.uid)
                                    .toString(),
                                timestamp: Timestamp.now(),
                                comment: controller.text,
                                imageUrl: authService
                                    .currentUser()
                                    .then((value) => value!.photoURL)
                                    .toString(),
                                username: authService
                                    .currentUser()
                                    .then((value) => value!.displayName)
                                    .toString(),
                              );

                              final result = addReview(review, beat.beatId);
                              String resultId =
                                  result.then((value) => value.id).toString();

                              updateReviewId(beat.beatId, resultId);

                              // updating the id

                              controller.clear();
                            } catch (e) {
                              debugPrint(e.toString());
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    'An error occurred. Please try again.',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                              controller.clear();
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // List of comments (you can replace this with a ListView.builder for dynamic comments)

                  FirestoreListView<ReviewModel>(
                    query: collection,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, reviews) {
                      if (reviews.exists == false) {
                        return const Center(
                          child: Text(
                            "No comments can be found.",
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      return Comment(
                        imageUrl: reviews.data().imageUrl,
                        username: reviews.data().username,
                        comment: reviews.data().comment,
                        timestamp: reviews.data().timestamp,
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        // model to show all the comment, user should also be able to add to comments
                        showMaterialModalBottomSheet(
                          expand: true,
                          bounce: true,
                          context: context,
                          builder: (context) {
                            return SafeArea(
                              child: Container(
                                color: Colors.black,
                                child: CommentList(beat: beat),
                              ),
                            );
                          },
                        );
                      },
                      label: const Text(
                        'View all comments',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}

class CommentList extends StatefulWidget {
  final Beat beat;
  const CommentList({super.key, required this.beat});

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  Widget build(BuildContext context) {
    TextEditingController commentController = TextEditingController();
    final query = FirebaseFirestore.instance
        .collection("beats")
        .doc(widget.beat.beatId)
        .collection("reviews")
        .orderBy("timestamp", descending: true);
    Query<ReviewModel> collection = query.withConverter<ReviewModel>(
      fromFirestore: (snapshot, _) => ReviewModel.fromJson(snapshot.data()!),
      toFirestore: (review, _) => review.toJson(),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Comments',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          // Add comment input field
          TextField(
            controller: commentController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Add a comment...',
              hintStyle: TextStyle(color: Colors.grey[600]),
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () async {
                  if (commentController.text.trim().isEmpty) {
                    return;
                  } else {
                    try {
                      AuthService authService = AuthService();
                      // Implement send comment functionality
                      final review = ReviewModel(
                        reviewId: '',
                        beatId: widget.beat.beatId,
                        userId: authService
                            .currentUser()
                            .then((value) => value!.uid)
                            .toString(),
                        timestamp: Timestamp.now(),
                        comment: commentController.text,
                        imageUrl: authService
                            .currentUser()
                            .then((value) => value!.photoURL)
                            .toString(),
                        username: authService
                            .currentUser()
                            .then((value) => value!.displayName)
                            .toString(),
                      );

                      final result = addReview(review, widget.beat.beatId);
                      String resultId =
                          result.then((value) => value.id).toString();

                      updateReviewId(widget.beat.beatId, resultId);

                      // updating the id

                      commentController.clear();
                    } catch (e) {
                      debugPrint(e.toString());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'An error occurred. Please try again.',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                      commentController.clear();
                    }
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          // List of comments (you can replace this with a ListView.builder for dynamic comments)
          FirestoreListView<ReviewModel>(
            query: collection,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, reviews) {
              if (!reviews.exists) {
                return const Center(
                  child: Text(
                    'No comments can be found.',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }
              return Comment(
                imageUrl: reviews.data().imageUrl,
                username: reviews.data().username,
                comment: reviews.data().comment,
                timestamp: reviews.data().timestamp,
              );
            },
          ),
        ],
      ),
    );
  }
}
