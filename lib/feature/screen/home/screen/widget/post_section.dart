import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/feature/screen/home/cubit/stories_cubit_cubit.dart';
import 'package:socialmedia/feature/screen/home/screen/widget/postuser.dart';
import 'package:socialmedia/feature/screen/nav_bar2/widget/post.dart';

class Postsection extends StatelessWidget {
  const Postsection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoriesCubitCubit, StoriesCubitState>(
      buildWhen: (previous, current) =>
          current is Postcubitlfailure ||
          current is Postcubitlsucces ||
          current is Postcubitloading,
      builder: (context, state) {
        if (state is Postcubitlfailure) {
          return Center(child: Text(state.error));
        } else if (state is Postcubitlsucces) {
          if (state.post.isEmpty) {
            return Center(child: Text('no post'));
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: state.post.length,

            itemBuilder: (context, index) {
              return Postt(post: state.post[index]);
            },
          );
        } else {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        // return SizedBox.shrink();
      },
    );
  }
}
