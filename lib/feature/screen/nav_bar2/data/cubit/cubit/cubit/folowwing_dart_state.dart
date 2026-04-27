part of 'folowwing_dart_cubit.dart';

@immutable
sealed class FolowwingDartState {}

final class FolowwingDartInitial extends FolowwingDartState {}

final class Followinglaodingg extends FolowwingDartState {
  final String userId; // 👈 زيد هذا
  Followinglaodingg({required this.userId});
}

final class Followingsuccess extends FolowwingDartState {
  final ModelUser user;
  final String userId; // 👈 زيد هذا
  Followingsuccess({required this.user, required this.userId});
}

final class Followingfailuree extends FolowwingDartState {
  final String error;
  final String userId; // 👈 زيد هذا
  Followingfailuree({required this.error, required this.userId});
}

final class Discoverloadingg extends FolowwingDartState {}

final class Discoversuccess extends FolowwingDartState {
  final List<ModelUser> user;

  Discoversuccess({required this.user});
}

final class Discoverfailuree extends FolowwingDartState {
  final String error;

  Discoverfailuree({required this.error});
}
