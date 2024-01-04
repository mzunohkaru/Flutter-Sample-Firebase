import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_sample/controllers/storage.dart';
import 'package:firebase_sample/models/post.dart';
import 'package:firebase_sample/utils.dart';

class FirebaseStoreController {
  // データを保存するメソッド
  Future addPost(
      String title, String body, File? file, bool fType) async {
    try {
      if (title.isEmpty) {
        throw ('タイトルが入力されていません!');
      }

      if (body.isEmpty) {
        throw ('投稿内容が入力されていません!');
      }

      DateTime createdAt = DateTime.now();
      String fileType = "";
      String? fileUrl = "";
      if (file != null) {
        if (fType) {
          fileUrl = await CloudStorageController()
              .uploadImage(file, createdAt.toIso8601String());
          fileType = "image";
        } else {
          fileUrl = await CloudStorageController()
              .uploadVideo(file, createdAt.toIso8601String());
          fileType = "video";
        }
      }

      // uid取得する変数
      final uid = userID;
      // Freezedのモデルクラスで定義した型を使ってデータを保存する
      final newPost = Post(
          id: uid.toString(),
          title: title,
          body: body,
          fileType: fileType,
          fileURL: fileUrl!,
          favorite: 0,
          favoriteUsers: [],
          createdAt: createdAt,
          editedAt: createdAt);

      await dbPost
          .doc(newPost.createdAt!.toIso8601String())
          .set(newPost.toJson());
    } catch (e) {
      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         // throwのエラーメッセージがダイアログで表示される.
      //         title: Text(e.toString()),
      //         actions: <Widget>[
      //           ElevatedButton(
      //             child: const Text('OK'),
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //           ),
      //         ],
      //       );
      //     });
    }
  }

  Future deletePost(String createTime) async {
    dbPost.doc(createTime).delete();
  }

  // Post FavoriteButton
  Future favoritePost(Post post) async {
    try {
      if (post.favoriteUsers.contains(userID)) {
        await dbPost.doc(post.createdAt!.toIso8601String()).update({
          'favorite': FieldValue.increment(-1),
          'favoriteUsers': FieldValue.arrayRemove([userID])
        });
      } else {
        await dbPost.doc(post.createdAt!.toIso8601String()).update({
          'favorite': FieldValue.increment(1),
          'favoriteUsers': FieldValue.arrayUnion([userID])
        });
      }
    } catch (e) {
      print('Error : $e');
    }
  }

  Future editPost(Post post) async {
    dbPost
        .doc(post.createdAt!.toIso8601String())
        .update({'editedAt': DateTime.now()});
  }
}
