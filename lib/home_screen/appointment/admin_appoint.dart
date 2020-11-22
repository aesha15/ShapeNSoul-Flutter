import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../name2phone.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String current = auth.currentUser.phoneNumber;

// class AdminAppointfb extends StatefulWidget {
//   final String name;
//   AdminAppointfb({Key key, @required this.name}) : super(key: key);
//   @override
//   State<StatefulWidget> createState() => new AdminAppointfbState();
// }

// class AdminAppointfbState extends State<AdminAppointfb> {
//   @override
//   void initState() {
//     _loadItems();
//     super.initState();
//   }

//   Map<String, dynamic> data;
//   final GlobalKey<AnimatedListState> _listkey = GlobalKey<AnimatedListState>();
//   final GlobalKey<AnimatedListState> _listkeyUser =
//       GlobalKey<AnimatedListState>();
//   final Tween<Offset> offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));
//   List<dynamic> _items = [];
//   List<dynamic> _userAppoint = [];
//   int counter = 0;
//   List<dynamic> test = [];
//   List<dynamic> user = [];

//   Future<void> _loadItems() async {
//     FirebaseFirestore.instance
//         .collection('Appointments')
//         .get()
//         .then((QuerySnapshot querySnapshot) => {
//               //test.removeRange(0, test.length - 1),
//               querySnapshot.docs.forEach((value) {
//                 value.data().forEach((key, value) {
//                   test.add(value);
//                 });
//               }),
//               test.sort((a, b) {
//                 return a['date'].toDate().compareTo(b['date'].toDate());
//               }),
//               addDelay(test)
//             });
//   }

//   addDelay(text) async {
//     for (var item in text) {
//       // 1) Wait for one second
//       await Future.delayed(Duration(milliseconds: 200));
//       // 2) Adding data to actual variable that holds the item.
//       // 3) Telling animated list to start animation
//       if (widget.name == '') {
//         _items.add(item);
//         _listkey.currentState.insertItem(_items.length - 1);
//       } else {
//         _userAppoint.add(item);
//         _listkeyUser.currentState.insertItem(_items.length - 1);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget test = Container(
//       child: Text('Loading'),
//     );
//     if (widget.name == '') {
//       test = AnimatedList(
//           shrinkWrap: true,
//           key: _listkey,
//           initialItemCount: _items.length,
//           itemBuilder: (context, index, animate) {
//             return SlideTransition(
//               child: Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(9)),
//                   child: ClipPath(
//                     clipper: ShapeBorderClipper(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(9))),
//                     child: Container(
//                       decoration: new BoxDecoration(
//                           border: Border(
//                               right: BorderSide(
//                                   color: Colors.green[300], width: 6)),
//                           gradient: new LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                             colors: [
//                               Color(0xeeffffff),
//                               Color(0xeeEBFCE5),
//                               Color(0xeeE8FBFA)
//                             ],
//                           )),
//                       child: Padding(
//                         padding: const EdgeInsets.all(13.0),
//                         child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               Row(
//                                 children: [
//                                   Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(6, 6, 14, 3),
//                                     child: Icon(
//                                       Icons.access_time,
//                                       size: 23,
//                                     ),
//                                   ),
//                                   Text(
//                                     DateFormat.yMMMd()
//                                         .format(_items[index]['date'].toDate()),
//                                     style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.green[900]),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 3,
//                               ),
//                               Row(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 40),
//                                     child: Text(
//                                       _items[index]['time'],
//                                       style: TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.blueGrey[800]),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 40),
//                                     child: Text(
//                                       _items[index]['therapy name'],
//                                       style: TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.blueGrey[800]),
//                                       // color: Colors.green[900]),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ]),
//                       ),
//                     ),
//                   )),

//               // Text(_items[index]['therapy name']),
//               position: animate.drive(offset),
//             );
//           });
//     }
//     return test;
//   }
// }

// class AdminAppointUser extends StatefulWidget {
//   final String name;
//   AdminAppointUser({Key key, @required this.name}) : super(key: key);
//   @override
//   State<StatefulWidget> createState() => new AdminAppointUserState();
// }

// class AdminAppointUserState extends State<AdminAppointUser> {
//   @override
//   void initState() {
//     _loadItems();
//     super.initState();
//   }

