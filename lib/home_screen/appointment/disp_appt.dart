import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:timeline_tile/timeline_tile.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String current = auth.currentUser.phoneNumber;

class DispAppt extends StatelessWidget {
  DispAppt();

  @override
  Widget build(BuildContext context) {
    CollectionReference appointment =
        FirebaseFirestore.instance.collection('Appointments');

    return FutureBuilder<DocumentSnapshot>(
      future: appointment.doc('+918976305456').get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Column(
            children: [
              for (var value in data.values)
                if (value['status'])
                  Row(children: [
                    Text(value['therapy name'] + " "),
                    Text(value['time']),
                    Text(value['date'])
                  ])
                else
                  Row(
                    children: [
                      Text('-----------' + value['therapy name']),
                      Text(value['time']),
                      Text(value['date'])
                    ],
                  )
            ],
          );
        }

        return Text("loading");
      },
    );
  }
}
