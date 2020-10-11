import 'package:flutter/material.dart';
import 'login_screen/login_screen.dart';
import 'otp_screen/otp_screen.dart';
import 'home_screen/home_screen.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter OTP Authentication',
      theme: ThemeData(
        primaryColor: const Color(0xff3fc380),
      ),
      home: Home(),
      routes: <String, WidgetBuilder>{
        '/otpScreen': (BuildContext ctx) => OtpScreen(),
        '/homeScreen': (BuildContext ctx) => Home(),
        '/logout': (BuildContext ctx) => LoginScreen(),
      },
    );
  }
}
