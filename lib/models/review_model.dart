import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String reviewId;
  final String beatId;
  final String userId;
  final Timestamp timestamp;
  final String comment;
  final String imageUrl;
  final String username;

  ReviewModel({
    required this.reviewId, // id of the review
    required this.beatId, // beats review is assigned to
    required this.userId, // user who commented
    required this.timestamp,
    required this.comment,
    required this.imageUrl,
    required this.username,
  });

  ReviewModel.fromJson(Map<String, Object?> json)
      : this(
          reviewId: json['reviewId'].toString(),
          beatId: json['beatId'].toString(),
          userId: json['userId'].toString(),
          timestamp: json['timestamp'] as Timestamp,
          comment: json['comment'].toString(),
          imageUrl: json['imageUrl'].toString(),
          username: json['username'].toString(),
        );

  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'beatId': beatId,
      'userId': userId,
      'timestamp': timestamp,
      'comment': comment,
      'imageUrl': imageUrl,
      'username': username,
    };
  }
}
