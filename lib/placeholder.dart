return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              child: ListView(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(19, 15, 15, 15),
                    child: Text(
                      ' Upcoming appointments : ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                          color: Colors.teal[900]),
                    ),
                  ),
                  for (var value in test)
                    if (!value['date'].toDate().isBefore(DateTime.now()))
                      Column(children: [
                        Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Card(
                                color: const Color(0xfff6fef6),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      6, 6, 14, 3),
                                              child: Icon(
                                                Icons.access_time,
                                                size: 23,
                                              ),
                                            ),
                                            Text(
                                              DateFormat.yMMMd().format(
                                                  value['date'].toDate()),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green[900]),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 40),
                                              child: Text(
                                                value['time'],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        Colors.blueGrey[800]),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 40),
                                              child: Text(
                                                value['therapy name'],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        Colors.blueGrey[800]),
                                                // color: Colors.green[900]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ))),
                      ]),
                  ExpansionTile(
                    title: Text(
                      ' Previous appointments ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                          color: Colors.blueGrey[600]),
                    ),
                    children: [
                      for (var value in test)
                        if (value['date'].toDate().isBefore(DateTime.now()))
                          Column(children: [
                            Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Card(
                                    color: const Color(0xeef6fef6),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          6, 6, 14, 3),
                                                  child: Icon(
                                                    Icons.access_time,
                                                    size: 23,
                                                  ),
                                                ),
                                                Text(
                                                  DateFormat.yMMMd().format(
                                                      value['date'].toDate()),
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green[900]),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 40),
                                                  child: Text(
                                                    value['time'],
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors
                                                            .blueGrey[800]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 40),
                                                  child: Text(
                                                    value['therapy name'],
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors
                                                            .blueGrey[800]),
                                                    // color: Colors.green[900]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))),
                          ]),
                    ],
                  )
                ])
              ]),
            ),
          );