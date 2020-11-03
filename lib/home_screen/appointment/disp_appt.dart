import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:timeline_tile/timeline_tile.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String current = auth.currentUser.phoneNumber;

class DispAppt extends StatefulWidget {
  @override
  _FirstPageState createState() => new _FirstPageState();
}

class _FirstPageState extends State<DispAppt> {
  List<String> key = [];
  List<String> value = [];
  List<String> keyDone = [];
  List<String> valueDone = [];

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new ListView.builder(
            itemCount: key.length,
            itemBuilder: (BuildContext ctxt, int Index) {
              return Row(
                  children: [Text(key[Index]), Text(":" + value[Index])]);
            }));
  }

  Future<void> getUser() async {
    await Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection('Appointments')
        .doc('+918976305456')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      documentSnapshot.data().forEach((k, v) {
        key.add(k);
        value.add(v);
      });
    });
  }
}
