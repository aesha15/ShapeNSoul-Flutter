import 'dart:async';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Appointment extends StatefulWidget {
  Appointment({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<Appointment> {
  double _height;
  double _width;
  // String _setTime, _setDate;

  String _hour, _minute, _time;
  String dateTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _therapyController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.weekday == 7
          ? DateTime.now().add(Duration(days: 1))
          : DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 0)),
      lastDate: DateTime(2101),
      helpText: 'SELECT APPOINTMENT DATE',
      confirmText: 'OK',
      selectableDayPredicate: (DateTime val) => val.weekday == 7 ? false : true,
    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMMMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  void initState() {
    _dateController.text = null;
    _timeController.text = null;
    _nameController.text = null;
    _therapyController.text = null;
    // _dateController.text = DateFormat.yMMMd().format(DateTime.now());

    // _timeController.text = formatDate(
    //     DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
    //     [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMMMd().format(DateTime.now());

    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    // CollectionReference names = FirebaseFirestore.instance.collection('Names');
    CollectionReference appt =
        FirebaseFirestore.instance.collection('Appointments');
    FirebaseAuth auth = FirebaseAuth.instance;
    var current = auth.currentUser.phoneNumber;

    String apptName = _nameController.text +
        ' ' +
        _dateController.text +
        ' ' +
        _timeController.text;

    Future<void> addAppt() {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      return users.get().then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          batch.update(users.doc(current), {
            'appointment.date': _dateController.text,
            'appointment.time': _timeController.text,
            'appointment.therapy name': _therapyController.text,
          });

          batch.update(appt.doc(current), {
            '$apptName.date': _dateController.text,
            '$apptName.time': _timeController.text,
            '$apptName.therapy name': _therapyController.text,
            '$apptName.client name': _nameController.text,
            '$apptName.status': true,
          });
        });

        return batch.commit();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Appointment'),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          width: _width,
          height: _height,
          margin:
              const EdgeInsets.only(top: 20, left: 15, right: 40, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: _height / 40,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Enter client\'s name',
                      labelText: 'Name',
                    ),
                    controller: _nameController,
                  ),
                  SizedBox(
                    height: _height / 40,
                  ),
                  InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: AbsorbPointer(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.calendar_today),
                          hintText: 'Select Date',
                          labelText: 'Date',
                        ),
                        controller: _dateController,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _height / 40,
                  ),
                  InkWell(
                    onTap: () {
                      _selectTime(context);
                    },
                    child: IgnorePointer(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.watch_later),
                          hintText: 'Select Time',
                          labelText: 'Time',
                        ),
                        controller: _timeController,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _height / 40,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.assignment),
                      hintText: 'Enter Therapy Name',
                      labelText: 'Therapy',
                    ),
                    controller: _therapyController,
                  ),
                  SizedBox(
                    height: _height / 3,
                  ),
                  RaisedButton(
                    onPressed: () => {addAppt(), Navigator.pop(context)},
                    color: Color(0xff3fc380),
                    textColor: Colors.white,
                    child: Text('Book Appointment'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
