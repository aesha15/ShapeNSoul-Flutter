import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttersns/home_screen/appointment/client_appoint.dart';
import 'package:fluttersns/home_screen/appointment/admin_appoint.dart';
import 'package:fluttersns/home_screen/diet/client_diet.dart';
import 'package:fluttersns/home_screen/diet/admin_diet.dart';

import '../notification.dart';
import 'package:fluttersns/home_screen/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  FirebaseAuth auth = FirebaseAuth.instance;
  String phone = '';
  final List<Widget> _children = [
    (FirebaseAuth.instance.currentUser.phoneNumber == '+918976305456')
        ? AdminAppoint()
        : ClientAppoint(),
    (FirebaseAuth.instance.currentUser.phoneNumber != '+918976305456')
        ? AdminDiet()
        : Diet(),
    if (FirebaseAuth.instance.currentUser.phoneNumber == '+918976305456')
      Profile()
  ];

  @override
  initState() {
    initialise();
    super.initState();
  }

  signOut() async {
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Shape N Soul',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              )),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Color(0xff84EBAB), Color(0xff3fc380)])),
          ),
          automaticallyImplyLeading: false,
          // backgroundColor: Color(0xfff6fef6),
          actions: <Widget>[
            IconButton(
              icon: new Icon(Icons.exit_to_app),
              onPressed: () {
                showAlertDialog(context, 'Are you sure?');
              },
            ),
          ]),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        backgroundColor: Color(0xfff6fef6),
        // selectedItemColor: Colors.white,
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
          if (FirebaseAuth.instance.currentUser.phoneNumber == '+918976305456')
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
          Navigator.pushNamedAndRemoveUntil(
              context, "/login", ModalRoute.withName('/login'));
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

  void initialise() {
    phone = auth.currentUser.phoneNumber;
    FirebaseFirestore.instance
        .collection('Appointments')
        .doc(phone)
        .snapshots()
        .listen((DocumentSnapshot querySnapshot) {
      querySnapshot.data().forEach((key, value) {
        if (!value['date'].toDate().isBefore(DateTime.now())) {
          notificationPlugin.scheduleNotification(
              value['date'].toDate().toLocal().subtract(Duration(hours: 1)));
        }
      });
    });
  }
}
