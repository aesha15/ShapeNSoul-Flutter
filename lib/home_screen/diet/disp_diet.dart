import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:timeline_tile/timeline_tile.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String current = auth.currentUser.phoneNumber;

class Diet extends StatefulWidget {
  @override
  _FirstPageState createState() => new _FirstPageState();
}

class _FirstPageState extends State<Diet> {
  List<String> time = [];
  List<String> recipe = [];

  @override
  void initState() {
    getDiet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new ListView.builder(
            itemCount: time.length,
            itemBuilder: (BuildContext ctxt, int Index) {
              return Row(
                  children: [Text(time[Index]), Text(":" + recipe[Index])]);
            }));
  }

  void getDiet() async {
    await Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser.phoneNumber)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      documentSnapshot.data()['diet'].forEach((t, r) {
        time.add(t);
        recipe.add(r);
      });
    });
  }
}
