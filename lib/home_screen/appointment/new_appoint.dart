import 'dart:async';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import '../../name2phone.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  List<String> suggestions = [];
  List<String> therapy = [];
  String therapytext = '';
  String currentText = "";
  var selected;
  var selectedTherapy;
  Timestamp date;

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  SimpleAutoCompleteTextField _nameController;
  SimpleAutoCompleteTextField _therapyController;
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> therapykey = new GlobalKey();

  _DateTimePickerState() {
    _nameController = SimpleAutoCompleteTextField(
        key: key,
        decoration: new InputDecoration(
            icon: const Icon(Icons.person), labelText: "Name"),
        controller: TextEditingController(text: ""),
        suggestions: suggestions,
        textChanged: (text) => currentText = text,
        clearOnSubmit: false,
        textSubmitted: (text) => setState(() {
              if (text != "") {
                selected = text;
              }
            }));
    _therapyController = SimpleAutoCompleteTextField(
        key: therapykey,
        decoration: new InputDecoration(
            icon: const Icon(Icons.assignment), labelText: "Therapy Name"),
        controller: TextEditingController(text: ""),
        suggestions: therapy,
        textChanged: (text) => therapytext = text,
        clearOnSubmit: false,
        textSubmitted: (text) => setState(() {
              if (text != "") {
                selectedTherapy = text;
              }
            }));
  }

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
    auto();
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

    String apptName = _dateController.text + ' ' + _timeController.text;
    date = Timestamp.fromDate(selectedDate);

    Future<void> addAppt() async {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      var userphone = await name2phone(selected);
      return users.get().then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          batch.update(users.doc(userphone), {
            'appointment.date': date,
            'appointment.time': _timeController.text,
            'appointment.therapy name': selectedTherapy,
          });

          batch.update(appt.doc(userphone), {
            '$apptName.date': date,
            '$apptName.time': _timeController.text,
            '$apptName.therapy name': selectedTherapy,
            '$apptName.client name': selected,
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
                  _nameController,
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
                  _therapyController,
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

  void auto() {
    FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                suggestions.add(doc.data()["name"]);
              }),
            });
    FirebaseFirestore.instance
        .collection('Therapy')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                print(doc.data()["Name"]);
                therapy.add(doc.data()["Name"]);
              }),
            });
  }
}
