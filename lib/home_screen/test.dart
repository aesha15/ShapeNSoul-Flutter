import 'dart:collection';

import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  Test();
  var temp = [
    {"name": "Chiren", "age": 15},
    {"name": "bbb", "age": 85},
    {"name": "aa", "age": 25},
    {"name": "thampi", "age": 55},
    {"name": "lor", "age": 20}
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        child: RaisedButton(
      color: Colors.white,
      onPressed: click(),
    ));
  }

  click() {
    temp.sort((a, b) {
      return a['age'].toString().compareTo(b['age'].toString());
    });
    print(temp);
    temp.forEach((element) {
      print(element['name']);
    });
  }
}
//;
