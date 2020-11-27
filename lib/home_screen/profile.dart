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
          decoration: new InputDecoration(
            labelText: "Search Client",
            prefixIcon: Icon(Icons.search),
          ),
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
        backgroundColor: Color(0xfff6fef6),
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

  ProfileStateless({
    Key key,
    @required this.name,
  }) : super(key: key);
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
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    for (var name in snapshot.data.docs)
                      Card(
                        color: const Color(0xfff7fdf7),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 20,
                              child: Text(name['name'][0],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                              backgroundColor: Colors.green[200],
                            ),
                            trailing: Icon(Icons.navigate_next),
                            title: Text(
                              name['name'],
                              style: TextStyle(
                                  color: Colors.green[900],
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500),
                            ),
                            // subtitle: Text(
                            //   name['phone'],
                            //   style: TextStyle(
                            //       // color: Colors.green[900],
                            //       fontSize: 14,
                            //       fontWeight: FontWeight.w500),
                            // ),
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
                        ),
                      ),
                  ],
                ),
              );
            }
            return Text("loading");
          });
    } else {
      list = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              color: const Color(0xfff7fdf7),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    child: Text(name[0],
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500)),
                    backgroundColor: Colors.green[200],
                    // backgroundImage: CachedNetworkImageProvider(core.url + "profiles/" + friendlist[index]["avatar_id"]),
                  ),
                  trailing: Icon(Icons.navigate_next),
                  title: Text(
                    name,
                    style: TextStyle(
                        color: Colors.green[900],
                        fontSize: 21,
                        fontWeight: FontWeight.w500),
                  ),
                  // subtitle: Text(
                  //   name['phone'],
                  //   style: TextStyle(
                  //       // color: Colors.green[900],
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w500),
                  // ),
                  onTap: () {
                    var phone;
                    name2phone(name).then((value) => {
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
              ),
            ),
          ],
        ),
      );
    }

    return list;
  }
}
