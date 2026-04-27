// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PostModelCreate {
  final String text;
  final String userid;
  final String? image;

  PostModelCreate({required this.text, required this.userid, this.image});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'text': text, 'user_id': userid, 'image': image};
  }

  factory PostModelCreate.fromMap(Map<String, dynamic> map) {
    return PostModelCreate(
      text: map['text'] as String,
      userid: map['user_id'] as String,
      image: map['image'] != null ? map['image'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModelCreate.fromJson(String source) =>
      PostModelCreate.fromMap(json.decode(source) as Map<String, dynamic>);
}
