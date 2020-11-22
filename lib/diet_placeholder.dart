// return FutureBuilder<DocumentSnapshot>(
//       future: appointment.doc('+918976305456').get(),
//       builder:
//           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text("Something went wrong");
//         }

//         if (snapshot.connectionState == ConnectionState.done) {
//           Map<String, dynamic> data = snapshot.data.data();
//           print(data);
//           return Scaffold(
//             body: Padding(
//                 padding: const EdgeInsets.all(13.0),
//                 child: Container(
//                   child: ListView(
//                     children: [
//                       for (var key in data['diet'].keys.toList()..sort())
//                         if (key.contains('AM'))
//                           Column(children: [
//                             Card(
//                                 color: const Color(0xfff6fef6),
//                                 child: InkWell(
//                                     splashColor: Colors.green.withAlpha(30),
//                                     onTap: () {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 Recipe(name: data['diet'][key]),
//                                           ));
//                                     },
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(11.0),
//                                       child: Container(
//                                         height: 50,
//                                         child: Row(
//                                           children: [
//                                             Text(
//                                               key,
//                                               style: TextStyle(
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.bold,
//                                                   // color: Colors.green[900]),
//                                                   color: Colors.blueGrey[800]),
//                                             ),
//                                             VerticalDivider(
//                                               width: 35,
//                                               thickness: 1.1,
//                                             ),
//                                             Expanded(
//                                               child: Text(
//                                                 data['diet'][key],
//                                                 style: TextStyle(
//                                                     fontSize: 18,
//                                                     fontWeight: FontWeight.w600,
//                                                     // color: Colors.blueGrey[800]),
//                                                     color: Colors.green[900]),
//                                               ),
//                                             ),
//                                             Icon(Icons.arrow_right,
//                                                 color: Colors.green[900])
//                                           ],
//                                         ),
//                                       ),
//                                     )))
//                           ]),
//                       for (var key in data['diet'].keys.toList()..sort())
//                         if (key.contains('PM'))
//                           Column(children: [
//                             Card(
//                                 color: const Color(0xfff6fef6),
//                                 child: InkWell(
//                                     splashColor: Colors.green.withAlpha(30),
//                                     onTap: () {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 Recipe(name: data['diet'][key]),
//                                           ));
//                                     },
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(11.0),
//                                       child: Container(
//                                         height: 50,
//                                         child: Row(
//                                           children: [
//                                             Text(
//                                               key,
//                                               style: TextStyle(
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.bold,
//                                                   // color: Colors.green[900]),
//                                                   color: Colors.blueGrey[800]),
//                                             ),
//                                             VerticalDivider(
//                                               width: 35,
//                                               thickness: 1.1,
//                                             ),
//                                             Expanded(
//                                               child: Text(
//                                                 data['diet'][key],
//                                                 style: TextStyle(
//                                                     fontSize: 18,
//                                                     fontWeight: FontWeight.w600,
//                                                     // color: Colors.blueGrey[800]),
//                                                     color: Colors.green[900]),
//                                               ),
//                                             ),
//                                             Icon(Icons.arrow_right,
//                                                 color: Colors.green[900])
//                                           ],
//                                         ),
//                                       ),
//                                     )))
//                           ]),
//                     ],
//                   ),
//                 )),
//           );
//         }

//         return Text('loading');
//       },
//     );
