import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stabit/components/Drawer.dart';
import 'package:stabit/models/MyCource%20Model.dart';
import 'package:stabit/pages/Quiz%20page.dart';

class QuizCource extends StatelessWidget {
  const QuizCource({super.key});
  Future<List<Map<String, dynamic>>?> retrieveDataFromFirstCollection() async {
    final CollectionReference firstCollection = FirebaseFirestore.instance
        .collection("Stabit")
        .doc("Cources")
        .collection("PaidCources");

    QuerySnapshot querySnapshot = await firstCollection.get();
    List<Map<String, dynamic>> firstDataList = [];

    querySnapshot.docs.forEach((documentSnapshot) {
      firstDataList.add(documentSnapshot.data() as Map<String, dynamic>);
    });

    return firstDataList;
  }

  Future<List<Map<String, dynamic>>?> retrieveDataFromSecondCollection() async {
    final CollectionReference secondCollection = await FirebaseFirestore
        .instance
        .collection("Stabit")
        .doc("Student")
        .collection(FirebaseAuth.instance.currentUser!.email!)
        .doc("My Cources")
        .collection("Cources");

    QuerySnapshot querySnapshot = await secondCollection.get();
    List<Map<String, dynamic>> secondDataList = [];

    querySnapshot.docs.forEach((documentSnapshot) {
      secondDataList.add(documentSnapshot.data() as Map<String, dynamic>);
    });

    return secondDataList;
  }

  Future<List<Map<String, dynamic>>?> findMatchingData() async {
    final firstData = await retrieveDataFromFirstCollection();
    final secondData = await retrieveDataFromSecondCollection();

    if (firstData == null || secondData == null) {
      // Handle cases where data retrieval fails
      return null;
    }

    List<Map<String, dynamic>> matchingData = [];

    // Compare the data from both lists and store the matching items
    for (var firstItem in firstData) {
      for (var secondItem in secondData) {
        if (firstItem['Cource'] == secondItem['Cource Name']) {
          matchingData.add(firstItem);
          // If you want to store the matching data from the second collection, use secondItem instead of firstItem.
        }
      }
    }

    return matchingData;
  }

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
          body: FutureBuilder<List<Map<String, dynamic>>?>(
            future: findMatchingData(),
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

class ViewMC extends StatelessWidget {
  const ViewMC({
    super.key,
    required this.photoUrl,
    required this.name,
    required this.description,
    required this.price,
    required this.course,
  });
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
                  builder: (context) => QuizPage(
                        name: course,
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
