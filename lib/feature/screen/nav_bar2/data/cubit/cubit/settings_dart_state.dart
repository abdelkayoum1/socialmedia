part of 'settings_dart_cubit.dart';

@immutable
sealed class SettingsDartState {}

final class SettingsDartInitial extends SettingsDartState {}

final class SettingsDartloading extends SettingsDartState {}

final class SettingsDartsucces extends SettingsDartState {}

final class SettingsDartfailure extends SettingsDartState {
  final String error;

  SettingsDartfailure({required this.error});
}
