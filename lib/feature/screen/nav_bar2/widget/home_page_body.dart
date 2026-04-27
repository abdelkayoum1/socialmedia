import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/feature/screen/home/cubit/stories_cubit_cubit.dart';
import 'package:socialmedia/feature/screen/home/model/post_model.dart';
import 'package:socialmedia/feature/screen/nav_bar2/widget/post.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  String? image;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        // margin: EdgeInsets.all(12),
        padding: EdgeInsets.only(left: 20),
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 3)],
        ),

        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    child: Image.asset('assets/logo.png', width: 100),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        await Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: context.read<StoriesCubitCubit>(),
                              child: Post(
                                cubit: context
                                    .read<StoriesCubitCubit>()
                                    .fetchuserdata(),
                              ),
                            ),
                          ),
                        );
                        // .then((value) => cubit.fetchpost());
                        // .then((value) => cubit.fetchpost());
                      },
                      child: Text('What\'t on your head'),
                    ),
                  ),
                  // Row(children: [Text('data')]),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.image, color: Colors.blue),
                      SizedBox(width: 10),

                      Text('Photo', style: TextStyle(color: Colors.blueGrey)),
                    ],
                  ),

                  SizedBox(width: 10),
                  SizedBox(
                    height: 15,
                    child: VerticalDivider(color: Colors.grey, thickness: 1),
                  ),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          final resultat = await Navigator.of(context)
                              .push<String>(
                                MaterialPageRoute(builder: (context) => Post()),
                              );
                          if (resultat != null) {}
                        },
                        child: Row(
                          children: [
                            Icon(Icons.video_call, color: Colors.blue),
                            SizedBox(width: 10),

                            Text(
                              'Vedeo',
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