//   Map<String, dynamic> data;
//   final GlobalKey<AnimatedListState> _listkeyUser =
//       GlobalKey<AnimatedListState>();
//   final Tween<Offset> offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));
//   List<dynamic> _userAppoint = [];
//   int counter = 0;
//   List<dynamic> test = [];
//   List<dynamic> user = [];

//   Future<void> _loadItems() async {
//     FirebaseFirestore.instance
//         .collection('Appointments')
//         .doc(widget.name)
//         .get()
//         .then((DocumentSnapshot documentSnapshot) => {
//               //test.removeRange(0, test.length - 1),
//               documentSnapshot.data().forEach((key, value) {
//                 test.add(value);
//               }),
//               test.sort((a, b) {
//                 return a['date'].toDate().compareTo(b['date'].toDate());
//               }),
//               addDelay(test)
//             });
//   }

//   addDelay(text) async {
//     for (var item in text) {
//       // 1) Wait for one second
//       await Future.delayed(Duration(milliseconds: 200));
//       // 2) Adding data to actual variable that holds the item.
//       _userAppoint.add(item);
//       // 3) Telling animated list to start animation
//       _listkeyUser.currentState.insertItem(_userAppoint.length - 1);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedList(
//         shrinkWrap: true,
//         key: _listkeyUser,
//         initialItemCount: _userAppoint.length,
//         itemBuilder: (context, index, animate) {
//           return SlideTransition(
//             child: Card(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(9)),
//                 child: ClipPath(
//                   clipper: ShapeBorderClipper(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(9))),
//                   child: Container(
//                     decoration: new BoxDecoration(
//                         border: Border(
//                             right:
//                                 BorderSide(color: Colors.green[300], width: 6)),
//                         gradient: new LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             Color(0xeeffffff),
//                             Color(0xeeEBFCE5),
//                             Color(0xeeE8FBFA)
//                           ],
//                         )),
//                     child: Padding(
//                       padding: const EdgeInsets.all(13.0),
//                       child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Row(
//                               children: [
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(6, 6, 14, 3),
//                                   child: Icon(
//                                     Icons.access_time,
//                                     size: 23,
//                                   ),
//                                 ),
//                                 Text(
//                                   DateFormat.yMMMd().format(
//                                       _userAppoint[index]['date'].toDate()),
//                                   style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.green[900]),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 3,
//                             ),
//                             Row(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 40),
//                                   child: Text(
//                                     _userAppoint[index]['time'],
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.blueGrey[800]),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 40),
//                                   child: Text(
//                                     _userAppoint[index]['therapy name'],
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.blueGrey[800]),
//                                     // color: Colors.green[900]),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ]),
//                     ),
//                   ),
//                 )),

//             // Text(_userAppoint[index]['therapy name']),
//             position: animate.drive(offset),
//           );
//         });
//   }
// }

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
              //test.removeRange(0, test.length - 1),
              querySnapshot.docs.forEach((value) {
                value.data().forEach((key, value) {
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
    if (length > 1) {
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
      await Future.delayed(Duration(milliseconds: 200));
      // 2) Adding data to actual variable that holds the item.
      appoint.add(item);
      // 3) Telling animated list to start animation
      _listkey.currentState.insertItem(appoint.length - 1);
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
      key: key,
      decoration: new InputDecoration(
        labelText: "Search Client",
        prefixIcon: Icon(Icons.search),
      ),
      controller: TextEditingController(text: ""),
      suggestions: suggestions,
      textChanged: (text) => currentText = text,
      clearOnSubmit: false,
      textSubmitted: (text) => setState(() {
        if (text != "") {
          if (text == 'admin') {
            allAppoint();
          } else {
            name2phone(text).then((value) => {userAppoint(value)});
          }
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
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
                        child: ClipPath(
                          clipper: ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9))),
                          child: Container(
                            decoration: new BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        color: Colors.green[300], width: 6)),
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
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              6, 6, 14, 3),
                                          child: Icon(
                                            Icons.access_time,
                                            size: 23,
                                          ),
                                        ),
                                        Text(
                                          DateFormat.yMMMd().format(
                                              appoint[index]['date'].toDate()),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green[900]),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 40),
                                          child: Text(
                                            appoint[index]['time'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blueGrey[800]),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 40),
                                          child: Text(
                                            appoint[index]['therapy name'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blueGrey[800]),
                                            // color: Colors.green[900]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
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
