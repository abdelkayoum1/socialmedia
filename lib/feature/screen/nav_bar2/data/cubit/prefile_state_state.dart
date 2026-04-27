part of 'prefile_state_cubit.dart';

sealed class PrefileStateState {}

final class PrefileStateInitial extends PrefileStateState {}

final class PrefileStatelaoding extends PrefileStateState {}

final class PrefileStatesucces extends PrefileStateState {
  final ModelUser? user;

  PrefileStatesucces({required this.user});
}

final class PrefileStatefailure extends PrefileStateState {
  final String error;

  PrefileStatefailure({required this.error});
}

final class Prefilepostloading extends PrefileStateState {}

final class Prefilepostsucces extends PrefileStateState {
  final ModelUser user;
  final int? countpost;

  Prefilepostsucces({required this.user, this.countpost = 0});
}

final class Prefilepostfailure extends PrefileStateState {
  final String error;

  Prefilepostfailure({required this.error});
}

final class Prefilepostloadingdetail extends PrefileStateState {}

final class Prefilepostsuccesdetails extends PrefileStateState {
  final List<PostModel> user;
  final Future<void>? cubit;
  final int? countpost;
  final PostModel? post;

  Prefilepostsuccesdetails({
    required this.user,
    this.countpost = 0,
    this.cubit,
    this.post,
  });
}

final class Prefilepostfailuredetail extends PrefileStateState {
  final String error;

  Prefilepostfailuredetail({required this.error});
}

//////////////////////////edit prefile
///
final class EditPrefilepostloading extends PrefileStateState {}

final class EditPrefilepostsucces extends PrefileStateState {}

final class EditPrefilepostfailure extends PrefileStateState {
  final String error;

  EditPrefilepostfailure({required this.error});
}

////////////////discover fetch
///
final class Discoverloading extends PrefileStateState {}

final class Discoversucces extends PrefileStateState {
  final List<ModelUser> user;

  Discoversucces({required this.user});
}

final class Discoverfailure extends PrefileStateState {
  final String error;

  Discoverfailure({required this.error});
}

////////////add folowwing
////////////////discover fetch
///
final class Followinglaoding extends PrefileStateState {
  final String userId; // 👈 زيد هذا
  Followinglaoding({required this.userId});
}

final class Followingsucces extends PrefileStateState {
  final ModelUser user;
  final String userId; // 👈 زيد هذا
  Followingsucces({required this.user, required this.userId});
}

final class Followingfailure extends PrefileStateState {
  final String error;
  final String userId; // 👈 زيد هذا
  Followingfailure({required this.error, required this.userId});
}
