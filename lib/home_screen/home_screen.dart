import 'package:flutter/material.dart';
import 'package:fluttersns/home_screen/appointment.dart';
import 'package:fluttersns/home_screen/chat.dart';
import 'package:fluttersns/home_screen/diet.dart';
import 'package:fluttersns/home_screen/profile.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Appointment(),
    Diet(),
    Profile(),
  ];

  FirebaseAuth auth = FirebaseAuth.instance;

  signOut() async {
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Shape N Soul'),
          // centerTitle: true,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            // Text("Logout",
            //     style: TextStyle(
            //       fontSize: 18,
            //     )),
            IconButton(
              icon: new Icon(Icons.exit_to_app),
              onPressed: () {
                signOut();
                Navigator.pushReplacementNamed(context, "/logout");
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
            title: new Text('Appointments'),
          ),
          // new BottomNavigationBarItem(
          //   icon: new Icon(Icons.chat_bubble_outline),
          //   title: new Text('Chat'),
          // ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.assignment),
            title: new Text('Diet'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), title: Text('Profile'))
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.chat),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Chat()),
          );
        },
        backgroundColor: const Color(0xff3fc380),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
