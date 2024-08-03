class UserModel {
  final String username;
  final String email;
  final String url;
  final String id;
  final List<String> beatsId;
  final List<String> likedBeatsId;

  UserModel(
      {required this.username,
      required this.email,
      required this.url,
      required this.beatsId,
      required this.likedBeatsId,
      required this.id});

  UserModel.fromJson(Map<String, dynamic> json)
      : this(
          username: json['name'].toString(),
          email: json['email'].toString(),
          url: json['url'].toString(),
          id: json['id'].toString(),
          beatsId: json['beatsId'],
          likedBeatsId: json['likedBeatsId'],
        );

  Map<String, dynamic> toJson() {
    return {
      'name': username,
      'email': email,
      'url': url,
      'id': id,
      'beatsId': beatsId,
      'likedBeatsId': likedBeatsId,
    };
  }
}
