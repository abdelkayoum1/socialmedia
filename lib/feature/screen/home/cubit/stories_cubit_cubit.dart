import 'package:bloc/bloc.dart';
import 'package:socialmedia/core/supabase_database.dart';
import 'package:socialmedia/feature/data/model_user.dart';
import 'package:socialmedia/feature/screen/home/model/post_model.dart';
import 'package:socialmedia/feature/screen/home/model/post_model_create.dart';
import 'package:socialmedia/feature/screen/home/model/stories_model.dart';
import 'package:socialmedia/feature/screen/home/model/stories_supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'stories_cubit_state.dart';

class StoriesCubitCubit extends Cubit<StoriesCubitState> {
  StoriesCubitCubit() : super(StoriesCubitInitial());

  Future<void> fetchstories() async {
    final stories = StoriesSupabase();
    try {
      emit(StoriesCubitloading());
      final storiess = await stories.fetchrows();
      print(storiess);
      emit(StoriesCubitsucces(stories: storiess));
      print('stoiresssssssssssssssssssssssssssss');
    } catch (e) {
      print(e.toString());
      emit(StoriesCubitfailure(error: e.toString()));
    }
  }

  Future<void> fetchpost() async {
    final stories = SupabaseDatabase();
    try {
      emit(Postcubitloading());
      final resultat = await stories.fetchrows(
        primaryKey: ['id'],
        table: 'post',
        selectquery: '*,users!post_user_id_fkey(*)',
        builder: (data, id) => PostModel.fromMap(data),
      );

      emit(Postcubitlsucces(post: resultat));
      print('posttttttttttttttttttttttttttttttttt');
    } catch (e) {
      emit(Postcubitlfailure(error: e.toString()));
    }
  }

  Future<void> createpost({
    required String text,
    String? image,
    required String id,
  }) async {
    final createpost = SupabaseDatabase();
    final user = Supabase.instance.client.auth.currentUser;
    try {
      if (user == null) {
        emit(Createpostfailure(error: 'no user'));
        return;
      }
      emit(Createpostloading());
      final data = PostModelCreate(
        text: text,
        image: image,
        userid: Supabase.instance.client.auth.currentUser!.id,
      );
      final post = await createpost.insertrow(
        table: 'post',
        data: data.toMap(),
      );
      emit(Createpostsucces());
      print('succescreatepost');
    } catch (e) {
      emit(Createpostfailure(error: e.toString()));
    }
  }

  Future<void> fetchuserdata() async {
    final stories = SupabaseDatabase();
    final user = Supabase.instance.client.auth.currentUser;
    try {
      emit(Fetchuserdataloading());
      final resultat = await stories.fetchrow(
        id: user!.id,
        table: 'users',
        primaryKey: 'id',

        // selectquery: '*,users!post_user_id_fkey(*)',
        builder: (data, id) => ModelUser.fromMap(data),
      );

      emit(Fetchuserdatasucces(resultat));
      print(resultat);
      print('usergetttttttttttttttttttttt');
    } catch (e) {
      emit(Fetchuserdatafailure(error: e.toString()));
    }
  }

  Future<void> fetchuserlike(String likeid, String userid) async {
    final likepost = SupabaseDatabase();

    try {
      emit(Fetchuserlikeloading(postid: likeid));

      // ✅ غيرت post إلى poste
      var poste = await likepost.fetchrow(
        primaryKey: 'id',
        table: 'post',
        id: likeid,
        builder: (data, id) => PostModel.fromMap(data),
      );

      // List<String> likes = List<String>.from(poste.like ?? []);
      bool isliked;
      if (poste.like != null && poste.like!.contains(userid)) {
        // likes.remove(userid);
        poste.like!.remove(userid);
        isliked = false;
        // poste = poste.copyWith(isliked: false);
        print(poste.isliked);
      } else {
        // likes.add(userid);
        // poste = poste.copyWith(like: poste.like ?? []);
        print(poste.like!.length);

        poste.like!.add(userid);
        isliked = true;
        //poste = poste.copyWith(isliked: true);
        print(poste.isliked);
        print(poste.like!.length);
      }

      await likepost.updaterow(
        table: 'post',
        data: {
          'likes': poste.like,
          'isliked': isliked,
        }, // ✅ تأكد من اسم الكولوم في Supabase
        col: 'id',
        value: likeid,
      );
      print(poste.like);

      emit(
        Fetchuserlikesucces(
          likeid,
          poste.like,
          likecount: poste.like!.length,
          isliked: isliked,
        ),
      );
    } catch (e) {
      print(e.toString());
      emit(Fetchuserlikefailure(error: e.toString()));
    }
  }

