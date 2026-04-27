import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'settings_dart_state.dart';

class SettingsDartCubit extends Cubit<SettingsDartState> {
  SettingsDartCubit() : super(SettingsDartInitial());

  Future<void> logout() async {
    emit(SettingsDartloading());
    try {
      await Supabase.instance.client.auth.signOut();
      emit(SettingsDartsucces());
    } catch (e) {
      emit(SettingsDartfailure(error: e.toString()));
    }
  }
}
