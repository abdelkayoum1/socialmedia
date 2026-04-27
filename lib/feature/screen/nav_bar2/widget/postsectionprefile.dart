import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/feature/data/model_user.dart';
import 'package:socialmedia/feature/screen/nav_bar2/data/cubit/cubit/cubit/folowwing_dart_cubit.dart';
import 'package:socialmedia/feature/screen/nav_bar2/data/cubit/prefile_state_cubit.dart';

class Postsetionprefile extends StatefulWidget {
  final ModelUser user;
  // final Future cubit;
  const Postsetionprefile({super.key, required this.user});

  @override
  State<Postsetionprefile> createState() => _PostsetionprefileState();
}

class _PostsetionprefileState extends State<Postsetionprefile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            BlocBuilder<PrefileStateCubit, PrefileStateState>(
              buildWhen: (previous, current) =>
                  current is Prefilepostloading || current is Prefilepostsucces,
              builder: (context, state) {
                if (state is Prefilepostsucces) {
                  return Widgett(
                    value: state.user.postcount.toString(),
                    label: 'Posts',
                  );
                }
                return Widgett(
                  value: widget.user.postcount.toString(),
                  label: 'Posts',
                );
              },
            ),
            VerticalDivider(color: Colors.black, width: 2, thickness: 0.5),
            BlocBuilder<PrefileStateCubit, PrefileStateState>(
              buildWhen: (previous, current) =>
                  current is PrefileStatelaoding ||
                  current is PrefileStatesucces,
              builder: (context, state) {
                if (state is PrefileStatesucces) {
                  return Widgett(
                    value: state.user!.folowwers?.length.toString() ?? '0',
                    label: 'Followers',
                  );
                }
                return Widgett(
                  value: widget.user.folowwers?.length.toString() ?? '0',
                  label: 'Followers',
                );
              },
            ),
            VerticalDivider(color: Colors.black, width: 2, thickness: 0.5),

            BlocBuilder<FolowwingDartCubit, FolowwingDartState>(
              buildWhen: (previous, current) =>
                  current is Followingfailuree ||
                  current is Followinglaodingg ||
                  current is Followingsuccess,
              builder: (context, state) {
                if (state is Followingsuccess) {
                  return Widgett(
                    value: state.user.following?.length.toString() ?? '0',
                    label: 'Following',
                  );
                }
                return Widgett(
                  value: widget.user.following?.length.toString() ?? '0',
                  label: 'Following',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Widgett extends StatelessWidget {
  final String label;
  final String value;
  const Widgett({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Column(children: [Text(value), Text(label)]));
  }
}
