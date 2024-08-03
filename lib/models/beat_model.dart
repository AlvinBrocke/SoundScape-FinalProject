import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class Beat {
  final String beatId;
  final String title;
  final String artist;
  final String genre;
  final String releaseDate;
  final int bpm;
  final String userId;
  final String key;
  final String imageUrl;
  final String description;
  final Timestamp timestamp;
  final String audioUrl; // Added to include audio file (either mp3 or wav)
  final String duration;
  final int likes;

  Beat({
    required this.beatId,
    required this.title,
    required this.duration,
    required this.artist,
    required this.userId,
    required this.genre,
    required this.releaseDate,
    required this.bpm,
    required this.key,
    required this.imageUrl,
    required this.description,
    required this.audioUrl,
    required this.timestamp,
    required this.likes,
  });

  Beat.fromJson(Map<String, Object?> json)
      : this(
          beatId: json['beatId'].toString(),
          likes: int.parse(json['likes'].toString()),
          timestamp: json['timestamp'] as Timestamp,
          title: json['title'].toString(),
          artist: json['artist'].toString(),
          genre: json['genre'].toString(),
          releaseDate: json['releaseDate'].toString(),
          bpm: int.parse(json['bpm'].toString()),
          key: json['key'].toString(),
          imageUrl: json['imageUrl'].toString(),
          description: json['description'].toString(),
          audioUrl: json['audioUrl'].toString(),
          duration: json['duration'].toString(),
          userId: json['userId'].toString(),
        );

  Map<String, dynamic> toJson() {
    return {
      'likes': likes,
      'beatId': beatId,
      'timestamp': timestamp,
      'title': title,
      'artist': artist,
      'genre': genre,
      'releaseDate': releaseDate,
      'bpm': bpm,
      'key': key,
      'imageUrl': imageUrl,
      'description': description,
      'audioUrl': audioUrl,
      'duration': duration,
      'userId': userId,
    };
  }
}
