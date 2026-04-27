import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/feature/data/model_user.dart';
import 'package:socialmedia/feature/screen/home/model/post_model.dart';
import 'package:socialmedia/feature/screen/nav_bar2/data/cubit/prefile_state_cubit.dart';
import 'package:socialmedia/feature/screen/nav_bar2/edit_prefile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Postheader extends StatefulWidget {
  final ModelUser user;
  const Postheader({super.key, required this.user});

  @override
  State<Postheader> createState() => _PostheaderState();
}

class _PostheaderState extends State<Postheader> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final cubit = context.read<PrefileStateCubit>();
    return Column(
      children: [
        SizedBox(
          height: size.height * .38,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                      'https://images.pexels.com/photos/268941/pexels-photo-268941.jpeg',
                    ),
                  ),
                ),
              ),
              Positioned(
                right: size.width * .5 - 50,
                bottom: 0,
                left: size.width * .5 - 50,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    shape: BoxShape.circle,
                  ),
                  height: 100,
                  width: 100,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      Supabase.instance.client.storage
                          .from('image')
                          .getPublicUrl(widget.user.image),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        Text(
          widget.user.username,
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 5),
        Text(widget.user.email, style: Theme.of(context).textTheme.titleMedium),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => EditPrefile(user: widget.user),
                  ),
                )
                .then((_) => cubit.getuserdata());
          },

          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          child: Text('EDIT PREFILE'),
        ),
      ],
    );
  }
}
