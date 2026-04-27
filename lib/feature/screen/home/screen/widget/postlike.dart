import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/feature/screen/home/cubit/stories_cubit_cubit.dart';
import 'package:socialmedia/feature/screen/home/model/post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Postlike extends StatefulWidget {
  final PostModel post;
  const Postlike({super.key, required this.post});

  @override
  State<Postlike> createState() => _PostlikeState();
}

class _PostlikeState extends State<Postlike> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<StoriesCubitCubit>().fetchuserandcomment(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoriesCubitCubit, StoriesCubitState>(
      buildWhen: (previous, current) =>
          current is Fetchuserlikeandcommentloading ||
          current is Fetchuserlikeandcommentsucces,
      builder: (context, state) {
        if (state is Fetchuserlikeandcommentfailure) {
          return Center(child: Text(state.error));
        }
        if (state is Fetchuserlikeandcommentsucces) {
          if (state.likes.isEmpty) {
            return Center(child: Text('no likes'));
          }
          final likes = state.likes;
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: likes.length,
            itemBuilder: (context, index) {
              final likepostuser = likes[index];
              print(likepostuser.id);
              print(likepostuser.image);

              final imagepostuser = Supabase.instance.client.storage
                  .from('image')
                  .getPublicUrl(likepostuser.image);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imagepostuser),
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator.adaptive());
        }
      },
    );
  }
}
