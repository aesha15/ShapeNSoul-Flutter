import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileDetails extends StatefulWidget {
  final String name;
  ProfileDetails({Key key, @required this.name}) : super(key: key);

  @override
  _ProfileDetails createState() => _ProfileDetails();
}

class _ProfileDetails extends State<ProfileDetails> {
  TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    _weightController.text = 'Weight';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.name;
    CollectionReference appointment =
        FirebaseFirestore.instance.collection('Users');
    print(name);
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
                centerTitle: true,
                title: Text("Client Details"),
              ),
              body: ListView(children: [
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Container(
                      color: Color(0xffe4fce4),
                      height: MediaQuery.of(context).size.height / 5,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(33, 1, 1, 25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              data['name'],
                              style: TextStyle(
                                  color: Colors.green[800],
                                  fontSize: 44,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              data['phone'],
                              style: TextStyle(
                                  // color: Colors.green[800],
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      )),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: EditableText(
                    backgroundCursorColor: Colors.green,
                    textAlign: TextAlign.start,
                    focusNode: FocusNode(),
                    controller: _weightController,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                    keyboardType: TextInputType.multiline,
                    cursorColor: Colors.blue,
                  ),
                ),
                for (var ing in data['appointment'].keys)
                  Column(children: [
                    Text(ing + ":"),
                    if (ing == 'date')
                      Text(DateFormat.yMMMd()
                          .format(data['appointment'][ing].toDate()))
                    else
                      Text(data['appointment'][ing])
                  ]),
                for (var method in data['diet'].keys)
                  Column(children: [
                    Text(method),
                    Text(data['diet'][method]),
                  ]),
              ]),
            );
          }
          return Text("loading");
        });
  }
}
