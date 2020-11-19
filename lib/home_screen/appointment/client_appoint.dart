import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String current = auth.currentUser.phoneNumber;

class ClientAppoint extends StatefulWidget {
  @override
  ClientAppointState createState() => new ClientAppointState();
}

class ClientAppointState extends State<ClientAppoint> {
  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  Map<String, dynamic> data;
  final GlobalKey<AnimatedListState> _listkey = GlobalKey<AnimatedListState>();
  final Tween<Offset> offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));
  List<dynamic> _items = [];
  int counter = 0;
  List<dynamic> test = [];
  List<dynamic> prev = [];

  Future<void> _loadItems() async {
    FirebaseFirestore.instance
        .collection('Appointments')
        .doc('+918976305456')
        .get()
        .then((DocumentSnapshot documentSnapshot) => {
              documentSnapshot.data().forEach((key, value) {
                if (!value['date'].toDate().isBefore(DateTime.now())) {
                  // print(value);
                  test.add(value);
                } else {
                  // print(value);
                  prev.add(value);
                }
              }),
              test.sort((a, b) {
                return a['date'].toDate().compareTo(b['date'].toDate());
              }),
              prev.sort((b, a) {
                return a['date'].toDate().compareTo(b['date'].toDate());
              }),
              setState(() {}),
              please(test),
            });
  }

  please(text) async {
    for (var item in text) {
      // 1) Wait for one second
      await Future.delayed(Duration(milliseconds: 200));
      // 2) Adding data to actual variable that holds the item.
      _items.add(item);
      // 3) Telling animated list to start animation
      _listkey.currentState.insertItem(_items.length - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6fef6),
      body: Container(
        // decoration: new BoxDecoration(
        //     gradient: new LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [Color(0xfff6fef6), Color(0xffDCE9FA)],
        // )),
        child: ListView(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  ' Upcoming appointments : ',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: Colors.teal[900]),
                ),
              ),
              AnimatedList(
                  shrinkWrap: true,
                  key: _listkey,
                  initialItemCount: _items.length,
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
                                                _items[index]['date'].toDate()),
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
                                              _items[index]['time'],
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
                                              _items[index]['therapy name'],
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

                      // Text(_items[index]['therapy name']),
                      position: animate.drive(offset),
                    );
                  }),
              SizedBox(
                height: 19,
              ),
              ExpansionTile(
                title: Text(
                  ' Previous appointments ',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: Colors.blueGrey[600]),
                ),
                children: [
                  for (var value in prev)
                    if (value['date'].toDate().isBefore(DateTime.now()))
                      Column(children: [
                        Card(
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
                                          color: Colors.blueGrey[300],
                                          width: 6)),
                                  gradient: new LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xccffffff),
                                      Color(0xccEBFCE5),
                                      Color(0xccE8FBFA)
                                    ],
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(13.0),
                                child: Container(
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
                                            DateFormat.yMMMd()
                                                .format(value['date'].toDate()),
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
                                              value['time'],
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
                                              value['therapy name'],
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.blueGrey[800]),
                                              // color: Colors.green[900]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
                ],
              ),
            ])
          ],
        ),
      ),
    );
  }
}
