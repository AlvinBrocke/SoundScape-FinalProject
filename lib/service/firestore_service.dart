import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soundscape/models/beat_model.dart';
import 'package:soundscape/models/review_model.dart';
import 'package:soundscape/models/user_model.dart';

// adding user to firebase
// user, will be a main collection
// user will contain a list of all their beats
Future<void> addUser(UserModel user) async {
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
  usersRef.add(user.toJson());
}

// adding beats to firestore
// beat will be a main collection
Future<DocumentReference<Object?>> addBeats(Beat beats) async {
  CollectionReference beatsRef = FirebaseFirestore.instance.collection('beats');
  return beatsRef.add(beats.toJson());
}

Stream<UserModel> getUser(String id) {
  DocumentReference usersRef =
      FirebaseFirestore.instance.collection('users').doc(id);
  debugPrint(usersRef.id);
  final result = usersRef.snapshots().map((snapshot) =>
      UserModel.fromJson(snapshot.data() as Map<String, dynamic>));
  return result;
}

updatingBeatsId(String beatId) async {
  CollectionReference beatsRef = FirebaseFirestore.instance.collection('beats');
  return beatsRef.doc(beatId).update({'beatId': beatId});
}

updateReviewId(String beatId, String reviewId) async {
  CollectionReference reviewsRef =
      FirebaseFirestore.instance.collection('beats');
  return reviewsRef.doc(beatId).collection('reviews').doc(reviewId).update(
    {'reviewId': reviewId},
  );
}

// updating users beats array
updateUserArray(String userId, String beatId) async {
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  return userRef.doc(userId).update({
    'beatsId': FieldValue.arrayUnion([beatId])
  });
}

Future<void> addFavorite(String userId, String beatId) async {
  FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('favorites')
      .doc(beatId)
      .set({
    'beatId': beatId,
  });
}

// adding review to user
// will be a subcollection of beats
Future<DocumentReference<Object?>> addReview(
    ReviewModel reviews, String beatId) async {
  CollectionReference reviewsRef = FirebaseFirestore.instance
      .collection('beats')
      .doc(beatId)
      .collection('reviews');
  return await reviewsRef.add(reviews.toJson());
}

// Creating queries for beats and reviews
// will be cached using riverpod
Future<bool> userExist(String id) async {
  return FirebaseFirestore.instance.collection('users').doc(id).get().then(
        (value) => value.exists,
      );
}
