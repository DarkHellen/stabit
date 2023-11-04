import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/Drawer.dart';

class Result_Page extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<Result_Page> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        drawer: const SideDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Padding(
            padding: EdgeInsets.fromLTRB(100, 0, 0, 0),
            child: Text("Results"),
          ),
        ),
        body: FutureBuilder(
          future: fetchExamAndQuizData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final List<QueryDocumentSnapshot> examData =
                snapshot.data?['exam'] ?? [];
            final List<QueryDocumentSnapshot> quizData =
                snapshot.data?['quiz'] ?? [];

            final mergedData = [...examData, ...quizData];

            if (mergedData.isEmpty) {
              return const Center(child: Text('No data available.'));
            }

            return ListView.builder(
              itemCount: mergedData.length,
              itemBuilder: (context, index) {
                final doc = mergedData[index];
                final Map<String, dynamic>? scoresData =
                    doc.data() as Map<String, dynamic>?;
                final bool isExam = examData.contains(doc);

                return ListTile(
                  title: Text('${isExam ? 'Exam' : 'Quiz'}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isExam)
                        Column(
                          children: [
                            Text('Date: ${doc.id}'),
                            Text('Scores: ${scoresData?['scores'] ?? 0}'),
                          ],
                        )
                      else
                        Column(
                          children: [
                            Text(
                                'Correct Answers: ${scoresData?['CorrectAnswer'] ?? 0}'),
                            Text(
                                'Incorrect Answers: ${scoresData?['IncorrectAnswer'] ?? 0}'),
                            Text('Scores: ${scoresData?['scores'] ?? 0}'),
                          ],
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<Map<String, List<QueryDocumentSnapshot>>>
      fetchExamAndQuizData() async {
    try {
      final examCollection = await FirebaseFirestore.instance
          .collection('Stabit')
          .doc("Student")
          .collection(FirebaseAuth.instance.currentUser!.email.toString())
          .doc("My Cources")
          .collection("Results")
          .doc("Exams")
          .collection("Result")
          .get();

      final quizCollection = await FirebaseFirestore.instance
          .collection('Stabit')
          .doc("Student")
          .collection(FirebaseAuth.instance.currentUser!.email.toString())
          .doc("My Cources")
          .collection("Results")
          .doc("Quiz")
          .collection("Result")
          .get();

      return {
        'exam': examCollection.docs,
        'quiz': quizCollection.docs,
      };
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }
}
