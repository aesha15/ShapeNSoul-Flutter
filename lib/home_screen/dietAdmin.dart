import 'dart:async';
import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
    // String downloadURL = await firebase_storage.FirebaseStorage.instance
    //     .ref('logo.png')
    //     .getDownloadURL();
    //     <img src='${downloadURL}' style='position:absolute;opacity:0.1;z-index:-1;left:20%;top:25%' alt='logo'>
    html =
        "<!DOCTYPE html><html><style>h1{text-align:center;}span{position: absolute;display: inline-block;left: 300px;}</style><h1>DR. TRUPTI SHAH</h1><br><br>" +
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
    var method = "";
    added.forEach((element) async => {
          await FirebaseFirestore.instance
              .collection('Recipe')
              .doc(element)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
                ingredients = "";
                method = "";
                documentSnapshot.data()["Ingredients"].forEach((k, v) {
                  ingredients += "<li>" + k + ":<span>" + v + "</span></li>";
                });
                var methodList = documentSnapshot.data()["Method"].split('.');
                for (var i = 0; i < methodList.length - 1; i++) {
                  method += "<li>" + methodList[i] + "</li>";
                }
                body += "<div style='page-break-after: always;'><h2>" +
                    documentSnapshot.data()["Name"] +
                    "</h2><br><br><ul>" +
                    ingredients +
                    "</ul><br><br><p><b>Method:</b></p><ol>" +
                    method +
                    "</ol></div>";
                print(method);
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