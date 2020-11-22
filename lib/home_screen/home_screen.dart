import 'package:flutter/material.dart';
import 'package:fluttersns/home_screen/appointment/client_appoint.dart';
import 'package:fluttersns/home_screen/appointment/admin_appoint.dart';
// import 'package:fluttersns/home_screen/chat.dart';
import 'package:fluttersns/home_screen/diet/client_diet.dart';
import 'package:fluttersns/home_screen/diet/admin_diet.dart';

import 'package:fluttersns/home_screen/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  FirebaseAuth auth = FirebaseAuth.instance;
  final List<Widget> _children = [
    (FirebaseAuth.instance.currentUser.phoneNumber != '+918976305456')
        ? AdminAppoint()
        : ClientAppoint(),
    (FirebaseAuth.instance.currentUser.phoneNumber == '+918976305456')
        ? AdminDiet()
        : Diet(),
    Profile(),
  ];

  signOut() async {
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Shape N Soul'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
                icon: new Icon(Icons.forum),
                onPressed: () {
                  Navigator.pushNamed(context, '/chat');
                }),
            IconButton(
              icon: new Icon(Icons.exit_to_app),
              onPressed: () {
                showAlertDialog(context, 'Are you sure?');
              },
            ),
          ]),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          new BottomNavigationBarItem(
            icon: new Icon(Icons.calendar_today),
            title: Text('Appointments'),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.description),
            title: Text('Diet'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), title: Text('Profile'))
        ],
      ),
    );
  }

  void showAlertDialog(BuildContext context, String message) {
    // set up the AlertDialog
    Widget cancelButton = FlatButton(
      child: Text(
        "No",
        style: TextStyle(fontSize: 20),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
        child: Text(
          "Yes",
          style: TextStyle(fontSize: 18),
        ),
        onPressed: () {
          signOut();
          Navigator.pushReplacementNamed(context, "/login");
        });

    AlertDialog alert = AlertDialog(
        title: const Text(
          "LOGOUT",
          style: TextStyle(fontSize: 21),
        ),
        content: Text(
          '\n$message',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          cancelButton,
          continueButton,
        ]);
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
