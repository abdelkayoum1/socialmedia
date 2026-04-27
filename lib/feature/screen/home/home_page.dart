import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:socialmedia/feature/screen/cubit/login_and_register_cubit.dart';
import 'package:socialmedia/feature/screen/cubit/login_and_register_state.dart';
import 'package:socialmedia/feature/screen/home/cubit/stories_cubit_cubit.dart';
import 'package:socialmedia/feature/screen/home/model/post_model.dart';
import 'package:socialmedia/feature/screen/home/screen/widget/post_section.dart';
import 'package:socialmedia/feature/screen/home/screen/widget/stories_container.dart';
import 'package:socialmedia/feature/screen/nav_bar2/data/cubit/prefile_state_cubit.dart';
import 'package:socialmedia/feature/screen/nav_bar2/widget/home_page_body.dart';
import 'package:socialmedia/feature/screen/nav_bar2/widget/post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  final String? image;
  const HomePage({super.key, this.image});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<StoriesCubitCubit>().fetchstories();
    context.read<StoriesCubitCubit>().fetchpost();
  }

  @override
  Widget build(BuildContext context) {
    //   cubit.fetchstories();
    //  cubit.fetchpost();
    // cubit.fetchstories();
    //   cubit.fetchpost();
    //   cubit.fetchuserdata();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 3,
          title: Image.asset('assets/logo.png', width: 200),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications_none_rounded),
              iconSize: 30,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
              iconSize: 30,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                HomePageBody(),
                SizedBox(
                  height: 120,
                  child: BlocBuilder<StoriesCubitCubit, StoriesCubitState>(
                    buildWhen: (previous, current) =>
                        current is StoriesCubitfailure ||
                        current is StoriesCubitloading ||
                        current is StoriesCubitsucces,
                    builder: (context, state) {
                      if (state is StoriesCubitfailure) {
                        return Center(child: Text(state.error));
                      } else if (state is StoriesCubitsucces) {
                        if (state.stories.isEmpty) {
                          return Center(child: Text('no stories'));
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.stories.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Storiescontainer(isstories: true);
                            }

                            return Storiescontainer(
                              stories: state.stories[index - 1],
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                    },
                  ),
                ),
                Postsection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
