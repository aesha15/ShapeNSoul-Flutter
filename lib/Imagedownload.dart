import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Images extends StatefulWidget {
  @override
  _ImagesState createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  @override
  Widget build(BuildContext context) {
    File downloadToFile;
    return Scaffold(
        body: Column(
            children: [if (downloadToFile != null) Image.file(downloadToFile)]),
        floatingActionButton: RaisedButton(
            onPressed: () => downloadFileExample('Clove tea.jpg')
                .then((value) => setState(() {
                      downloadToFile = new File(value);
                    }))));
  }

  Future<String> downloadFileExample(image) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    if (new File('${appDocDir.path}/' + image).existsSync()) {
      File downloadToFile = File('${appDocDir.path}/' + image);
      try {
        await firebase_storage.FirebaseStorage.instance
            .ref('Ananthmul drink.jpg')
            .writeToFile(downloadToFile);
      } on FirebaseException catch (e) {
        print(e);
      }
      print('hi');
      return downloadToFile.path;
    } else {
      return '${appDocDir.path}/' + image;
    }
  }
}