  Future<void> fetchusercomment(
    String likeid,
    String userid,
    String username,
    String text,
    String image,
  ) async {
    final likepost = SupabaseDatabase();

    try {
      emit(Fetchusercommentloading(postid: likeid));

      // ✅ غيرت post إلى poste
      var poste = await likepost.fetchrow(
        primaryKey: 'id',
        table: 'post',
        id: likeid,
        builder: (data, id) => PostModel.fromMap(data),
        text: text,
      );

      // List<String> likes = List<String>.from(poste.like ?? []);
      bool isliked = false;
      /*
      if (poste.comment != null) {
        poste.comment!.removeWhere(
          (c) => c.username == username && c.comment == text,
        );
        isliked = false;

        print(poste.comment);
      }
      */

      print(poste.comment!.length);

      poste.comment!.add(
        Postuser(username: username, comment: text, image: image),
      );
      // isliked = true;
      //poste = poste.copyWith(isliked: true);

      await likepost.updaterow(
        table: 'post',
        data: {
          'comment': poste.comment,
          // 'isliked': isliked,
        }, // ✅ تأكد من اسم الكولوم في Supabase
        col: 'id',
        value: likeid,
      );
      print(poste.comment);

      emit(
        Fetchusercommentsucces(
          likeid,
          poste.comment!,
          commentt: poste.comment!.length,
          isliked: isliked,
        ),
      );
      print('commentttttttttttttttttt22222222222222222222222');
    } catch (e) {
      print(e.toString());
      emit(Fetchusercommentfailure(error: e.toString()));
    }
  }

  Future<void> fetchusercommentremove(
    String likeid,
    String userid,
    String username,
    String text,
  ) async {
    final likepost = SupabaseDatabase();

    try {
      emit(Fetchusercommentloadingremove(postid: likeid));

      // ✅ غيرت post إلى poste
      var poste = await likepost.fetchrow(
        primaryKey: 'id',
        table: 'post',
        id: likeid,
        builder: (data, id) => PostModel.fromMap(data),
        text: text,
      );

      // List<String> likes = List<String>.from(poste.like ?? []);
      bool isliked = false;
      if (poste.comment != null) {
        poste.comment!.removeWhere(
          (c) => c.username == username && c.comment == text,
        );
        isliked = false;

        print(poste.comment);
      } else {
        print('no');
        isliked = true;
      }

      await likepost.updaterow(
        table: 'post',
        data: {
          'comment': poste.comment,
          'isliked': isliked,
        }, // ✅ تأكد من اسم الكولوم في Supabase
        col: 'id',
        value: likeid,
      );
      print(poste.comment);

      emit(
        Fetchusercommentsuccesremove(
          likeid,
          poste.comment ?? [],
          isliked: isliked,
        ),
      );
      print('commenttttttttttttttttttremoveeeeeeeeeee');
    } catch (e) {
      print(e.toString());
      emit(Fetchusercommentfailureremove(error: e.toString()));
    }
  }

  Future<void> fetchuserandcomment(String likeid) async {
    final user = Supabase.instance.client.auth.currentUser!.id;
    try {
      emit(Fetchuserlikeandcommentloading());
      final fetch = SupabaseDatabase();
      final user = Supabase.instance.client.auth.currentUser!.id;
      var likes = await fetch.fetchrow(
        table: 'post',
        id: likeid,
        primaryKey: 'id',
        builder: (data, id) => PostModel.fromMap(data),
      );
      var like = <ModelUser>[];

      for (var likesuser in likes.like ?? []) {
        final userdata = await getuser(likesuser);
        print({'id': userdata!.id, 'image': userdata.image});
        print('khelifa');
        print(likesuser);
        like.add(userdata);
        print(like);
      }
      emit(Fetchuserlikeandcommentsucces(like));
    } catch (e) {
      emit(Fetchuserlikeandcommentfailure(error: e.toString()));
    }
  }

  Future<ModelUser?> getuser(String userid) async {
    final fetch = SupabaseDatabase();
    final usere = Supabase.instance.client.auth.currentUser!.id;
    try {
      final user = await fetch.fetchrow<ModelUser?>(
        primaryKey: 'id',
        table: 'users',
        id: userid,
        builder: (data, id) => ModelUser.fromMap(data),
      );
      print(usere);
      print('khkhkh');
      print(user!.username);
      return user;
    } catch (e) {
      rethrow;
    }
  }
}
