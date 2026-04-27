import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/feature/screen/cubit/login_and_register_cubit.dart';
import 'package:socialmedia/feature/screen/cubit/login_and_register_state.dart';
import 'package:socialmedia/feature/screen/nav_bar2/widget/customer_button_bar.dart';
import 'package:socialmedia/feature/screen/wiedget/button.dart';
import 'package:socialmedia/feature/screen/wiedget/textfieledd.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final key = GlobalKey<FormState>();
  bool ischecked = false;
  final email = TextEditingController();
  final password = TextEditingController();
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
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => CustomerButtonBar(),
                      ),
                    );
                  } else if (state is Loginandregisterfailure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.msj)));
                  }
                },
                buildWhen: (previous, current) =>
                    current is Loginandregisterloading ||
                    current is Loginandregistersucces ||
                    current is Loginandregisterfailure,
                builder: (context, state) {
                  if (state is Loginandregisterloading) {
                    return Button(
                      ontab: null,
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return Button(
                    ontab: () {
                      if (key.currentState!.validate()) {
                        cubit.login(email.text, password.text);
                      }
                    },
                    child: Text('Login'),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text('Forget Password?'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have account ?'),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Sign In',
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
}
