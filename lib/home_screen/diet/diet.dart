import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class Diet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Shape N Soul'),
          // centerTitle: true,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            // Text("Logout",
            //     style: TextStyle(
            //       fontSize: 18,
            //     )),
            IconButton(
              icon: new Icon(Icons.exit_to_app),
              onPressed: () {
                print('Exit');
              },
            ),
          ]),
      body: Center(
        child: Text(
          'Diet',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
