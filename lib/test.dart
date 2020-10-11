import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _controller = TextEditingController();
  String phoneNo = "";

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent[50],
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[400],
        elevation: 0.0,
        title: Text('Login to ShapeNSoul'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(phoneNo),
            Container(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Enter Phone Number",
                ),
                inputFormatters: [],
              ),
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            ),
            Container(
              // width: double.infinity,
              child: FlatButton(
                // textColor: Colors.green
                child: Text('VERIFY',
                    style: TextStyle(fontSize: 20.0, color: Colors.green)),
                onPressed: () async {
                  setState(() {
                    phoneNo = _controller.text;
                  });
                },
              ),
              padding: EdgeInsets.all(32),
            )
          ]),
    );
  }
}
