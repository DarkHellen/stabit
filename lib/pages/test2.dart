// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fl_chart/fl_chart.dart';

// class ResultPage extends StatefulWidget {
//   @override
//   _ResultPageState createState() => _ResultPageState();
// }

// class _ResultPageState extends State<ResultPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Result Page'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('Stabit')
//             .doc("Student")
//             .collection(FirebaseAuth.instance.currentUser!.email.toString())
//             .doc("My Cources")
//             .collection("Results")
//             .doc("Quiz")
//             .collection("Result")
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data == null) {
//             return Center(child: Text('No data available.'));
//           }

//           // Process all documents in the collection
//           final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

//           // Calculate total scores and answers
//           int totalCorrectAnswers = 0;
//           int totalIncorrectAnswers = 0;
//           int totalAnswers = 0;
//           List<String> quizDates = [];

//           for (final doc in documents) {
//             final Map<String, dynamic>? scoresData =
//                 doc.data() as Map<String, dynamic>?;

//             if (scoresData != null) {
//               final int correctAnswers = scoresData['CorrectAnswer'] ?? 0;
//               final int incorrectAnswers = scoresData['IncorrectAnswer'] ?? 0;
//               final String quizDate = scoresData['quizdate'] ?? 'NA';

//               totalCorrectAnswers += correctAnswers;
//               totalIncorrectAnswers += incorrectAnswers;
//               totalAnswers += (correctAnswers + incorrectAnswers);
//               quizDates.add(quizDate);
//             }
//           }

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Text(
//                     'Your Quiz Results',
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 20),
//                   Container(
//                     constraints: BoxConstraints(
//                       maxHeight: 300,
//                       maxWidth: 300,
//                     ),
//                     child: PieChart(
//                       PieChartData(
//                         sections: [
//                           PieChartSectionData(
//                             title: 'Correct',
//                             value: totalCorrectAnswers.toDouble(),
//                             color: Colors.green,
//                           ),
//                           PieChartSectionData(
//                             title: 'Incorrect',
//                             value: totalIncorrectAnswers.toDouble(),
//                             color: Colors.red,
//                           ),
//                         ],
//                         borderData: FlBorderData(show: false),
//                         centerSpaceRadius: 40,
//                         sectionsSpace: 0,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     'Total Answers: $totalAnswers',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     'Quiz Dates: ${quizDates.join(", ")}',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ResultPage extends StatefulWidget {
//   @override
//   _ResultPageState createState() => _ResultPageState();
// }

// class _ResultPageState extends State<ResultPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Result Page'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('Stabit')
//             .doc("Student")
//             .collection(FirebaseAuth.instance.currentUser!.email.toString())
//             .doc("My Cources")
//             .collection("Results")
//             .doc("Quiz")
//             .collection("Result")
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data == null) {
//             return Center(child: Text('No data available.'));
//           }

//           final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

//           if (documents.isEmpty) {
//             return Center(child: Text('No data available.'));
//           }

//           return ListView.builder(
//             itemCount: documents.length,
//             itemBuilder: (context, index) {
//               final doc = documents[index];
//               final Map<String, dynamic>? scoresData =
//                   doc.data() as Map<String, dynamic>?;

//               if (scoresData != null) {
//                 final String date = doc.id;
//                 final int correctAnswers = scoresData['CorrectAnswer'] ?? 0;
//                 final int incorrectAnswers = scoresData['IncorrectAnswer'] ?? 0;
//                 final int scores = scoresData['scores'];

//                 return ListTile(
//                   title: Text('Date: $date'),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Correct Answers: $correctAnswers'),
//                       Text('Incorrect Answers: $incorrectAnswers'),
//                       Text('Scores: $scores'),
//                     ],
//                   ),
//                 );
//               } else {
//                 return SizedBox();
//               }
//             },
//           );
//         },
//       ),
//     );
//   }
// }
