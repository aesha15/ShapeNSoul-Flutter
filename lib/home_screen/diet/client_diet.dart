import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'recipe.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:collection';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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

  Map<String, dynamic> data;
  final GlobalKey<AnimatedListState> _listkey = GlobalKey<AnimatedListState>();
  final Tween<Offset> offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));
  List<dynamic> _items = [];
  int counter = 0;
  List<dynamic> keys = [];
  List<dynamic> newkeys = [];
  List<dynamic> values = [];
  Map map;
  SplayTreeMap tes;
  var t;
  Directory appDocDir;
  File image;
  List<bool> flag = List.filled(10, false);
  int count = 0;

  Future<void> _loadItems() async {
    appDocDir = await getApplicationDocumentsDirectory();
    FirebaseFirestore.instance
        .collection('Users')
        .doc('+919987929313')
        .get()
        .then((DocumentSnapshot documentSnapshot) => {
              if (documentSnapshot.data()['diet'] != null)
                {
                  documentSnapshot.data()['diet'].entries.forEach((e) {
                    keys.add(e.key);
                    values.add(e.value);
                  }),
                  toTime(keys),
                  map = Map.fromIterables(newkeys, values),
                  tes = SplayTreeMap<String, dynamic>.from(
                      map,
                      (a, b) => DateFormat('h:mm a')
                          .parse(a)
                          .compareTo(DateFormat('h:mm a').parse(b))),
                  addDelay(tes.values.toList()),
                }
            });
    // image = new File('${appDocDir.path}');
  }

  toTime(keys) {
    final now = new DateTime.now();

    for (var x in keys) {
      t = TimeOfDay(
          hour: int.parse(x.split(":")[0]), minute: int.parse(x.split(":")[1]));

      var d = DateTime(now.year, now.month, now.day, t.hour, t.minute);
      String formattedTime = DateFormat('h:mm a').format(d);

      newkeys.add(formattedTime);
    }
  }

  addDelay(text) async {
    for (var item in text) {
      // 1) Wait for one second
      await Future.delayed(Duration(milliseconds: 80));
      // 2) Adding data to actual variable that holds the item.
      downloadFileExample(item);
      _items.add(item);
      // 3) Telling animated list to start animation
      _listkey.currentState.insertItem(_items.length - 1);
    }
  }

  Future<void> downloadFileExample(image) async {
    // if (!(File('${appDocDir.path}/' + image.toString() + '.jpg')
    //         .existsSync()) &&
    //     File('${appDocDir.path}/' + image.toString() + '.jpg') == null) {
    File downloadToFile =
        File('${appDocDir.path}/' + image.toString() + '.jpg');
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(image.toString() + '.jpg')
          .writeToFile(downloadToFile)
          .then((value) => {
                if (this.mounted) {setState(() {})}
              });
    } on FirebaseException catch (e) {
      print(e);
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedList(
          shrinkWrap: true,
          key: _listkey,
          initialItemCount: _items.length,
          itemBuilder: (context, index, animate) {
            return SlideTransition(
              child: Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height / 6,
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
                                                'recipe${tes.values.toList()[index]}',
                                            child: Wrap(children: [
                                              if (File(
                                                      '${appDocDir.path}/${tes.values.toList()[index]}.jpg')
                                                  .existsSync())
                                                Image.file(
                                                  File(
                                                      '${appDocDir.path}/${tes.values.toList()[index]}.jpg'),
                                                  width: double.infinity,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.5),
                                                  fit: BoxFit.cover,
                                                  colorBlendMode:
                                                      BlendMode.darken,
                                                )
                                              else
                                                Image.asset(
                                                  'assets/images/logo.png',
                                                  width: double.infinity,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.5),
                                                  fit: BoxFit.cover,
                                                  colorBlendMode:
                                                      BlendMode.darken,
                                                )
                                            ])),
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
                                                    tes.keys
                                                        .toList()[index]
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 23,
                                                        color: Colors.white)),
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
                ],
              ),
              position: animate.drive(offset),
            );
          }),
    );
  }
}
