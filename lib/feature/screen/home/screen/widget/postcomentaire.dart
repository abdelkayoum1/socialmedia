import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/feature/screen/home/cubit/stories_cubit_cubit.dart';
import 'package:socialmedia/feature/screen/home/model/post_model.dart';
import 'package:socialmedia/feature/screen/home/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Postcomentaire extends StatefulWidget {
  final PostModel? post;
  const Postcomentaire({super.key, required this.post});

  @override
  State<Postcomentaire> createState() => _PostcomentaireState();
}

class _PostcomentaireState extends State<Postcomentaire> {
  late bool isliked;
  void initState() {
    // TODO: implement initState
    super.initState();
    final user = Supabase.instance.client.auth.currentUser;
    isliked = widget.post!.like?.contains(user!.id) ?? false;
    setuser();
  }

  final user = Supabase.instance.client.auth.currentUser!.id;

  Future<void> setuser() async {
    final usernameandimage = await getuser();
    setState(() {
      usernamee = usernameandimage.username;
      imageuser = usernameandimage.image;
    });
  }

  Future<UserModel> getuser() async {
    final usere = await Supabase.instance.client
        .from('users')
        .select('username,image')
        .eq('id', user)
        .single();
    return UserModel(username: usere['username'], image: usere['image']);
  }

  String? usernamee;
  String? imageuser;
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<StoriesCubitCubit>(context);
    return BlocBuilder<StoriesCubitCubit, StoriesCubitState>(
      buildWhen: (previous, current) =>
          current is Fetchusercommentsucces &&
              current.postid == widget.post!.id ||
          current is Fetchusercommentsuccesremove &&
              current.postid == widget.post!.id,
      builder: (context, state) {
        var c = widget.post!.comment;
        if (state is Fetchusercommentsucces) {
          c = state.comment;
        }
        if (state is Fetchusercommentsuccesremove &&
            state.postid == widget.post!.id) {
          c = state.comment;
        }

        return ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(color: Colors.black, height: 0.1, thickness: 0.5);
          },
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final comment = c![index];
            final userpostimage = Supabase.instance.client.storage
                .from('image')
                .getPublicUrl(comment.image);

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(userpostimage),
              ),
              title: Text(comment.username),
              subtitle: Text(comment.comment),
              trailing: IconButton(
                onPressed: () {
                  cubit.fetchusercommentremove(
                    widget.post!.id,
                    Supabase.instance.client.auth.currentUser!.id,
                    usernamee!,
                    comment.comment,
                  );
                },
                icon: Icon(Icons.delete),
              ),
            );
          },

          itemCount: c!.length,
        );
      },
    );
  }
}
