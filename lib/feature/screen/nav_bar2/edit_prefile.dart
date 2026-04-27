import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/feature/data/model_user.dart';
import 'package:socialmedia/feature/screen/nav_bar2/data/cubit/prefile_state_cubit.dart';

class EditPrefile extends StatefulWidget {
  final ModelUser user;
  const EditPrefile({super.key, required this.user});

  @override
  State<EditPrefile> createState() => _EditPrefileState();
}

class _EditPrefileState extends State<EditPrefile> {
  final username = TextEditingController();
  final title = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    username.text = widget.user.username;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PrefileStateCubit>();
    return Scaffold(
      appBar: AppBar(title: Text('Edit prefile'), elevation: 3),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://images.pexels.com/photos/268941/pexels-photo-268941.jpeg',
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 40,
                    child: CircleAvatar(
                      radius: 10,
                      child: Icon(Icons.upload, color: Colors.red, size: 20),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                controller: username,
                decoration: InputDecoration(
                  hint: Text('Name'),
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextField(
                controller: title,
                decoration: InputDecoration(
                  hint: Text('Title'),
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
              ),
              SizedBox(height: 10),

              BlocConsumer<PrefileStateCubit, PrefileStateState>(
                buildWhen: (previous, current) =>
                    current is EditPrefilepostfailure ||
                    current is EditPrefilepostloading ||
                    current is EditPrefilepostsucces,
                listener: (context, state) {
                  if (state is EditPrefilepostfailure) {
                    print(state.error);
                  } else if (state is EditPrefilepostsucces) {
                    Navigator.of(context).pop(true);
                  }
                },
                builder: (context, state) {
                  if (state is EditPrefilepostloading) {
                    return ElevatedButton(
                      onPressed: null,

                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return ElevatedButton(
                    onPressed: () async {
                      await cubit.editprefile(
                        username: username.text,
                        title: title.text,
                      );
                    },

                    style: TextButton.styleFrom(backgroundColor: Colors.blue),
                    child: Text(
                      'Change save',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
