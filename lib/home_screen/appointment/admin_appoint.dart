import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'edit_appoint.dart';
import '../../name2phone.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String current = auth.currentUser.phoneNumber;

class AdminAppoint extends StatefulWidget {
  @override
  _AdminAppointState createState() => new _AdminAppointState();
}

class _AdminAppointState extends State<AdminAppoint> {
  final textFieldFocusNode = FocusNode();
  String added = '';
  List<String> suggestions = [];
  String currentText = '';
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  SimpleAutoCompleteTextField textField;
  final GlobalKey<AnimatedListState> _listkey = GlobalKey<AnimatedListState>();
  List<dynamic> appoint = [];
  List<dynamic> unSortedAppoint = [];
  final Tween<Offset> offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));

  @override
  void initState() {
    getUsers();
    allAppoint();
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

  allAppoint() {
    clearLists();
    FirebaseFirestore.instance
        .collection('Appointments')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((value) {
                value.data().forEach((key, value) {
                  if (!value['date'].toDate().isBefore(DateTime.now()))
                    unSortedAppoint.add(value);
                });
              }),
              unSortedAppoint.sort((a, b) {
                return a['date'].toDate().compareTo(b['date'].toDate());
              }),
              addDelay(unSortedAppoint)
            });
  }

  clearLists() {
    var length = unSortedAppoint.length;
    if (length > 0) {
      for (var i = 0; i < length; i++) {
        _listkey.currentState.removeItem(0, (context, animation) => null);
        unSortedAppoint.removeAt(0);
        appoint.removeAt(0);
      }
    }
  }

  addDelay(text) async {
    for (var item in text) {
      // 1) Wait for one second
      await Future.delayed(Duration(milliseconds: 80));
      // 2) Adding data to actual variable that holds the item.
      item['date'] = DateFormat.yMMMd().format(item['date'].toDate());
      appoint.add(item);
      // 3) Telling animated list to start animation
      try {
        _listkey.currentState.insertItem(appoint.length - 1);
      } on NoSuchMethodError catch (e) {
        print(e);
      }
    }
  }

  userAppoint(phone) {
    clearLists();
    FirebaseFirestore.instance
        .collection('Appointments')
        .doc(phone)
        .get()
        .then((DocumentSnapshot documentSnapshot) => {
              //test.removeRange(0, test.length - 1),
              documentSnapshot.data().forEach((key, value) {
                if (!value['date'].toDate().isBefore(DateTime.now()))
                  unSortedAppoint.add(value);
              }),
              unSortedAppoint.sort((a, b) {
                return a['date'].toDate().compareTo(b['date'].toDate());
              }),
              addDelay(unSortedAppoint)
            });
  }

  _AdminAppointState() {
    textField = SimpleAutoCompleteTextField(
      focusNode: textFieldFocusNode,
      key: key,
      controller: TextEditingController(text: ''),
      decoration: new InputDecoration(
        labelText: "Search Client",
        prefixIcon: Icon(Icons.search),
        suffixIcon: IconButton(
          onPressed: () => {
            setState(() {
              textFieldFocusNode.unfocus();
              textFieldFocusNode.canRequestFocus = false;
              textField.clear();
              allAppoint();

              Future.delayed(Duration(milliseconds: 100), () {
                textFieldFocusNode.canRequestFocus = true;
              });
            }),
          },
          icon: Icon(Icons.clear),
        ),
      ),
      suggestions: suggestions,
      textChanged: (text) => currentText = text,
      clearOnSubmit: false,
      textSubmitted: (text) => setState(() {
        // if (text != "") {
        if (text != '') {
          name2phone(text).then((value) => {userAppoint(value)});
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      backgroundColor: Color(0xfff6fef6),
      body: Container(
        child: ListView(
          children: [
            new ListTile(title: textField),
            AnimatedList(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                key: _listkey,
                initialItemCount: appoint.length,
                itemBuilder: (context, index, animate) {
                  return SlideTransition(
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9)),
                        child: InkWell(
                          splashColor: Colors.green.withAlpha(30),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditAppointment(
                                        title: jsonEncode(appoint[index]))));
                          },
                          child: ClipPath(
                            clipper: ShapeBorderClipper(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9))),
                            child: Container(
                                decoration: new BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            color: Colors.green[300],
                                            width: 6)),
                                    gradient: new LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xeeffffff),
                                        Color(0xeeEBFCE5),
                                        Color(0xeeE8FBFA)
                                      ],
                                    )),
                                child: Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Row(children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 23,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(15, 1, 1, 5),
                                                    child: Text(
                                                      appoint[index]
                                                          ['client name'],
                                                      style: TextStyle(
                                                        color:
                                                            Colors.green[900],
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(15, 1, 1, 5),
                                                    child: Text(
                                                      appoint[index]
                                                          ['therapy name'],
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(1, 1, 25, 5),
                                                    child: Text(
                                                      appoint[index]['date'],
                                                      style: TextStyle(
                                                        color:
                                                            Colors.green[900],
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(1, 1, 25, 5),
                                                    child: Text(
                                                      appoint[index]['time'],
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                        ]))),
                          ),
                        )),
                    // Text(appoint[index]['therapy name']),
                    position: animate.drive(offset),
                  );
                }),
          ],
        ),
      ),
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
