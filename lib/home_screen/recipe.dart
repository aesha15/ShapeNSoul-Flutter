import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Recipe extends StatelessWidget {
  final String name;
  Recipe({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference appointment =
        FirebaseFirestore.instance.collection('Recipe');

    return FutureBuilder<DocumentSnapshot>(
        future: appointment.doc(name).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          print(name);
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            return Scaffold(
              appBar: AppBar(
                  title: Text('Shape N Soul'),
                  automaticallyImplyLeading: false,
                  actions: <Widget>[
                    IconButton(
                        icon: new Icon(Icons.forum),
                        onPressed: () {
                          Navigator.pushNamed(context, '/chat');
                        }),
                    IconButton(
                      icon: new Icon(Icons.exit_to_app),
                      onPressed: () {
                        print('Are you sure?');
                      },
                    ),
                  ]),
              body: Column(children: [
                Text(data['Name']),
                for (var ing in data['Ingredients'].keys)
                  Row(children: [
                    Text(ing + ":"),
                    Text(data['Ingredients'][ing])
                  ]),
                for (var method in data['Method'].split('.')) Text(method)
              ]),
            );
          }
          return Text("loading");
        });
  }
}
