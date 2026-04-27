import 'package:bloc/bloc.dart';
import 'package:socialmedia/core/supabase_database.dart';
import 'package:socialmedia/feature/data/model_user.dart';
import 'package:socialmedia/feature/screen/home/cubit/stories_cubit_cubit.dart';
import 'package:socialmedia/feature/screen/home/model/post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'prefile_state_state.dart';

class PrefileStateCubit extends Cubit<PrefileStateState> {
  PrefileStateCubit() : super(PrefileStateInitial());
  ModelUser? currectuser;

  Future<void> getuserdata() async {
    final user = SupabaseDatabase();
    final userid = Supabase.instance.client.auth.currentUser!.id;

    try {
      emit(PrefileStatelaoding());
      final usere = await user.fetchrow(
        primaryKey: 'id',
        table: 'users',
        id: userid,
        builder: (data, id) => ModelUser.fromMap(data),
      );
      emit(PrefileStatesucces(user: usere));
      print("3333333");
      print('prefile');
    } catch (e) {
      emit(PrefileStatefailure(error: e.toString()));
    }
  }

  Future<void> fetchuserpost() async {
    final poste = SupabaseDatabase();
    final userid = Supabase.instance.client.auth.currentUser!.id;
    try {
      emit(Prefilepostloading());
      var post = await poste.fetchrows(
        primaryKey: ['id'],
        table: 'post',
        builder: (data, id) => PostModel.fromMap(data),
        filter: (query) => query.eq('user_id', userid),
      );
      var usere = await poste.fetchrow(
        primaryKey: 'id',
        table: 'users',
        id: userid,
        builder: (data, id) => ModelUser.fromMap(data),
      );

      usere = usere.copyWith(postcount: post.length);
      print('22222');
      print(usere);
      emit(Prefilepostsucces(user: usere));

      print('prefileee');
    } catch (e) {
      emit(Prefilepostfailure(error: e.toString()));
    }
  }

  Future<void> fetchuserpostdetail() async {
    final poste = SupabaseDatabase();
    final userid = Supabase.instance.client.auth.currentUser!.id;
    try {
      emit(Prefilepostloadingdetail());
      final post = await poste.fetchrows(
        primaryKey: ['id'],
        table: 'post',
        selectquery: '*,users!post_user_id_fkey(*)',
        builder: (data, id) => PostModel.fromMap(data),
        filter: (query) => query.eq('user_id', userid),
      );
      var usere = await poste.fetchrow(
        primaryKey: 'id',
        table: 'users',
        id: userid,
        builder: (data, id) => ModelUser.fromMap(data),
      );
      usere = usere.copyWith(postcount: post.length);
      print('22222');
      print(usere);
      emit(Prefilepostsuccesdetails(user: post));
      print('4545454545454545khelifa');

      print('prefileee');
    } catch (e) {
      emit(Prefilepostfailuredetail(error: e.toString()));
    }
  }

  Future<void> editprefile({String? username, String? title}) async {
    final supabase = SupabaseDatabase();
    final user = Supabase.instance.client.auth.currentUser!.id;
    try {
      emit(EditPrefilepostloading());
      final usere = await supabase.fetchrow(
        primaryKey: 'id',
        table: 'users',
        id: user,
        builder: (data, id) => ModelUser.fromMap(data),
      );
      print(usere.email);
      var value = {'username': username, 'email': title};

      await supabase.updaterow(
        table: 'users',
        data: {'username': username, 'email': title},
        col: 'id',
        value: user,
      );
      print(usere.id);
      print(title);
      emit(EditPrefilepostsucces());
      print('edit');
    } catch (e) {
      print(e);
      // TODO
      emit(EditPrefilepostfailure(error: e.toString()));
    }
  }

  Future<void> discoverfetch() async {
    final supabase = SupabaseDatabase();
    final user = Supabase.instance.client.auth.currentUser!.id;
    try {
      emit(Discoverloading());
      /*
      currectuser = await supabase.fetchrow(
        primaryKey: 'id',
        table: 'users',
        id: user,

        builder: (data, id) => ModelUser.fromMap(data),
      );
      */
      final usere = await supabase.fetchrows(
        primaryKey: ['id'],
        table: 'users',
        builder: (data, id) => ModelUser.fromMap(data),
        filter: (query) => query.neq('id', user),
      );

      emit(Discoversucces(user: usere));
      print('edit');
    } catch (e) {
      print(e);
      // TODO
      emit(Discoverfailure(error: e.toString()));
    }
  }

  Future<void> updatefollower(String id) async {
    final supabase = SupabaseDatabase();
    final user = Supabase.instance.client.auth.currentUser!.id;

    try {
      emit(Followinglaoding(userId: id));
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
      emit(Followingsucces(user: value, userId: id));
      print('before');
      await fetchuserpost();
      print('after');
    } catch (e) {
      print(e.toString());
      emit(Followingfailure(error: e.toString(), userId: id));
    }
  }
}
