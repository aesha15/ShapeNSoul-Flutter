import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Recipe extends StatelessWidget {
  final name;
  Recipe(this.name);
  @override
  Widget build(BuildContext context) {
    CollectionReference appointment =
        FirebaseFirestore.instance.collection('Recipe');

    return FutureBuilder<DocumentSnapshot>(
        future: appointment.doc(name).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            print(data['Name']);
            return Column(children: [
              Text(data['Name']),
              for (var ing in data['Ingredients'].keys)
                Row(children: [
                  Text(ing + ":"),
                  Text(data['Ingredients'][ing])
                ]),
              for (var method in data['Method'].split('.')) Text(method)
            ]);
          }
          return Text("loading");
        });
  }
}
