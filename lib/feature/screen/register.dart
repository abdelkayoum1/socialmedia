import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' show basename;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialmedia/feature/screen/auth_page.dart';
import 'package:socialmedia/feature/screen/cubit/login_and_register_cubit.dart';
import 'package:socialmedia/feature/screen/cubit/login_and_register_state.dart';
import 'package:socialmedia/feature/screen/login.dart';
import 'package:socialmedia/feature/screen/wiedget/button.dart';
import 'package:socialmedia/feature/screen/wiedget/textfieledd.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final key = GlobalKey<FormState>();
  bool ischecked = false;
  final email = TextEditingController();
  final password = TextEditingController();
  final username = TextEditingController();
  File? imagefile;
  String? imagepath1;
  void upload(ImageSource source) async {
    ImagePicker image = ImagePicker();
    final imagepath = await image.pickImage(source: source);
    try {
      if (imagepath != null) {
        setState(() {
          imagefile = File(imagepath.path);
          imagepath1 = basename(imagepath.path);
          print(imagefile);
          print(imagepath1);
          final cpt = Random();
          final randomNumber = cpt.nextInt(100000);
          imagepath1 = '$randomNumber$imagepath1';
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('no image selected')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LoginAndRegisterCubit>(context);
    return Material(
      child: SingleChildScrollView(
        child: Form(
          key: key,
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: [
                    imagefile == null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage('assets/avatar.png'),
                            backgroundColor: Colors.grey,
                            //child: Image.file(imagefile!),
                          )
                        : ClipOval(
                            child: Image.file(
                              imagefile!,
                              width: 110,
                              height: 110,
                              fit: BoxFit.cover,
                            ),
                          ),

                    Positioned(
                      bottom: -10,
                      left: 70,
                      child: IconButton(
                        onPressed: () {
                          showmodelcontainer(context);
                        },
                        icon: Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              Textfieledd(
                controlle: username,
                labelText: 'username',
                prefixicon: Icon(Icons.person),
                obscureText: false,
                text: 'username',
              ),
              SizedBox(height: 20),
              Textfieledd(
                controlle: email,
                labelText: 'Email',
                obscureText: false,
                text: 'Email',
                prefixicon: Icon(Icons.email),
              ),

              SizedBox(height: 20),

              Textfieledd(
                controlle: password,
                labelText: 'password',
                obscureText: ischecked ? false : true,
                text: 'password',
                prefixicon: Icon(Icons.password),
                sufixicon: IconButton(
                  onPressed: () {
                    setState(() {
                      ischecked = !ischecked;
                    });
                  },
                  icon: Icon(
                    ischecked ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
              SizedBox(height: 20),

              BlocConsumer<LoginAndRegisterCubit, LoginAndRegisterState>(
                listener: (context, state) {
                  if (state is Loginandregistersucces) {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (context) => AuthPage()));
                  } else if (state is Loginandregisterfailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.msj),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is Loginandregisterloading) {
                    return Button(
                      ontab: null,
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return Button(
                    ontab: () async {
                      if (key.currentState!.validate() &&
                          imagefile != null &&
                          imagepath1 != null) {
                        await cubit.sign(
                          email.text,
                          password.text,
                          username.text,
                          imagepath1!,
                        );
                        print(
                          "USER: ${Supabase.instance.client.auth.currentUser}",
                        );

                        await Supabase.instance.client.storage
                            .from('image')
                            .upload(imagepath1!, imagefile!);
                      } else {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('error')));
                      }
                    },
                    child: Text('register'),
                  );
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(' have your account ?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text(
                      'Login',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showmodelcontainer(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          height: 150,
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  upload(ImageSource.gallery);
                  Navigator.pop(context);
                },
                leading: Icon(Icons.photo),
                title: Text('photo'),
              ),

              ListTile(
                onTap: () {
                  upload(ImageSource.camera);
                  Navigator.pop(context);
                },
                leading: Icon(Icons.camera),
                title: Text('Camera'),
              ),
            ],
          ),
        );
      },
    );
  }
}
