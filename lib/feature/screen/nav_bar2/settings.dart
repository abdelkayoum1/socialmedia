import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/feature/screen/auth_page.dart';
import 'package:socialmedia/feature/screen/nav_bar2/data/cubit/cubit/settings_dart_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsDartCubit(),

      child: Scaffold(
        appBar: AppBar(title: Text('Parametre'), elevation: 3),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Accounts'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('notification'),
                  ),
                ),
                BlocConsumer<SettingsDartCubit, SettingsDartState>(
                  listener: (context, state) {
                    if (state is SettingsDartfailure) {
                      print(state.error);
                    }
                    if (state is SettingsDartsucces) {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => AuthPage()),
                        (route) => true,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is SettingsDartloading) {
                      return ListTile(
                        onTap: null,
                        // leading: Icon(Icons.logout),
                        title: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                    }
                    return Card(
                      child: ListTile(
                        onTap: () async {
                          await context.read<SettingsDartCubit>().logout();
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => AuthPage()),
                            (route) => true,
                          );
                        },
                        leading: Icon(Icons.logout),
                        title: Text('Logout'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
