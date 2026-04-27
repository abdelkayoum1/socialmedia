// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ModelUser {
  final String id;
  final String email;
  final String username;
  final String image;
  final num? postcount;
  final num? folowerscount;
  final num? folowwingcount;
  final List<String>? following;
  final List<String>? folowwers;
  final String? tille;

  ModelUser({
    required this.id,
    required this.email,
    required this.username,
    this.following,
    this.folowwers,
    this.tille,

    required this.image,
    this.postcount,
    this.folowerscount,
    this.folowwingcount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'username': username,
      'folowerscount': folowerscount.toString(),
      'folowwingcount': folowwingcount.toString(),
      'following': following.toString(),
      'folowwers': folowwers.toString(),
      'title': tille,
    };
  }

  factory ModelUser.fromMap(Map<String, dynamic> map) {
    return ModelUser(
      image: map['image'] as String,
      id: map['id'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      folowerscount: map['folowerscount'] as num,
      folowwingcount: map['folowwingcount'] as num,
      following: map['following'] != null
          ? List<String>.from(map['following'] ?? [])
          : null,
      folowwers: map['folowwers'] != null
          ? List<String>.from(map['folowwers'] ?? [])
          : null,
      tille: map['title'] != null ? map['title'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ModelUser.fromJson(String source) =>
      ModelUser.fromMap(json.decode(source) as Map<String, dynamic>);

  ModelUser copyWith({
    String? id,
    String? email,
    String? username,
    String? image,
    num? postcount,
    num? folowerscount,
    num? folowwingcount,
    List<String>? following,
    List<String>? folowwers,
  }) {
    return ModelUser(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      image: image ?? this.image,
      postcount: postcount ?? this.postcount,
      folowerscount: folowerscount ?? this.folowerscount,
      folowwingcount: folowwingcount ?? this.folowwingcount,
      following: following ?? this.following,
      folowwers: folowwers ?? this.folowwers,
    );
  }
}
