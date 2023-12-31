import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sample/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Firestoreのデータベース定義
final db = FirebaseFirestore.instance;

/// Firestoreのpostsデータベース定義
final dbPost = db.collection('users').doc(userID).collection('posts');

/// UserIDの取得
final userID = FirebaseAuth.instance.currentUser?.uid ?? 'test';

final dataServiceProvider = StateProvider<DataService>((ref) => DataService());

class DataService {
  // データを保存するメソッド
  Future<void> addPost(String title, String body, File? file) async {
    try {
      if (title.isEmpty) {
        throw ('タイトルが入力されていません!');
      }

      if (body.isEmpty) {
        throw ('投稿内容が入力されていません!');
      }

      // uid取得する変数
      final uid = userID;
      // Freezedのモデルクラスで定義した型を使ってデータを保存する
      final newPost = Post(
          id: uid.toString(),
          title: title,
          body: body,
          fileURL: 'ZZZ',
          favorite: 0,
          favoriteUsers: [],
          createdAt: DateTime.now(),
          editedAt: DateTime.now());

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
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (post.favoriteUsers.contains(uid)) {
        await dbPost.doc(post.createdAt!.toIso8601String()).update({
          'favorite': FieldValue.increment(-1),
          'favoriteUsers': FieldValue.arrayRemove([uid])
        });
      } else {
        await dbPost.doc(post.createdAt!.toIso8601String()).update({
          'favorite': FieldValue.increment(1),
          'favoriteUsers': FieldValue.arrayUnion([uid])
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
