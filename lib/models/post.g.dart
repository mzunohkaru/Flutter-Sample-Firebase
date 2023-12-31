// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      fileURL: json['fileURL'] as String,
      favorite: json['favorite'] as int,
      favoriteUsers: json['favoriteUsers'] as List<dynamic>,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      editedAt:
          const TimestampConverter().fromJson(json['editedAt'] as Timestamp?),
    );

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'fileURL': instance.fileURL,
      'favorite': instance.favorite,
      'favoriteUsers': instance.favoriteUsers,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'editedAt': const TimestampConverter().toJson(instance.editedAt),
    };
