import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';

class DispAppt extends StatefulWidget {
  DispAppt({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _DispApptState createState() => _DispApptState();
}

class _DispApptState extends State<DispAppt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Users').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  return new ListView(
                    children:
                        // snapshot.data.docs.map((DocumentSnapshot document) {
                        snapshot.data.docs
                            .where((element) =>
                                element.data()['appointment']['date'] != null)
                            .map((DocumentSnapshot document) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: Card(
                            color: const Color(0xfff6fef6),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.album),
                                    title: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: new Text(
                                        document.data()['name'] ?? '',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: new Text(
                                        document.data()['appointment']['date'] +
                                                '\n' +
                                                document.data()['appointment']
                                                    ['time'] +
                                                '\n' +
                                                document.data()['appointment']
                                                    ['therapy name'] ??
                                            '',
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ),
                                  )
                                ])),
                      );
                    }).toList(),
                  );
              }
            },
          )),
    ));
  }
}
