import 'package:flutter/material.dart';
import 'package:stabit/pages/home_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:stabit/pages/profilrpage.dart';
import 'package:stabit/services/Payments.dart';

import '../models/CourcesModel.dart';
import 'Results page.dart';

class ViewC extends StatelessWidget {
  const ViewC(
      {super.key,
      required this.photoUrl,
      required this.name,
      required this.description,
      required this.price,
      required this.course});
  final String photoUrl;
  final String name;
  final String description;
  final String price;
  final String course;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 200,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Payments(
                      fees: price,
                      TeacherName: name,
                      cource: course,
                      desc: description,
                      photo: photoUrl)));
        },
        child: Card(
            elevation: 20,
            color: Colors.pink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course,
                              style: const TextStyle(fontSize: 30),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              description,
                              style: const TextStyle(fontSize: 20),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("Rs " + price,
                                style: const TextStyle(fontSize: 20))
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: ShapeDecoration(
                              image: DecorationImage(
                                image: NetworkImage(photoUrl),
                                fit: BoxFit.fill,
                              ),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                  color: Color(0xFF504786),
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(name)
                        ],
                      )
                    ],
                  ),
                ))),
      ),
    );
  }
}

class CourseView extends StatelessWidget {
  const CourseView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var index = 1;
    CoucesModel c1 = CoucesModel();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: const Center(child: Text("cources")),
          ),
          backgroundColor: Colors.white,
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            color: Colors.deepPurple,
            animationDuration: const Duration(milliseconds: 200),
            index: index,
            onTap: (index) {
              if (index == 0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              } else if (index == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CourseView()));
              } else if (index == 2) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              } else if (index == 3) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Result_Page()));
              }
            },
            items: const [
              Icon(
                Icons.home,
                color: Colors.white,
              ),
              Icon(Icons.book_online, color: Colors.white),
              Icon(Icons.person_2_sharp, color: Colors.white),
              Icon(
                Icons.developer_mode,
                color: Colors.redAccent,
              )
            ],
          ),
          body: FutureBuilder<List<Map<String, dynamic>>>(
            future: c1.retrieveDataAsList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return const Text('No data available.');
              } else {
                List<Map<String, dynamic>> dataList = snapshot.data!;
                return ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return ViewC(
                      course: dataList[index]['Cource'],
                      description: dataList[index]['Description'],
                      price: dataList[index]['Price'],
                      photoUrl: dataList[index]['PhototUrl'],
                      name: dataList[index]['Teacher Name'],
                    );
                  },
                );
              }
            },
          ),
        ));
  }
}
