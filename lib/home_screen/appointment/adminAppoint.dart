import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:timeline_tile/timeline_tile.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String current = auth.currentUser.phoneNumber;

class AdminAppointfb extends StatelessWidget {
  AdminAppointfb();

  @override
  Widget build(BuildContext context) {
    CollectionReference appointment =
        FirebaseFirestore.instance.collection('Appointments');

    return FutureBuilder<QuerySnapshot>(
      future: appointment.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = {};
          snapshot.data.docs.forEach((doc) {
            data.addAll(doc.data());
          });
          return Column(
            children: [
              for (var value in data.values)
                if (value['status'])
                  Row(children: [
                    Text(value['date']),
                  ])
            ],
          );
        }

        return Text("loading");
      },
    );
  }
}

class AdminAppoint extends StatefulWidget {
  @override
  _AdminAppointState createState() => new _AdminAppointState();
}

class _AdminAppointState extends State<AdminAppoint> {
  List<String> added = [];
  List<String> suggestions = [];
  String currentText = '';
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  SimpleAutoCompleteTextField textField;

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  Future<void> getUsers() async {
    FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                suggestions.add(doc.data()["name"]);
              }),
            });
  }

  _AdminAppointState() {
    textField = SimpleAutoCompleteTextField(
      key: key,
      decoration: new InputDecoration(labelText: "Client Name"),
      controller: TextEditingController(text: ""),
      suggestions: suggestions,
      textChanged: (text) => currentText = text,
      clearOnSubmit: true,
      textSubmitted: (text) => setState(() {
        if (text != "") {
          added.add(text);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (new Column(
        children: [new ListTile(title: textField), AdminAppointfb()]));
  }
}
