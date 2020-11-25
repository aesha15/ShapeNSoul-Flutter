import 'package:flutter/material.dart';

class PrevAppoint extends StatefulWidget {
  final String name;
  PrevAppoint({Key key, @required this.name}) : super(key: key);
  @override
  PrevAppointState createState() => new PrevAppointState();
}

class PrevAppointState extends State<PrevAppoint> {
  @override
  void initState() {
    print(widget.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'prev',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
