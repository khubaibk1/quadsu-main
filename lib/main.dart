import 'package:quadsu_app/pages/auth_module/splash_screen.dart';
import 'package:quadsu_app/provider/book_guide_provider.dart';
import 'package:quadsu_app/provider/bottom_tabbar_provider.dart';
import 'package:quadsu_app/provider/dash_board_provider.dart';
import 'package:quadsu_app/provider/instant_booking_provider.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/provider/notification_provider.dart';
import 'package:quadsu_app/provider/recording_provider.dart';
import 'package:quadsu_app/provider/search_guide_provider.dart';
import 'package:quadsu_app/provider/sessions_provider.dart';
import 'package:quadsu_app/provider/student_guide_provider.dart';
import 'package:quadsu_app/provider/transaction_provider.dart';
import 'package:quadsu_app/provider/withdraw_provider.dart';
import 'package:quadsu_app/provider/guide_schedule_provider.dart';
import 'package:quadsu_app/services/metting_services/meeting_provider.dart';
import 'package:quadsu_app/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:quadsu_app/provider/admin_settings_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'constants/global_keys.dart';
import 'provider/app_language_provider.dart';
import 'package:provider/provider.dart';

void changeStatusBarColor({
  Color statusBarColor = Colors.transparent,
  Color navigationBarColor = Colors.transparent,
}) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness:
        statusBarColor == Colors.white ? Brightness.dark : Brightness.light,
    systemNavigationBarIconBrightness:
        navigationBarColor == Colors.white ? Brightness.dark : Brightness.light,
    systemNavigationBarColor: statusBarColor, // NAVIGATION  BAR COLOR
    statusBarColor: navigationBarColor, // STATUS BAR COLOR
  ));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  changeStatusBarColor(statusBarColor: Colors.white);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => AppLanguageProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => AdminSettingsProvider(),
    ),
    //ChangeNotifierProvider(create: (context) => NotificationsProvider(),),
    ChangeNotifierProvider(
      create: (context) => BottomTabBarProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => MyAuthProvider(),
    ),
    ChangeNotifierProvider(create: (context) => DashBoardProvider()),
    ChangeNotifierProvider(create: (context) => SearchGuideProvider()),
    ChangeNotifierProvider(create: (context) => BookGuideProvider()),
    ChangeNotifierProvider(create: (context) => NotificationProvider()),
    ChangeNotifierProvider(create: (context) => SessionsProvider()),
    ChangeNotifierProvider(create: (context) => MeetingProvider()),
    ChangeNotifierProvider(create: (context) => InstantBookingProvider()),
    ChangeNotifierProvider(create: (context) => StudentGuideProvider()),
    ChangeNotifierProvider(create: (context) => TransactionProvider()),
    ChangeNotifierProvider(create: (context) => WithdrawProvider()),
    ChangeNotifierProvider(create: (context) => RecordingProvider()),
    ChangeNotifierProvider(create: (context) => GuideScheduleProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quadsu',
      theme: CustomAppThemes.lightTheme,
      debugShowCheckedModeBanner: false,
      navigatorKey: MyGlobalKeys.navigatorKey,
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
