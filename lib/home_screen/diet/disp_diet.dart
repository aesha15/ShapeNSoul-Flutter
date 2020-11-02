<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:timeline_tile/timeline_tile.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String current = auth.currentUser.phoneNumber;

// DocumentReference documentRef =
//     FirebaseFirestore.instance.collection('Users').doc(current);

// Future<Map> getDiet(BuildContext context) {
//   var document = FirebaseFirestore.instance.collection('Users').doc(current);
//   return document.get().then((documentSnapshot) {
//     final x = documentSnapshot.data();
//     print('Document data: ${documentSnapshot.data()['diet']}');
//     return x;
//   });
//   // return("Hi ");
// }

class Diet extends StatelessWidget {
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());
          default:
            return new ListView(
                // children: snapshot.data.docs
                //     .map((DocumentSnapshot document) =>
                //         new Text(document.data()['diet'].toString()))
                //     .toList());

                children: snapshot.data.docs
                    .map((DocumentSnapshot document) =>
                        new Text(document.data()['diet'].toString()))
                    .toList());
        }
      },
    );
  }
}
=======
import 'dart:async';
import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';

class Diet extends StatefulWidget {
  @override
  _FirstPageState createState() => new _FirstPageState();
}

class _FirstPageState extends State<Diet> {
  List<String> added = [];
  List<String> suggestions = [];
  var html = "";
  String currentText = "";
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  @override
  void initState() {
    getRecipe();
    super.initState();
  }

  share(body) async {
    html =
        "<!DOCTYPE html><html><style>h1{text-align:center;},span{position:absolute;display:inline-block;left:300px}</style><h1>DR. TRUPTI SHAH</h1>" +
            body +
            "</html>";

    Directory appDocDir = await getApplicationDocumentsDirectory();
    var targetPath = appDocDir.path;
    var targetFileName = "Diet";
    var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        html, targetPath, targetFileName);
    var generatedPdfFilePath = generatedPdfFile.path;
    Share.shareFiles([generatedPdfFilePath], text: 'Your PDF!');
    setState(() {
      added.clear();
    });
  }

  create() async {
    added.reversed;
    var body = "";
    var ingredients = "";
    added.forEach((element) async => {
          await FirebaseFirestore.instance
              .collection('Recipe')
              .doc(element)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
                documentSnapshot.data()["Ingredients"].forEach((k, v) {
                  ingredients += "<p>" + k + ":<span>" + v + "</span></p>";
                });
                body += "<h2>" +
                    documentSnapshot.data()["Name"] +
                    "</h2>" +
                    ingredients +
                    "<p><b>Method:</b></p><p>" +
                    documentSnapshot.data()["Method"] +
                    "</p>";
                print(documentSnapshot.data()["Name"]);
              })
              .then((value) => share(body))
              .catchError((error) {
                print(error.toString());
              })
        });
  }

  _FirstPageState() {
    textField = SimpleAutoCompleteTextField(
      key: key,
      decoration: new InputDecoration(labelText: "Recipe"),
      controller: TextEditingController(text: ""),
      suggestions: suggestions,
      textChanged: (text) => currentText = text,
      clearOnSubmit: true,
      textSubmitted: (text) => setState(() {
        if (text != "") {
          added.add(text);
        }
      }),
    );
  }

  Future<void> getRecipe() async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance
        .collection('Recipe')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                suggestions.add(doc.data()["Name"]);
              })
            });
  }
  // ignore: deprecated_member_use

  SimpleAutoCompleteTextField textField;
  bool showWhichErrorText = false;

  @override
  Widget build(BuildContext context) {
    Column body = new Column(children: [
      new ListTile(title: textField),
    ]);

    body.children.addAll(added.map((item) {
      return Dismissible(
          key: Key(item),
          child: ListTile(
              title: Text(item),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0)),
          onDismissed: (direction) => {
                setState(() {
                  added.remove(item);
                })
              },
          background: Container(color: Colors.red));
    }));

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(title: new Text('Diet'), actions: [
        new IconButton(
            icon: new Icon(Icons.add),
            onPressed: () => showDialog(
                builder: (_) {
                  String text = "";
                  return new AlertDialog(
                      title: new Text("Add Recipes"),
                      content:
                          new TextField(onChanged: (newText) => text = newText),
                      actions: [
                        new FlatButton(
                            onPressed: () {
                              if (text != "") {
                                suggestions.add(text);
                                textField.updateSuggestions(suggestions);
                              }
                              Navigator.pop(context);
                            },
                            child: new Text("Add")),
                      ]);
                },
                context: context))
      ]),
      body: body,
      floatingActionButton: RaisedButton(
        onPressed: create,
        child: Text("Create Pdf"),
        color: Colors.green[400],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
>>>>>>> dd40f8f152585353c6f76588c644466e953e6889
