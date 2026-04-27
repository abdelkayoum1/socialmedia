part of 'stories_cubit_cubit.dart';

sealed class StoriesCubitState {}

final class StoriesCubitInitial extends StoriesCubitState {}

final class StoriesCubitloading extends StoriesCubitState {}

final class StoriesCubitsucces extends StoriesCubitState {
  final List<StoriesModel> stories;

  StoriesCubitsucces({required this.stories});
}

final class StoriesCubitfailure extends StoriesCubitState {
  final String error;

  StoriesCubitfailure({required this.error});
}

final class Postcubitloading extends StoriesCubitState {}

final class Postcubitlsucces extends StoriesCubitState {
  final List<PostModel> post;

  Postcubitlsucces({required this.post});
}

final class Postcubitlfailure extends StoriesCubitState {
  final String error;

  Postcubitlfailure({required this.error});
}

final class Createpostloading extends StoriesCubitState {}

final class Createpostsucces extends StoriesCubitState {
  // final PostModelCreate post;

  Createpostsucces();
}

final class Createpostfailure extends StoriesCubitState {
  final String error;

  Createpostfailure({required this.error});
}

final class Fetchuserdataloading extends StoriesCubitState {}

final class Fetchuserdatasucces extends StoriesCubitState {
  final ModelUser post;

  Fetchuserdatasucces(this.post);
}

final class Fetchuserdatafailure extends StoriesCubitState {
  final String error;

  Fetchuserdatafailure({required this.error});
}

final class Fetchuserlikeloading extends StoriesCubitState {
  final String postid;

  Fetchuserlikeloading({required this.postid});
}

final class Fetchuserlikesucces extends StoriesCubitState {
  final String postid;
  final int likecount;
  final List<String>? likes;
  final bool isliked;
  Fetchuserlikesucces(
    this.postid,
    this.likes, {
    this.likecount = 0,
    required this.isliked,
  });
}

final class Fetchuserlikefailure extends StoriesCubitState {
  final String error;

  Fetchuserlikefailure({required this.error});
}

final class Fetchusercommentloading extends StoriesCubitState {
  final String postid;

  Fetchusercommentloading({required this.postid});
}

final class Fetchusercommentsucces extends StoriesCubitState {
  final String postid;
  final int commentt;
  final List<Postuser> comment;

  final bool isliked;
  Fetchusercommentsucces(
    this.postid,
    this.comment, {

    this.commentt = 0,
    required this.isliked,
  });
}

final class Fetchusercommentfailure extends StoriesCubitState {
  final String error;

  Fetchusercommentfailure({required this.error});
}

final class Fetchusercommentloadingremove extends StoriesCubitState {
  final String postid;

  Fetchusercommentloadingremove({required this.postid});
}

final class Fetchusercommentsuccesremove extends StoriesCubitState {
  final String postid;
  final bool isliked;
  final List<Postuser> comment;
  Fetchusercommentsuccesremove(
    this.postid,
    this.comment, {
    required this.isliked,
  });
}

final class Fetchusercommentfailureremove extends StoriesCubitState {
  final String error;

  Fetchusercommentfailureremove({required this.error});
}

final class Fetchuserlikeandcommentloading extends StoriesCubitState {
  Fetchuserlikeandcommentloading();
}

final class Fetchuserlikeandcommentsucces extends StoriesCubitState {
  final List<ModelUser> likes;
  Fetchuserlikeandcommentsucces(this.likes);
}

final class Fetchuserlikeandcommentfailure extends StoriesCubitState {
  final String error;

  Fetchuserlikeandcommentfailure({required this.error});
}
