import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:socialmedia/feature/screen/home/cubit/stories_cubit_cubit.dart';
import 'package:socialmedia/feature/screen/home/model/post_model.dart';
import 'package:socialmedia/feature/screen/home/model/user_model.dart';
import 'package:socialmedia/feature/screen/home/screen/widget/postcomentaire.dart';
import 'package:socialmedia/feature/screen/home/screen/widget/postlike.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Postt extends StatefulWidget {
  final PostModel? post;
  const Postt({super.key, required this.post});

  @override
  State<Postt> createState() => _PosttState();
}

class _PosttState extends State<Postt> {
  var commentt = TextEditingController();
  late bool isliked;
  final user = Supabase.instance.client.auth.currentUser!.id;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final user = Supabase.instance.client.auth.currentUser;
    isliked = widget.post!.like?.contains(user!.id) ?? false;
    setuser();
  }

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
    final cubit = context.read<StoriesCubitCubit>();
    final image = widget.post!.user?.image != null
        ? Supabase.instance.client.storage
              .from('image')
              .getPublicUrl(widget.post!.user!.image)
        : 'assets/logo.png';
    final imagepost = widget.post!.image != null
        ? Supabase.instance.client.storage
              .from('image')
              .getPublicUrl(widget.post?.image! ?? '')
        : null;

    print(imagepost);
    //print('imagees$imagepost');

    return Card(
      color: Colors.grey.shade200,
      // shadowColor: Colors.amber,
      shadowColor: Colors.black,

      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(imagepost!),
                ),
                SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post!.username.toString(),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      DateFormat(
                        'h:mm  a',
                      ).format(DateTime.parse(widget.post?.createdat ?? '')),
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium!.copyWith(color: Colors.grey),
                    ),

                    SizedBox(height: 10),
                  ],
                ),
              ],
            ),
            Text(
              widget.post!.text ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            /// 👇 التعليقات
            if (imagepost != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: imagepost,
                      //  errorWidget: (context, url, error) => Icon(Icons.error),
                      width: double.infinity,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            Row(
              children: [
                BlocBuilder<StoriesCubitCubit, StoriesCubitState>(
                  buildWhen: (previous, current) =>
                      current is Fetchuserlikefailure ||
                      current is Fetchuserlikeloading &&
                          current.postid == widget.post!.id ||
                      current is Fetchuserlikesucces &&
                          current.postid == widget.post!.id,
                  builder: (context, state) {
                    if (state is Fetchuserlikeloading) {
                      return Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    return Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            print(widget.post!.user!.id);
                            print(widget.post!.id);
                            if (widget.post!.user!.id.isNotEmpty) {
                              await cubit.fetchuserlike(
                                widget.post!.id,
                                Supabase.instance.client.auth.currentUser!.id,
                              );

                              /*
                              widget.post!.copyWith(
                                isliked: widget.post!.isliked == true,
                              );
                              print(
                                widget.post!.copyWith(
                                  isliked: widget.post!.isliked,
                                ),
                              );
                              */
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('no user found')),
                              );
                            }
                          },

                          icon: Icon(
                            // post!.isliked == true
                            //   final isliked=if(fetch)
                            (state is Fetchuserlikesucces
                                    ? state.isliked
                                    : isliked)
                                ? Icons.thumb_up
                                : Icons.thumb_up_outlined,
                            color:
                                (state is Fetchuserlikesucces
                                    ? state.isliked
                                    : isliked)
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ),
                        Text(
                          state is Fetchuserlikesucces
                              ? state.likecount.toString()
                              : widget.post!.like?.length.toString() ?? '0',
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(width: 20),

                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        final result = await showModalBottomSheet<String>(
                          isScrollControlled: true,
                          useRootNavigator: true,
                          context: context,
                          builder: (contextshett) {
                            return Padding(
                              padding: EdgeInsets.all(16),
                              child: Container(
                                color: Colors.white,
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  //  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Like:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          //   mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: 50,
                                              child: Postlike(
                                                post: widget.post!,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'Commentaire:',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            BlocProvider.value(
                                              value: cubit,
                                              child: Postcomentaire(
                                                post: widget.post,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),

                                    SafeArea(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: commentt,
                                              decoration: InputDecoration(
                                                labelText: 'Commentaire',
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade200,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5),

                                          BlocProvider.value(
                                            value: cubit,
                                            child:
                                                BlocConsumer<
                                                  StoriesCubitCubit,
                                                  StoriesCubitState
                                                >(
                                                  listener: (contextshett, state) {
                                                    if (state
                                                        is Fetchusercommentfailure) {
                                                      Center(
                                                        child: Text(
                                                          state.error,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  builder: (context, state) {
                                                    if (state
                                                        is Fetchusercommentloading) {
                                                      return ElevatedButton(
                                                        onPressed: null,

                                                        child:
                                                            CircularProgressIndicator.adaptive(),
                                                      );
                                                    }
                                                    return ElevatedButton(
                                                      onPressed: () async {
                                                        await cubit
                                                            .fetchusercomment(
                                                              widget.post!.id,
                                                              user,
                                                              usernamee!,
                                                              commentt.text,
                                                              imageuser!,
                                                            );

                                                        commentt.clear();
                                                      },

                                                      style:
                                                          TextButton.styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .deepPurple,
                                                          ),
                                                      child: Text(
                                                        'Commenter',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                        if (result != null && result.isNotEmpty) {
                          context.read<StoriesCubitCubit>().fetchusercomment(
                            widget.post!.id,
                            Supabase.instance.client.auth.currentUser!.id,
                            // widget.post!.user!.username,
                            usernamee!,
                            result,
                            imageuser!,
                          );
                        }
                      },
                      icon: Icon(Icons.comment),
                    ),

                    /// 👇 هنا تحط BlocBuilder
                    BlocBuilder<StoriesCubitCubit, StoriesCubitState>(
                      buildWhen: (previous, current) =>
                          current is Fetchusercommentloading &&
                              current.postid == widget.post!.id ||
                          current is Fetchusercommentsucces &&
                              current.postid == widget.post!.id ||
                          current is Fetchusercommentsuccesremove &&
                              current.postid == widget.post!.id,

                      builder: (context, state) {
                        if (state is Fetchusercommentloading) {
                          return Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                        if (state is Fetchusercommentsuccesremove &&
                            state.postid == widget.post!.id) {
                          return Text(state.comment.length.toString());
                        }

                        return Text(
                          state is Fetchusercommentsucces
                              ? state.commentt.toString()
                              : widget.post?.comment!.length.toString() ?? '0',
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
