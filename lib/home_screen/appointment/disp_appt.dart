import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

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
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              child: ListView(children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        ' Upcoming appointment',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            color: Colors.blue[600]),
                      ),
                    ),
                    for (var value in data.values)
                      if (value['status'])
                        Column(children: [
                          Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Card(
                                  color: const Color(0xfff6fef6),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        6, 6, 14, 3),
                                                child: Icon(
                                                  Icons.access_time,
                                                  size: 23,
                                                ),
                                              ),
                                              Text(
                                                value['date'],
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
                                              // Padding(
                                              //   padding: const EdgeInsets.fromLTRB(
                                              //       6, 3, 14, 3),
                                              // child: Icon(
                                              //   Icons.access_time,
                                              //   size: 15,
                                              // ),
                                              // ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 40),
                                                child: Text(
                                                  value['time'],
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Colors.blueGrey[800]),
                                                  // color: Colors.green[900]),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              // Padding(
                                              //   padding: const EdgeInsets.fromLTRB(
                                              //       6, 3, 14, 3),
                                              // child: Icon(
                                              //   Icons.brightness_1,
                                              //   size: 13,
                                              // ),
                                              // ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 40),
                                                child: Text(
                                                  value['therapy name'],
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Colors.blueGrey[800]),
                                                  // color: Colors.green[900]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))),
                        ]),

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        ' Previous appointments',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            color: Colors.blue[700]),
                      ),
                    ),

                    for (var value in data.values)
                      if (!value['status'])
                        Column(children: [
                          Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Card(
                                  color: const Color(0xddf6fef6),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        6, 6, 14, 3),
                                                child: Icon(
                                                  Icons.access_time,
                                                  size: 23,
                                                ),
                                              ),
                                              Text(
                                                value['date'],
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
                                              // Padding(
                                              //   padding: const EdgeInsets.fromLTRB(
                                              //       6, 3, 14, 3),
                                              // child: Icon(
                                              //   Icons.access_time,
                                              //   size: 15,
                                              // ),
                                              // ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 40),
                                                child: Text(
                                                  value['time'],
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Colors.blueGrey[800]),
                                                  // color: Colors.green[900]),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              // Padding(
                                              //   padding: const EdgeInsets.fromLTRB(
                                              //       6, 3, 14, 3),
                                              // child: Icon(
                                              //   Icons.brightness_1,
                                              //   size: 13,
                                              // ),
                                              // ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 40),
                                                child: Text(
                                                  value['therapy name'],
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Colors.blueGrey[800]),
                                                  // color: Colors.green[900]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))),
                        ]),

                    //       Padding(
                    //         padding: const EdgeInsets.all(15.0),
                    //         child: Text(
                    //           'Previous appointments',
                    //           style: TextStyle(
                    //               fontSize: 20,
                    //               fontWeight: FontWeight.w600,
                    //               fontStyle: FontStyle.italic),
                    //         ),
                    //       ),
                    //       for (var value in data.values)
                    //         if (!value['status'])
                    //           Row(children: [
                    //             Text('-----------' + value['therapy name'] + " "),
                    //             Text(value['time']),
                    //             Text(value['date'])
                    //           ])
                  ],
                ),
              ]),
            ),
          );
        }

        return Text("loading");
      },
    );
  }
}
