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

  Map<String, dynamic> data;
  final GlobalKey<AnimatedListState> _listkey = GlobalKey<AnimatedListState>();
  final Tween<Offset> offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));
  List<dynamic> _items = [];
  int counter = 0;
  List<dynamic> test = [];

  Future<void> _loadItems() async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc('+918976305456')
        .get()
        .then((DocumentSnapshot documentSnapshot) => {
              documentSnapshot.data()['diet'].forEach((key, value) {
                print(value);
                test.add(value);
              }),
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
    return AnimatedList(
        key: _listkey,
        initialItemCount: _items.length,
        itemBuilder: (context, index, animate) {
          return SlideTransition(
            child: Text(_items[index]),
            position: animate.drive(offset),
          );
        });
  }
}
