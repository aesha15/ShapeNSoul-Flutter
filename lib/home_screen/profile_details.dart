import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileDetails extends StatelessWidget {
  final String name;
  ProfileDetails({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference appointment =
        FirebaseFirestore.instance.collection('Users');
    print(name);
    return FutureBuilder<DocumentSnapshot>(
        future: appointment.doc(name).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          print(name);
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(data['name']),
                ),
                body: SizedBox(
                  child: Column(children: [
                    for (var ing in data['appointment'].keys)
                      Column(children: [
                        Text(ing + ":"),
                        Text(data['appointment'][ing])
                      ]),
                    for (var method in data['diet'].keys)
                      Column(children: [
                        Text(method),
                        Text(data['diet'][method]),
                      ]),
                  ]),
                  height: 1000.0,
                ));
          }
          return Text("loading");
        });
  }
}
