import 'package:doctorappotments/Bottom%20Navigation/DoctorBottomNavigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Bottom Navigation/UserBottomNav.dart';
import 'Doctor/account.dart';
import 'Doctor/dashboard_edit.dart';
import 'ath/login.dart';

Future<void> main() async {
  //Firebase iInitialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}

