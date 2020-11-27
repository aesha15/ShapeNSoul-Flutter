import 'package:flutter/material.dart';
// import 'package:fluttersns/appts/test1.dart';
import 'package:fluttersns/home_screen/appointment/new_appoint.dart';
// import 'package:fluttersns/home_screen/chat.dart';
import 'package:fluttersns/home_screen/diet/add_recipe.dart';
import 'package:fluttersns/home_screen/profile.dart';
import 'package:fluttersns/home_screen/profile_details.dart';
// import 'package:fluttersns/Imagedownload.dart';
import 'login_screen/login_screen.dart';
import 'otp_screen/otp_screen.dart';
import 'home_screen/home_screen.dart';
import 'splash_screen.dart';
// import 'package:fluttersns/home_screen/appointment/client_appoint.dart';
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
        primaryColor: Color(0xff3fc380),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext ctx) => SplashScreen(),
        '/otp': (BuildContext ctx) => OtpScreen(),
        '/home': (BuildContext ctx) => Home(),
        '/login': (BuildContext ctx) => LoginScreen(),
        // '/client_appt': (BuildContext ctx) => ClientAppoint(),
        '/appointment': (BuildContext ctx) => Appointment(),
        '/add_recipe': (BuildContext ctx) => AddRecipe(),
        '/profile': (BuildContext ctx) => Profile(),
      },
    );
  }
}
