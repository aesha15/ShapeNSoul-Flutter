//import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fluttersns/splash_screen.dart';
import 'recipe.dart';
// import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:timeline_tile/timeline_tile.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String current = auth.currentUser.phoneNumber;

class Diet extends StatefulWidget {
  DietState createState() => new DietState();
}

class DietState extends State<Diet> {
  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  Map<String, dynamic> data;
  final GlobalKey<AnimatedListState> _listkey = GlobalKey<AnimatedListState>();
  final Tween<Offset> offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));
  List<dynamic> _items = [];
  int counter = 0;
  List<dynamic> test = [];
  List<dynamic> keys = [];
  List<dynamic> values = [];
  List<dynamic> ord = [];
  Map<String, String> urls = {};
  Map tes;
  List<Map> aaa = [];

  Future<void> _loadItems() async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc('+918976305456')
        .get()
        .then((DocumentSnapshot documentSnapshot) => {
              documentSnapshot.data()['diet'].entries.forEach((e) {
                keys.add(e.key);
                values.add(e.value);

                // tes = Map.fromIterable(e);
                // print(tes);

                // tes.addEntries(e);
                // print(tes);

                // aaa..sort();
                // print(aaa);

                // test.add(e.value);
              }),

              tes = Map.fromIterables(keys, values),
              tes.keys.toList().sort((a, b) {
                return a.compareTo(b);
              }),
              // aaa.add(tes),
              addDelay(tes.values.toList()),
            });
  }

  addDelay(text) async {
    for (var item in text) {
      // 1) Wait for one second
      await Future.delayed(Duration(milliseconds: 80));
      // 2) Adding data to actual variable that holds the item.
      getImage(item).then((value) => {
            urls[item] = value,
          });
      _items.add(item);
      // 3) Telling animated list to start animation
      _listkey.currentState.insertItem(_items.length - 1);
    }
  }

  Future<String> getImage(name) async {
    try {
      final ref =
          FirebaseStorage.instance.ref().child(name.toString() + '.jpg');
      var url = await ref.getDownloadURL();
      setState(() {
        url = url;
      });
      return url;
    } on FirebaseException catch (e) {
      print(e.message);
      return 'https://firebasestorage.googleapis.com/v0/b/shapensoul-e1bb8.appspot.com/o/logo.png?alt=media&token=9108beac-e787-4c75-860b-8677d36720c5';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
        shrinkWrap: true,
        key: _listkey,
        initialItemCount: _items.length,
        itemBuilder: (context, index, animate) {
          return SlideTransition(
            // child: Container(
            //   height: MediaQuery.of(context).size.height / 4.8,
            //   child:
            // Card(
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                if (urls.containsKey(tes.values.toList()[index]))
                  Container(
                      height: MediaQuery.of(context).size.height / 5.3,
                      child: Container(
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: InkWell(
                                splashColor: Colors.green.withAlpha(30),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Recipe(
                                            name: tes.values.toList()[index]),
                                      ));
                                },
                                child: Stack(
                                    alignment: Alignment.bottomLeft,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Hero(
                                            tag:
                                                'recipe${urls[tes.values.toList()[index]]}',
                                            child: Image.network(
                                              urls[tes.values.toList()[index]],
                                              width: double.infinity,
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.5),
                                              fit: BoxFit.cover,
                                              colorBlendMode: BlendMode.darken,
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: IntrinsicHeight(
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 1, 10, 1),
                                                child: Text(
                                                  tes.keys.toList()[index],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 23,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              VerticalDivider(
                                                width: 35,
                                                thickness: 0.9,
                                                color: Colors.white60,
                                              ),
                                              Expanded(
                                                  child: Hero(
                                                tag:
                                                    'recipe_name${tes.values.toList()[index]}',
                                                child: Text(
                                                  tes.values.toList()[index],
                                                  style: TextStyle(
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white),
                                                ),
                                              )),
                                            ],
                                          ),
                                        ),
                                      )
                                    ]))),
                      ))

                // Container(
                //     child: InkWell(
                //   splashColor: Colors.green.withAlpha(30),
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) =>
                //               Recipe(name: tes.values.toList()[index]),
                //         ));
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Column(
                //       children: [
                //         ClipRRect(
                //           borderRadius: BorderRadius.circular(10),
                //           child: Hero(
                //               tag: 'recipe${urls[index]}',
                //               child: Image.network(urls[index])),
                //           // height: 150.0,
                //           // width: 100.0,
                //         ),
                //         IntrinsicHeight(
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.start,
                //             children: [
                //               Padding(
                //                 padding: const EdgeInsets.fromLTRB(
                //                     12, 12, 2, 10),
                //                 child: Text(
                //                   tes.keys.toList()[index],
                //                   style: TextStyle(
                //                       fontSize: 25,
                //                       fontWeight: FontWeight.w500,
                //                       // color: Colors.green[900]),
                //                       color: Colors.blueGrey[600]),
                //                 ),
                //               ),
                //               Padding(
                //                 padding: const EdgeInsets.fromLTRB(
                //                     6, 11, 6, 7),
                //                 child: VerticalDivider(
                //                   width: 35,
                //                   thickness: 1.1,
                //                   // color: Colors.green,
                //                 ),
                //               ),
                //               Padding(
                //                 padding: const EdgeInsets.fromLTRB(
                //                     0, 15, 2, 10),
                //                 child: Text(
                //                   tes.values.toList()[index],
                //                   style: TextStyle(
                //                       fontSize: 27,
                //                       fontWeight: FontWeight.w500,
                //                       color: Colors.green[900]),
                //                   // color: Colors.blueGrey[600]),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // ))
                else
                  Container(
                      height: MediaQuery.of(context).size.height / 5.3,
                      child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/shapensoul-e1bb8.appspot.com/o/logo.png?alt=media&token=9108beac-e787-4c75-860b-8677d36720c5'))
              ],
            ),

            position: animate.drive(offset),
          );
        });
  }
}
