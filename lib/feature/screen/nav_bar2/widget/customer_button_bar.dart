import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:socialmedia/feature/screen/home/home_page.dart';
import 'package:socialmedia/feature/screen/nav_bar2/message.dart';
import 'package:socialmedia/feature/screen/nav_bar2/prefile_page.dart';
import 'package:socialmedia/feature/screen/nav_bar2/settings.dart';

class CustomerButtonBar extends StatefulWidget {
  const CustomerButtonBar({super.key});

  @override
  State<CustomerButtonBar> createState() => _CustomerButtonBarState();
}

class _CustomerButtonBarState extends State<CustomerButtonBar> {
  late final PersistentTabController controller;
  int index = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller,
      screens: [HomePage(), Message(), PrefilePage(), Settings()],

      items: [
        PersistentBottomNavBarItem(icon: Icon(Icons.home), title: 'Home'),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.group_add_outlined),
          title: 'Discovers',
        ),
        PersistentBottomNavBarItem(icon: Icon(Icons.person), title: 'Prefile'),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.settings),
          title: 'Settings',
        ),
      ],

      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen on a non-scrollable screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardAppears: true,
      // popBehaviorOnSelectedNavBarItemPress: PopActionScreensType.all,
      padding: const EdgeInsets.only(top: 8),
      backgroundColor: Colors.white,
      isVisible: true,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
        ),
      ),
      confineToSafeArea: true,
      navBarHeight: kBottomNavigationBarHeight,
      navBarStyle:
          NavBarStyle.style6, // Choose the nav bar style with this property
    );
  }
}
