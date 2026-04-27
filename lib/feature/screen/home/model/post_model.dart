// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:socialmedia/feature/data/model_user.dart';

class PostModel {
  final String id;
  final String createdat;
  final String? image;
  // final List<String>? likes;
  final String? text;
  final String? username;
  final ModelUser? user;
  final List<String>? like;
  final bool isliked;
  final List<Postuser>? comment;

  PostModel({
    this.user,
    required this.isliked,
    this.username,
    required this.id,
    required this.createdat,
    this.image,
    this.like,
    this.text,
    this.comment,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'created_at': createdat,
      'image': image,
      'text': text,
      'user': user?.toMap(),
      'likes': like,
      'username': username,
      'isliked': isliked,
      'comment': comment,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      isliked: map['isliked'] ?? false,
      createdat: map['created_at'] ?? '',
      image: map['image'] != null ? map['image'] as String : null,

      username: map['users']?['username']?.toString(),
      text: map['text'] != null ? map['text'] as String : null,
      user: map['users'] != null
          ? ModelUser.fromMap(map['users'] as Map<String, dynamic>)
          : null,
      like: map['likes'] != null ? List<String>.from(map['likes']) : [],
      comment: map['comment'] != null
          ? List<Postuser>.from(
              map['comment'].map((x) => Postuser.fromMap(jsonDecode(x))),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  PostModel copyWith({
    String? id,
    String? createdat,
    String? image,
    String? text,
    ModelUser? user,
    List<String>? like,
    String? username,
    bool? isliked,
  }) {
    return PostModel(
      id: id ?? this.id,
      createdat: createdat ?? this.createdat,
      image: image ?? this.image,
      text: text ?? this.text,
      user: user ?? this.user,
      like: like ?? this.like,
      username: username ?? this.username,
      isliked: isliked ?? this.isliked,
    );
  }
}

class Postuser {
  final String comment;
  final String username;
  final String image;

  Postuser({
    required this.comment,
    required this.username,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'comment': comment,
      'username': username,
      'image': image,
    };
  }

  factory Postuser.fromMap(Map<String, dynamic> map) {
    return Postuser(
      comment: map['comment'] as String,
      username: map['username'] as String,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Postuser.fromJson(String source) =>
      Postuser.fromMap(json.decode(source) as Map<String, dynamic>);
}
