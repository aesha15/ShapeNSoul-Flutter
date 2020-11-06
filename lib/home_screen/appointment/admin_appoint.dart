import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../name2phone.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String current = auth.currentUser.phoneNumber;

class AdminAppointfb extends StatelessWidget {
  final name;
  AdminAppointfb({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference appointment =
        FirebaseFirestore.instance.collection('Appointments');
    Widget test = Container(
      child: Text('data'),
    );
    if (name == '') {
      test = FutureBuilder<QuerySnapshot>(
          future: appointment.get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = {};
              snapshot.data.docs.forEach((doc) {
                data.addAll(doc.data());
              });

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 1.4,
                      child: ListView(children: [
                        Column(children: [
                          for (var value in data.values)
                            if (value['status'])
                              Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Card(
                                          color: const Color(0xfff6fef6),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(18.0),
                                              child: Column(children: [
                                                Row(children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    size: 23,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  15, 1, 1, 5),
                                                          child: Text(
                                                            value[
                                                                'client name'],
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .green[900],
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  15, 1, 1, 5),
                                                          child: Text(
                                                            value[
                                                                'therapy name'],
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  1, 1, 25, 5),
                                                          child: Text(
                                                            value['date'],
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .green[900],
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  1, 1, 25, 5),
                                                          child: Text(
                                                            value['time'],
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                              ])),
                                        ))
                                  ])
                        ])
                      ]))
                ]),
              );
            }

            return Text("loading");
          });
    } else {
      test = FutureBuilder<DocumentSnapshot>(
          future: appointment.doc(name).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 1.4,
                      child: ListView(children: [
                        Column(children: [
                          for (var value in snapshot.data.data().values)
                            if (value['status'])
                              Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Card(
                                          color: const Color(0xfff6fef6),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(18.0),
                                              child: Column(children: [
                                                Row(children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    size: 23,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  15, 1, 1, 5),
                                                          child: Text(
                                                            value[
                                                                'client name'],
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .green[900],
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  15, 1, 1, 5),
                                                          child: Text(
                                                            value[
                                                                'therapy name'],
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  1, 1, 25, 5),
                                                          child: Text(
                                                            value['date'],
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .green[900],
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  1, 1, 25, 5),
                                                          child: Text(
                                                            value['time'],
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                              ])),
                                        ))
                                  ])
                        ])
                      ]))
                ]),
              );
            }

            return Text("loading");
          });
    }
    return test;
  }
}

class AdminAppoint extends StatefulWidget {
  @override
  _AdminAppointState createState() => new _AdminAppointState();
}

class _AdminAppointState extends State<AdminAppoint> {
  String added = '';
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
      decoration: new InputDecoration(labelText: "Search Client"),
      controller: TextEditingController(text: ""),
      suggestions: suggestions,
      textChanged: (text) => currentText = text,
      clearOnSubmit: false,
      textSubmitted: (text) => setState(() {
        if (text != "") {
          if (text == 'admin') {
            setState(() {
              added = '';
            });
          } else {
            name2phone(text).then((value) => setState(() {
                  added = value;
                }));
          }
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: SingleChildScrollView(
          child: new Column(children: [
        new ListTile(title: textField),
        AdminAppointfb(
          name: added,
        )
      ])),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/appointment');
        },
        backgroundColor: const Color(0xff3fc380),
      ),
    ));
  }
}
