import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_sample/firebases/firestore.dart';
import 'package:firebase_sample/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postStreamProvider = StreamProvider<List<Post>>((ref) {
  final collection = FirebaseFirestore.instance.collection('users').doc(userID).collection('posts');

  final stream = collection.snapshots().map(
        (e) => e.docs.map((e) => Post.fromJson(e.data())).toList(),
      );
  return stream;
});
