import 'package:flutter/material.dart';
import 'package:socialmedia/feature/screen/login.dart';
import 'package:socialmedia/feature/screen/nav_bar2/settings.dart';
import 'package:socialmedia/feature/screen/register.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  List<Tab> list = [Tab(text: 'login'), Tab(text: 'Sign in')];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: list.length,
      child: Builder(
        builder: (context) {
          return SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 40,
                ),
                child: Column(
                  children: [
                    Image.asset('assets/logo.png'),
                    SizedBox(height: 50),
                    TabBar(
                      indicatorColor: Colors.blue,
                      labelColor: Colors.black,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      dividerColor: Colors.grey,
                      controller: DefaultTabController.of(context),
                      tabs: list,
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: DefaultTabController.of(context),
                        children: [Login(), Register()],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
