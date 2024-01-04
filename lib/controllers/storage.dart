import 'dart:io';

import 'package:firebase_sample/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_compress/video_compress.dart';

class CloudStorageController {
  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file;
  }

  Future<String?> uploadImage(File? file, String createdAt) async {
    try {
      // メタデータを設定
      SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg', // ここでファイルのタイプを指定します
      );

      /// Firebase Cloud Storageにアップロード
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('users/$userID/$createdAt')
          .putFile(file!, metadata);

      final snapshot = await storageRef;
      final downloadURL = snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> uploadVideo(File? file, String createdAt) async {
    try {
      String videoPath = file!.path;

      // メタデータを設定
      SettableMetadata metadata = SettableMetadata(
        contentType: 'video/mp4', // ここでファイルのタイプを指定します
      );

      /// Firebase Cloud Storageにアップロード
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('users/$userID/$createdAt')
          .putFile(await _compressVideo(videoPath), metadata);

      final snapshot = await storageRef;
      final downloadURL = snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// 画像の削除
  Future deleteFile(String createdAt) async {
    final storageRef =
        FirebaseStorage.instance.ref().child('users/$userID/$createdAt');

    /// Cloud Storageから削除
    await storageRef.delete();
  }
}
