import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:soundscape/service/auth_service.dart';

class StorageService {
  // mainly for profile picture
  // and beat cover image
  Future<String> uploadFile(File file) async {
    AuthService auth = AuthService();
    final userId = await auth.currentUser().then((value) => value!.uid);
    final storageRef = FirebaseStorage.instance.ref();
    final fileName = file.path.split("/").last;
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final uploadRef = storageRef.child("$userId/uploads/$timestamp-$fileName");
    final result = await uploadRef.putFile(file);
    return await result.ref.getDownloadURL();
  }

  // Future<void> downloadFile() async {}

  Future<void> getFileUrl() async {}

  Future<void> deleteFile() async {}
}
