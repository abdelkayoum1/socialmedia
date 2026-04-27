import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/feature/screen/home/cubit/stories_cubit_cubit.dart';
import 'package:socialmedia/feature/screen/home/model/post_model.dart';
import 'package:socialmedia/feature/screen/home/screen/widget/postuser.dart';
import 'package:socialmedia/feature/screen/nav_bar2/data/cubit/prefile_state_cubit.dart';
import 'package:socialmedia/feature/screen/nav_bar2/widget/post.dart';

class Detailsprefile extends StatefulWidget {
  final List<PostModel> post;
  const Detailsprefile({super.key, required this.post});

  @override
  State<Detailsprefile> createState() => _DetailsprefileState();
}

class _DetailsprefileState extends State<Detailsprefile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //context.read<PrefileStateCubit>().fetchuserpostdetail();
    // context.read<StoriesCubitCubit>().fetchusercomment();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics(),
      itemCount: widget.post.length,

      itemBuilder: (context, index) {
        return Postt(post: widget.post[index]);
      },
    );

    // return SizedBox.shrink();
  }
}
