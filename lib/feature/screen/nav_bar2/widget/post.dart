import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' show basename;
import 'package:socialmedia/feature/screen/home/cubit/stories_cubit_cubit.dart';
import 'package:socialmedia/feature/screen/nav_bar2/data/cubit/prefile_state_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Post extends StatefulWidget {
  final Future<void>? cubit;
  const Post({super.key, this.cubit});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  File? fileimage;
  String? imagepath;
  String? imagepath1;
  final text = TextEditingController();
  final user = Supabase.instance.client.auth.currentUser;

  Future<String?> upload() async {
    ImagePicker image = ImagePicker();
    try {
      final imagefile = await image.pickImage(source: ImageSource.gallery);
      if (imagefile != null) {
        setState(() {
          fileimage = File(imagefile.path);
          imagepath = basename(imagefile.path);

          final int = Random().nextInt(9999);
          imagepath = '$int$imagepath';
        });
      } else {
        /*
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('no images selected')));
        */
      }
    } catch (e) {
      rethrow;
    }
    return imagepath;
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: BlocConsumer<StoriesCubitCubit, StoriesCubitState>(
              listener: (context, state) {
                if (state is Createpostsucces) {
                  context.read<PrefileStateCubit>().fetchuserpost();
                  context.read<PrefileStateCubit>().fetchuserpostdetail();

                  if (!mounted) return;
                  Navigator.of(context).pop(context);
                } else if (state is Createpostfailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              builder: (context, state) {
                if (state is Createpostloading) {
                  return ElevatedButton(
                    onPressed: null,
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                return ElevatedButton(
                  onPressed: () async {
                    final image1 = await upload();

                    if (image1 == null) {
                      print('no image');
                      return;
                    }
                    await Supabase.instance.client.storage
                        .from('image')
                        .update(image1, fileimage!);
                    print('444444444');
                    if (!mounted) return;
                    context.read<StoriesCubitCubit>().createpost(
                      text: text.text,
                      image: image1,
                      id: user!.id,
                    );

                    print('2222222222222222222222222222222222222222');

                    print('image$imagepath');
                  },
                  child: Text(
                    'post',
                    style: TextStyle(
                      color: text.text.isNotEmpty
                          ? const Color.fromARGB(255, 8, 42, 103)
                          : Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
            child: Column(
              children: [
                BlocBuilder<StoriesCubitCubit, StoriesCubitState>(
                  buildWhen: (previous, current) =>
                      current is Fetchuserdatafailure ||
                      current is Fetchuserdataloading ||
                      current is Fetchuserdatasucces,
                  builder: (context, state) {
                    if (state is Fetchuserdatafailure) {
                      return Center(child: Text(state.error));
                    } else if (state is Fetchuserdatasucces) {
                      final image1 = state.post.image.isNotEmpty
                          ? Supabase.instance.client.storage
                                .from('image')
                                .getPublicUrl(state.post.image)
                          : Image.asset('name');
                      return Row(
                        children: [
                          Container(
                            width: 50,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,

                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                image1.toString(),

                                // errorWidget: (context, url, error) =>
                                //   Icon(Icons.error),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            state.post.username.toString(),
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                  },
                ),
                TextField(
                  controller: text,
                  maxLines: 5,
                  onChanged: (_) {
                    setState(() {});
                  },

                  decoration: InputDecoration(
                    hint: Text('What\'t on your Mind'),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
                SizedBox(height: 10),

                fileimage == null
                    ? Image.asset('assets/avatar.png', width: 90)
                    : Image.file(fileimage!),
                SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () async {
                    await upload();
                    if (imagepath != null) {
                      await Supabase.instance.client.storage
                          .from('image')
                          .upload(
                            imagepath!,
                            fileimage!,
                            fileOptions: FileOptions(upsert: true),
                          );
                    } else {
                      print('no');
                    }

                    if (user != null) {
                      await Supabase.instance.client
                          .from('post')
                          .update({'image': imagepath})
                          .eq('user_id', user.id);
                    }

                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  child: Text('Upload image'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    print(text.text);
                  },
                  child: Text('publier supabase'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
