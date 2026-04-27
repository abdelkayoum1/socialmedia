import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/feature/screen/auth_page.dart';
import 'package:socialmedia/feature/screen/home/cubit/stories_cubit_cubit.dart';
import 'package:socialmedia/feature/screen/login.dart';
import 'package:socialmedia/feature/screen/nav_bar2/data/cubit/prefile_state_cubit.dart';
import 'package:socialmedia/feature/screen/nav_bar2/widget/postheader.dart';
import 'package:socialmedia/feature/screen/wiedget/button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'widget/Postprefileuser.dart';
import 'widget/postsectionprefile.dart';

class PrefilePage extends StatefulWidget {
  const PrefilePage({super.key});

  @override
  State<PrefilePage> createState() => _PrefilePageState();
}

class _PrefilePageState extends State<PrefilePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<PrefileStateCubit>().getuserdata();
    context.read<PrefileStateCubit>().fetchuserpost();
    context.read<PrefileStateCubit>().fetchuserpostdetail();

    // context.read<StoriesCubitCubit>().fetchusercomment();

    // context.read<PrefileStateCubit>().fetchuserpostdetail();

    //  context.read<StoriesCubitCubit>().fetchpost();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('my Prefile'),

          actions: [
            ElevatedButton(
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => AuthPage()),
                  (route) => false,
                );
              },
              child: Icon(Icons.logout),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<PrefileStateCubit, PrefileStateState>(
                buildWhen: (previous, current) =>
                    current is PrefileStatefailure ||
                    current is PrefileStatelaoding ||
                    current is PrefileStatesucces,
                builder: (context, state) {
                  if (state is PrefileStatefailure) {
                    return Center(child: Text(state.error));
                  } else if (state is PrefileStatesucces) {
                    if (state.user == null) {
                      return Center(child: Text('no user found'));
                    }

                    return Postheader(user: state.user!);
                  } else {
                    return Center(child: CircularProgressIndicator.adaptive());
                  }
                },
              ),
              SizedBox(height: 10),
              BlocBuilder<PrefileStateCubit, PrefileStateState>(
                buildWhen: (previous, current) =>
                    current is Prefilepostloading ||
                    current is Prefilepostsucces ||
                    current is Prefilepostfailure,

                builder: (context, state) {
                  if (state is Prefilepostfailure) {
                    return Center(child: Text(state.error));
                  } else if (state is Prefilepostsucces) {
                    return Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Postsetionprefile(user: state.user),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator.adaptive());
                  }
                },
              ),
              BlocBuilder<PrefileStateCubit, PrefileStateState>(
                buildWhen: (previous, current) =>
                    current is Prefilepostloadingdetail ||
                    current is Prefilepostsuccesdetails ||
                    current is Prefilepostfailuredetail,

                builder: (context, state) {
                  if (state is Prefilepostfailuredetail) {
                    return Center(child: Text(state.error));
                  } else if (state is Prefilepostsuccesdetails) {
                    return Postprefileuser(post: state.user);
                  } else {
                    return Center(child: CircularProgressIndicator.adaptive());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
