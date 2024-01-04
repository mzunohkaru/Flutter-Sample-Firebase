import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sample/controllers/firestore.dart';
import 'package:firebase_sample/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_sample/models/post.dart';


/// Authのサインイン状態のprovider
final signInStateProvider = StateProvider.autoDispose((ref) => 'サインインまたはアカウントを作成してください');

final userEmailProvider = StateProvider.autoDispose<String>((ref) => 'ログインしていません');

/// サインインユーザーの情報プロバイダー
final userProvider = StreamProvider<User?>((ref) {
  return auth.authStateChanges();
});

final firebaseStoreProvider =
    StateProvider<FirebaseStoreController>((ref) => FirebaseStoreController());

final postStreamProvider = StreamProvider<List<Post>>((ref) {
  final collection = FirebaseFirestore.instance.collection('users').doc(userID).collection('posts');

  final stream = collection.snapshots().map(
        (e) => e.docs.map((e) => Post.fromJson(e.data())).toList(),
      );
  return stream;
});
