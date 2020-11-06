import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttersns/name2phone.dart';

import 'profile_details.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String current = auth.currentUser.phoneNumber;

class Profile extends StatefulWidget {
  @override
  _Profile createState() => new _Profile();
}

class _Profile extends State<Profile> {
  @override
  void initState() {
    getProfile();
    super.initState();
  }

  List<String> suggestions = [];
  String currentText = "";
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  SimpleAutoCompleteTextField textField;
  String submit = '';
  _Profile() {
    Row(
      children: [
        textField = SimpleAutoCompleteTextField(
          key: key,
          decoration: new InputDecoration(labelText: "Client Name"),
          controller: TextEditingController(text: ""),
          suggestions: suggestions,
          textChanged: (text) => currentText = text,
          clearOnSubmit: true,
          textSubmitted: (text) => setState(() {
            if (text != "") {
              if (text == "admin") {
                setState(() {
                  submit = '';
                });
              } else {
                setState(() {
                  submit = text;
                });
              }
            }
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        new ListTile(title: textField),
        ProfileStateless(
          name: submit,
        )
      ],
    ));
  }

  Future<void> getProfile() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                suggestions.add(doc.data()["name"]);
              }),
            });
  }
}

class ProfileStateless extends StatelessWidget {
  final String name;
  ProfileStateless({Key key, @required this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    CollectionReference appointment =
        FirebaseFirestore.instance.collection('Users');
    Widget list = Container(
      child: Text('loading'),
    );
    if (name == '') {
      list = FutureBuilder<QuerySnapshot>(
          future: appointment.get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  for (var name in snapshot.data.docs)
                    Card(
                      color: Colors.red,
                      child: InkWell(
                        child: Text(name['name']),
                        onTap: () {
                          var phone;
                          name2phone(name['name']).then((value) => {
                                phone = value,
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileDetails(name: phone),
                                    ))
                              });
                        },
                      ),
                    )
                ],
              );
            }
            return Text("loading");
          });
    } else {
      list = Card(
        color: Colors.red,
        child: InkWell(
          child: Text(name),
          onTap: () {
            var phone;
            name2phone(name).then((value) => {
                  phone = value,
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileDetails(name: phone),
                      ))
                });
          },
        ),
      );
    }
    return list;
  }
}
