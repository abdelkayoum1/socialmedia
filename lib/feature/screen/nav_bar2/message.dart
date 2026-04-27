import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/feature/data/model_user.dart';
import 'package:socialmedia/feature/screen/nav_bar2/data/cubit/cubit/cubit/folowwing_dart_cubit.dart';
import 'package:socialmedia/feature/screen/nav_bar2/data/cubit/prefile_state_cubit.dart';
import 'package:socialmedia/feature/screen/nav_bar2/prefile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<PrefileStateCubit>().discoverfetch();
  }

  ModelUser? user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Discover page')),
      body: BlocBuilder<PrefileStateCubit, PrefileStateState>(
        buildWhen: (previous, current) =>
            current is Discoversucces ||
            current is Discoverfailure ||
            current is Discoverloading,
        builder: (context, state) {
          if (state is Discoverfailure) {
            return Center(child: Text(state.error));
          } else if (state is Discoversucces) {
            if (state.user.isEmpty) {
              return Center(child: Text('no user found'));
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.user.length,
                    itemBuilder: (context, index) {
                      final image = Supabase.instance.client.storage
                          .from('image')
                          .getPublicUrl(state.user[index].image);
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (context) => PrefilePage(),
                                  ),
                                )
                                .then(
                                  (_) => context
                                      .read<FolowwingDartCubit>()
                                      .updatefollower(state.user[index].id),
                                );
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(image),
                          ),
                          title: Text(state.user[index].username),
                          subtitle: Text(
                            '${state.user[index].following?.length.toString() ?? '0'}  followwers',
                          ),
                          trailing:
                              BlocConsumer<
                                FolowwingDartCubit,
                                FolowwingDartState
                              >(
                                listenWhen: (previous, current) =>
                                    current is Followinglaodingg &&
                                        current.userId ==
                                            state.user[index].id ||
                                    current is Followingfailuree ||
                                    current is Followingsuccess &&
                                        current.userId == state.user[index].id,
                                listener: (context, statee) {
                                  if (statee is Followingsuccess) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('followers succes'),
                                      ),
                                    );
                                  } else if (statee is Followingfailuree) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(statee.error)),
                                    );
                                  }
                                },
                                buildWhen: (previous, current) =>
                                    current is Followingfailuree ||
                                    current is Followinglaodingg &&
                                        current.userId ==
                                            state.user[index].id ||
                                    current is Followingsuccess &&
                                        current.userId == state.user[index].id,
                                builder: (context, statee) {
                                  bool isfolowing =
                                      context
                                          .read<FolowwingDartCubit>()
                                          .currectuser
                                          ?.following
                                          ?.contains(state.user[index].id) ??
                                      false;

                                  if (statee is Followinglaodingg &&
                                      statee.userId == state.user[index].id) {
                                    return ElevatedButton(
                                      onPressed: null,
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    );
                                  }
                                  return ElevatedButton(
                                    onPressed: isfolowing
                                        ? null
                                        : () {
                                            context
                                                .read<FolowwingDartCubit>()
                                                .updatefollower(
                                                  state.user[index].id,
                                                );
                                          },
                                    child: Text(
                                      isfolowing ? 'Folower' : 'Follow',
                                    ),
                                  );
                                },
                              ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }
}
