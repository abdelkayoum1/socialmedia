import 'package:flutter/material.dart';
import 'package:socialmedia/feature/screen/home/model/post_model.dart';
import 'package:socialmedia/feature/screen/login.dart';
import 'package:socialmedia/feature/screen/nav_bar2/widget/detailsprefile.dart';
import 'package:socialmedia/feature/screen/nav_bar2/widget/postprefile.dart';
import 'package:socialmedia/feature/screen/register.dart';

class Postprefileuser extends StatefulWidget {
  final List<PostModel> post;
  const Postprefileuser({super.key, required this.post});

  @override
  State<Postprefileuser> createState() => _PostprefileuserState();
}

class _PostprefileuserState extends State<Postprefileuser>
    with TickerProviderStateMixin {
  List<Tab> list = [Tab(text: 'Details'), Tab(text: 'Post')];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: list.length,
      child: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40),
            child: Column(
              children: [
                TabBar(
                  indicatorColor: Colors.blue,
                  labelColor: Colors.black,
                  isScrollable: true,
                  tabAlignment: TabAlignment.center,
                  dividerColor: Colors.grey,
                  controller: DefaultTabController.of(context),
                  tabs: list,
                ),
                SizedBox(
                  height: 200,
                  child: TabBarView(
                    controller: DefaultTabController.of(context),
                    children: [
                      Postprefile(),
                      Detailsprefile(post: widget.post),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
