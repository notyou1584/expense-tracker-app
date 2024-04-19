//import 'package:demo222/authscreens/auth_gate.dart';
import 'dart:io';

import 'package:demo222/authscreens/auth_gate.dart';
import 'package:demo222/authscreens/firebase_options.dart';
import 'package:demo222/authscreens/username.dart';
import 'package:demo222/utils/theme/app_theme.dart';
import 'package:demo222/utils/ui/choose_categories.dart';

import 'package:demo222/utils/ui/home.dart';
import 'package:demo222/utils/ui/settings_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:demo222/utils/ui/SplashScreen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider:
        ReCaptchaEnterpriseProvider('6LfjWGspAAAAAALNCpdLnHKck9EP02BOeUQaOszm'),
  );

  User? user = FirebaseAuth.instance.currentUser;
  String? userId = user?.uid;
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp(userId: userId));
}

class MyApp extends StatefulWidget {
  final String? userId;
  const MyApp({Key? key, required this.userId}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String userId = currentUser?.uid ?? '';
    return MaterialApp(
      title: 'expense-o',
      theme: MyThemes.lightTheme,
      home: SplashScreen(),
      routes: {
        '/auth': (_) => PhoneAuthScreen(),
        '/home': (_) => ExpenseTrackerHomeScreen(userId: userId),
        '/setings': (_) => SettingsScreen(),
        '/username': (_) => AddUsernameScreen(),
        '/categories': (_) => ChooseCategoriesScreen(userId: userId)
      },
    );
  }
}
