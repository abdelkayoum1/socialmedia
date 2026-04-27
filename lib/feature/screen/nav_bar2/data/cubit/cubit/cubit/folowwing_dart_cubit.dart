import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:socialmedia/core/supabase_database.dart';
import 'package:socialmedia/feature/data/model_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'folowwing_dart_state.dart';

class FolowwingDartCubit extends Cubit<FolowwingDartState> {
  FolowwingDartCubit() : super(FolowwingDartInitial());

  ModelUser? currectuser;

  Future<void> updatefollower(String id) async {
    final supabase = SupabaseDatabase();
    final user = Supabase.instance.client.auth.currentUser!.id;

    try {
      emit(Followinglaodingg(userId: id));
      final usere = await supabase.fetchrow(
        primaryKey: 'id',
        table: 'users',
        id: user,
        builder: (data, id) => ModelUser.fromMap(data),
      );
      var value = usere.copyWith(following: [...(usere.following ?? []), id]);
      // usere.following!.add(user);
      print(id);
      await supabase.updaterow(
        col: 'id',
        value: user,
        table: 'users',
        data: {'following': value.following},
        // onconflit: user,
      );
      currectuser = value;
      emit(Followingsuccess(user: value, userId: id));
      print('before');
      print('after');
    } catch (e) {
      print(e.toString());
      emit(Followingfailuree(error: e.toString(), userId: id));
    }
  }

  Future<void> discoverfetchh() async {
    final supabase = SupabaseDatabase();
    final user = Supabase.instance.client.auth.currentUser!.id;
    try {
      emit(Discoverloadingg());

      currectuser = await supabase.fetchrow(
        primaryKey: 'id',
        table: 'users',
        id: user,

        builder: (data, id) => ModelUser.fromMap(data),
      );

      final usere = await supabase.fetchrows(
        primaryKey: ['id'],
        table: 'users',
        builder: (data, id) => ModelUser.fromMap(data),
        filter: (query) => query.neq('id', user),
      );

      emit(Discoversuccess(user: usere));
      print('edit');
    } catch (e) {
      print(e);
      // TODO
      emit(Discoverfailuree(error: e.toString()));
    }
  }
}
