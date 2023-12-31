import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_sample/models/timestamp.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart'; // 先頭の文字をファイル名と同じ名前にする
part 'post.g.dart'; // 先頭の文字をファイル名と同じ名前にする

@freezed
class Post with _$Post {
  const factory Post({
    required String id,
    required String title,
    required String body,
    required String fileURL,
    required int favorite,
    required List favoriteUsers,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? editedAt,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}