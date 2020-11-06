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
              body: CustomScrollView(slivers: [
                SliverAppBar(
                  expandedHeight: 250.0,
                  floating: true,
                  pinned: true,
                  snap: false,
                  iconTheme: IconThemeData(
                    color: Colors.white, //change your color here
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          data['Name'],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      background: Image.network(
                        // clove tea
                        // 'https://assets-news-bcdn-ll.dailyhunt.in/cmd/resize/400x400_60/fetchdata12/images/71/ac/27/71ac27c0daeabd9c9af9680d6a04319b.jpg',
                        // cumin drink
                        // 'https://www.24mantra.com/wp-content/uploads/2020/07/a708191ec813df32ce5bc6b3b-5f040f267982e.jpg',
                        // giloy kadha
                        // 'https://navbharattimes.indiatimes.com/photo/msid-76461396,imgsize-36152/pic.jpg',
                        // ginger drink
                        // 'https://img1.thelist.com/img/gallery/when-you-drink-ginger-tea-every-day-this-is-what-happens-to-your-body/intro-1585239422.jpg',
                        // ragi laddoo
                        // 'https://hyderabadiruchulu.com/wp-content/uploads/2018/08/ragi-laddu.jpg',
                        // sesame date ladoo
                        // 'https://st1.thehealthsite.com/wp-content/uploads/2017/10/Dates-Ladoo-655x353.jpg',
                        // sesame ladoo
                        // 'https://www.myweekendkitchen.in/wp-content/uploads/2019/02/til_ke_laddu_sesame_balls-500x375.jpg',
                        // shoe flower drink
                        // 'https://smartsexypaleo.com/wp-content/uploads/2020/05/refreshing-hibiscus-iced-ted_67618.jpg',
                        // tulsi mint tea
                        'https://4.imimg.com/data4/XE/DK/MY-1473185/tulsi-tea-500x500.jpg',

                        // turmeric drink
                        // 'https://www.thespruceeats.com/thmb/-c4RbYEJnYcmV0SyQehEA6Bh37s=/960x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/herbal-tea-with-turmeric-638824318-5abdb804ae9ab8003729e696.jpg',

                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        colorBlendMode: BlendMode.darken,
                        fit: BoxFit.cover,
                      )),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Ingredients : ",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[900]),
                              ),
                            ),
                            for (var ing
                                in data['Ingredients'].keys.toList()..sort())
                              Padding(
                                padding: const EdgeInsets.fromLTRB(18, 5, 5, 5),
                                child: Row(children: [
                                  Text('•  '),
                                  Flexible(
                                    child: Text(
                                      ing + "  :  ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Text(
                                    data['Ingredients'][ing],
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  )
                                ]),
                              ),
                            Divider(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Method : ",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[900]),
                              ),
                            ),
                            for (var method in data['Method'].split('.'))
                              if (method != '')
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        new Text('-   '),
                                        Flexible(
                                          child: new Text(
                                            method,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        )
                                      ],
                                    )),
                          ]),
                    ),
                  ),
                ),
              ]),
            );
          }
          return Text("loading");
        });
  }
}