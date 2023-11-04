import 'package:flutter/material.dart';
import 'package:stabit/components/Drawer.dart';
import 'package:stabit/models/MyCource%20Model.dart';
import 'package:stabit/pages/Lectures.dart';

class My_Cource_Page extends StatelessWidget {
  const My_Cource_Page({super.key});

  @override
  Widget build(BuildContext context) {
    var index = 1;
    MyCource c1 = MyCource();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          drawer: const SideDrawer(),
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: const Padding(
              padding: EdgeInsets.fromLTRB(100, 0, 0, 0),
              child: Text("My Cources"),
            ),
          ),
          backgroundColor: Colors.white,
          body: FutureBuilder<List<Map<String, dynamic>>>(
            future: c1.retrieveDataAsList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return const Text('No data available.');
              } else if (snapshot.data == 0) {
                return const Text('No data available.');
              } else {
                List<Map<String, dynamic>> dataList = snapshot.data!;
                return ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return ViewMC(
                      course: dataList[index]['Cource Name'],
                      description: dataList[index]['Description'],
                      price: dataList[index]['Price'],
                      photoUrl: dataList[index]['Photo'],
                      name: dataList[index]['Teacher Name'],
                      Videos: dataList[index]['Videos'],
                    );
                  },
                );
              }
            },
          ),
        ));
  }
}

class ViewMC extends StatelessWidget {
  const ViewMC(
      {super.key,
      required this.photoUrl,
      required this.name,
      required this.description,
      required this.price,
      required this.course,
      required this.Videos});
  final String photoUrl;
  final String name;
  final String description;
  final String price;
  final String course;
  final List Videos;

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
                  builder: (context) => LectureListPage(
                        courseName: course,
                        Videos: Videos,
                      )));
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
