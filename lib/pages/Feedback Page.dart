import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stabit/pages/home_page.dart';

class Feedback_Page extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<Feedback_Page> {
  // Initialize Firebase and retrieve course names
  late List<String> courseNames = [];
  String selectedCourse = "select the cource";
  String email = '';
  String message = '';
  int rating = 1;

  @override
  void initState() {
    super.initState();
    fetchCourseNames();
  }

  void fetchCourseNames() async {
    try {
      await Firebase.initializeApp();
      final snapshot = await FirebaseFirestore.instance
          .collection("Stabit")
          .doc("Student")
          .collection(FirebaseAuth.instance.currentUser!.email!)
          .doc("My Cources")
          .collection("Cources")
          .get();
      courseNames =
          snapshot.docs.map((doc) => doc.get('Cource Name') as String).toList();
      // Set the initial selected course
      if (courseNames.isNotEmpty) {
        setState(() {
          selectedCourse = courseNames[0];
        });
      }
    } catch (e) {
      print('Error fetching course names: $e');
    }
  }

  void addFeedback() async {
    await FirebaseFirestore.instance
        .collection("Stabit")
        .doc("Feedbacks")
        .collection("Cources")
        .doc(DateTime.now().toIso8601String())
        .set({
      "Cource Name": selectedCourse,
      "Email": email,
      "Message": message,
      "Ratings": rating
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Feedback Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            DropdownButtonFormField<String>(
              value: selectedCourse,
              items: courseNames.map<DropdownMenuItem<String>>((String course) {
                return DropdownMenuItem<String>(
                  value: course,
                  child: Text(course),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCourse = newValue!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Select Course',
              ),
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  message = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Message',
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  rating = int.parse(value);
                });
              },
              decoration: const InputDecoration(
                labelText: 'Rating (1-5)',
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
              ),
              onPressed: addFeedback,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
