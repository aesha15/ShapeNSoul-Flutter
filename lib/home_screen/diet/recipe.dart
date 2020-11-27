import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../splash_screen.dart';
// import 'package:fluttersns/splash_screen.dart';

class Recipe extends StatefulWidget {
  final String name;
  Recipe({Key key, @required this.name}) : super(key: key);
  @override
  State<StatefulWidget> createState() => new _RecipeState();
}

class _RecipeState extends State<Recipe> {
  String imageurl =
      'https://firebasestorage.googleapis.com/v0/b/shapensoul-e1bb8.appspot.com/o/Clove%20tea.jpg?alt=media&token=6fa0801d-4584-434a-842e-68db6d5c5a0e';
  Directory appDocDir;
  @override
  void initState() {
    getImage(widget.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference appointment =
        FirebaseFirestore.instance.collection('Recipe');

    return FutureBuilder<DocumentSnapshot>(
        future: appointment.doc(widget.name).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();

            return Scaffold(
              body: CustomScrollView(slivers: [
                SliverAppBar(
                  expandedHeight: 250.0,
                  floating: true,
                  pinned: true,
                  snap: false,
                  iconTheme: IconThemeData(
                    color: Colors.white, //change your color here
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Hero(
                          tag: 'recipe_name${data['Name']}',
                          child: Text(
                            data['Name'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      background: Hero(
                        tag: 'recipe$imageurl',
                        child: Image.file(
                          new File('${appDocDir.path}/${data['Name']}.jpg'),
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                          colorBlendMode: BlendMode.darken,
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Ingredients : ",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[900]),
                              ),
                            ),
                            for (var ing
                                in data['Ingredients'].keys.toList()..sort())
                              Padding(
                                padding: const EdgeInsets.fromLTRB(18, 5, 5, 5),
                                child: Row(children: [
                                  Text('•  '),
                                  Flexible(
                                    child: Text(
                                      ing + "  :  ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Text(
                                    data['Ingredients'][ing],
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  )
                                ]),
                              ),
                            Divider(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Method : ",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[900]),
                              ),
                            ),
                            for (var method in data['Method'].split('.'))
                              if (method != '')
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        new Text('-   '),
                                        Flexible(
                                          child: new Text(
                                            method,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        )
                                      ],
                                    )),
                          ]),
                    ),
                  ),
                ),
              ]),
            );
          }
          return SplashScreen();
        });
  }

  Future<void> getImage(name) async {
    appDocDir = await getApplicationDocumentsDirectory();
  }
}
