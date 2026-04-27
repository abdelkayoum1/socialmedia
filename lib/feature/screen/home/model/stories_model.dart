// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StoriesModel {
  final String id;
  final String authorid;
  final String? image;
  final String username;

  StoriesModel({
    required this.id,
    required this.authorid,
    this.image,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_id': authorid,
      'image': image,
      'username': username,
    };
  }

  factory StoriesModel.fromMap(Map<String, dynamic> map) {
    return StoriesModel(
      username: map['users']['username'],

      id: map['id'] as String,
      authorid: map['user_id'] as String,
      image: map['users']['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StoriesModel.fromJson(String source) =>
      StoriesModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
