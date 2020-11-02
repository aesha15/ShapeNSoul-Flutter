import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:timeline_tile/timeline_tile.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String current = auth.currentUser.phoneNumber;

// DocumentReference documentRef =
//     FirebaseFirestore.instance.collection('Users').doc(current);

// Future<Map> getDiet(BuildContext context) {
//   var document = FirebaseFirestore.instance.collection('Users').doc(current);
//   return document.get().then((documentSnapshot) {
//     final x = documentSnapshot.data();
//     print('Document data: ${documentSnapshot.data()['diet']}');
//     return x;
//   });
//   // return("Hi ");
// }

class Diet extends StatelessWidget {
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());
          default:
            return new ListView(
                // children: snapshot.data.docs
                //     .map((DocumentSnapshot document) =>
                //         new Text(document.data()['diet'].toString()))
                //     .toList());

                children: snapshot.data.docs
                    .map((DocumentSnapshot document) =>
                        new Text(document.data()['diet'].toString()))
                    .toList());
        }
      },
    );
  }
}
