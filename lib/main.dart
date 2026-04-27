import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/core/app_service.dart';
import 'package:socialmedia/feature/screen/cubit/login_and_register_cubit.dart';
import 'package:socialmedia/feature/screen/auth_page.dart';
import 'package:socialmedia/feature/screen/cubit/login_and_register_state.dart';
import 'package:socialmedia/feature/screen/home/cubit/stories_cubit_cubit.dart';
import 'package:socialmedia/feature/screen/home/home_page.dart';
import 'package:socialmedia/feature/screen/login.dart';
import 'package:socialmedia/feature/screen/nav_bar2/data/cubit/cubit/cubit/folowwing_dart_cubit.dart';
import 'package:socialmedia/feature/screen/nav_bar2/data/cubit/prefile_state_cubit.dart';
import 'package:socialmedia/feature/screen/nav_bar2/widget/customer_button_bar.dart';
import 'package:socialmedia/feature/screen/register.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginAndRegisterCubit()),
        BlocProvider(create: (context) => StoriesCubitCubit()),
        BlocProvider(create: (context) => PrefileStateCubit()),
        BlocProvider(create: (context) => FolowwingDartCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.white)),
        home: user != null ? CustomerButtonBar() : AuthPage(),
      ),
    );
  }
}
