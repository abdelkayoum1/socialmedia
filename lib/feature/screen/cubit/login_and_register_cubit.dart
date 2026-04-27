import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/feature/data/model_user.dart';
import 'package:socialmedia/feature/screen/cubit/login_and_register_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginAndRegisterCubit extends Cubit<LoginAndRegisterState> {
  final supabase = Supabase.instance.client.auth;

  LoginAndRegisterCubit() : super(Loginandregisterinitial());

  Future<bool> login(String email, String password) async {
    try {
      emit(Loginandregisterloading());
      final resultat = await supabase.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (resultat.user != null) {
        emit(Loginandregistersucces());
        return true;
      } else {
        emit(Loginandregisterfailure(msj: 'error'));
        return false;
      }
    } catch (e) {
      emit(Loginandregisterfailure(msj: e.toString()));
      return false;
    }
  }

  Future<void> sign(
    String email,
    String password,
    String username,
    String image,
  ) async {
    try {
      emit(Loginandregisterloading());

      final resultat = await supabase.signUp(
        email: email.trim(),
        password: password.trim(),
      );
      if (resultat.user != null) {
        await seduser(email, supabase.currentUser!.id, username, image);

        print("2222");
        print(supabase.currentUser!.email);
        emit(Loginandregistersucces());

        print('hiihihihi');
        //  return true;
      } else {
        emit(Loginandregisterfailure(msj: 'error'));

        // return false;
      }
    } catch (e) {
      emit(Loginandregisterfailure(msj: e.toString()));
    }
  }

  Future<void> forgetpassword(String email) async {
    final resultat = await supabase.resetPasswordForEmail(email);
  }

  Future<void> seduser(
    String email,
    String id,
    String username,
    String image,
  ) async {
    final user = Supabase.instance.client.auth.currentUser;
    try {
      print('ajouter');

      final userrsend = await Supabase.instance.client.from('users').insert({
        'id': user!.id,
        'email': email,
        'username': username,
        'image': image,
      });
      print(id);
      final userrsendstories = await Supabase.instance.client
          .from('stories')
          .insert({'user_id': user.id, 'email': email});
      await Supabase.instance.client.from('post').insert({
        'user_id': user.id,
        'image': image,
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  User? getuser() {
    return supabase.currentUser;
  }
}
