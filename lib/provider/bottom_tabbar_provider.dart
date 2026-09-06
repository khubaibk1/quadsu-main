import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/global_keys.dart';
import 'package:quadsu_app/pages/student_module/session_screen.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import '../pages/guide_module/edit_guide_profile_screen.dart';
import '../pages/guide_module/guide_home_screen.dart';
import '../pages/student_module/edit_profile.dart';
import '../pages/student_module/home_screen.dart';
import '../pages/student_module/messages_screen.dart';
import '../pages/student_module/my_guides_screen.dart';
import '../pages/guide_module/schedule_components/guide_schedule_tabs_screen.dart';

String searchGuideValue = "";

class BottomTabBarProvider extends ChangeNotifier {
  int currentIndex = 0;

  var tabs = [
    const HomeScreen(),
    const MessagesScreen(),
    const MyStudentGuidesScreen(),
    const SessionScreen(),
    const EditProfile(),
  ];
  var guideTabs = [
    const GuideHomeScreen(),
    const MessagesScreen(),
    const MyStudentGuidesScreen(),
    const GuideScheduleTabsScreen(),
    const EditGuideProfileScreen(),
  ];

  changeIndex({required int index}) {
    if (userDataNotifier.value == null) {
      if (index == 2 || index == 3 || index == 4) {
        Provider.of<MyAuthProvider>(MyGlobalKeys.navigatorKey.currentContext!,
                listen: false)
            .logout(MyGlobalKeys.navigatorKey.currentContext!);
        currentIndex = 0;
        return;
      }
    }

    // Handle search navigation separately
    if (index == 99) {
      // Special index for search
      currentIndex = 0; // Stay on home but show search screen
      notifyListeners();
      return;
    }

    currentIndex = index;
    notifyListeners();
  }

  void navigateToSearch() {
    // Navigate to search screen without changing bottom nav
    // This will be handled in the UI layer
  }

  reload() {
    notifyListeners();
  }
}
