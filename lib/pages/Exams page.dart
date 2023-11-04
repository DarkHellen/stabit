import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stabit/pages/Results%20page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:timer_count_down/timer_count_down.dart';

import '../components/Drawer.dart';

class Exams_Page extends StatelessWidget {
  final name;

  const Exams_Page({super.key, this.name});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExamScreen(),
    );
  }
}

class ExamScreen extends StatefulWidget {
  final name = const Exams_Page().name;
  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> with TickerProviderStateMixin {
  final name = const Exams_Page().name;
  List<ExamQuestion> questions = [];
  int currentQuestionIndex = 0;
  Map<int, String> userAnswers = {};
  int initialTime = 120; // Adjust this to 20 minutes in seconds
  late AnimationController _controller;
  bool resultAdded = false;
  int currentTime = 60;
  bool isExamTaken = false; // Flag to check if the exam has already been taken

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: initialTime),
    );
    _controller.reverse(from: initialTime.toDouble());
    isExamTaken = true;
    _controller.addListener(() {
      setState(() {
        currentTime = _controller.value.ceil();
        if (currentTime == 0) {
          _controller.stop();
          AddResult();
          NextScreen();
        }
      });
    });

    checkIfExamTaken(); // Check if the exam has already been taken
    if (isExamTaken) {
      // Disable the exam or show a message
      // You can implement this logic here
    } else {
      fetchQuestions(); // Fetch questions only if the exam is not taken
    }
  }

  Future<void> checkIfExamTaken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isExamTaken = prefs.getBool('is_exam_taken') ?? false;
  }

  // Fetch questions from Firebase or another data source
  Future<void> fetchQuestions() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("Stabit")
        .doc("Cources")
        .collection("PaidCources")
        .doc(name)
        .collection("Exams")
        .get();

    questions = [];

    querySnapshot.docs.forEach((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      List<dynamic> options = data['options'];
      String correctAnswer = data['correctAnswer'];
      String question = data['question']; // Add this line to fetch the question

      questions.add(ExamQuestion(
        question: question,
        options: List<String>.from(options),
        correctOption: correctAnswer,
      ));
    });
    setState(() {});
  }

  void selectAnswer(int questionIndex, String selectedOption) {
    setState(() {
      userAnswers[questionIndex] = selectedOption;
    });
  }

  void goToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  void goToNextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  void NextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_exam_taken',
        true); // Set the flag to indicate that the exam has been taken

    WidgetsBinding.instance.exitApplication(AppExitType.required);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Result_Page(),
          ),
        );
      }
    });
  }

  Future<void> AddResult() async {
    if (!resultAdded) {
      resultAdded = true; // Set the flag to true to prevent multiple calls

      int scores = calculateScore(questions, userAnswers);

      // Store the score in preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('exam_score', scores);

      await FirebaseFirestore.instance
          .collection("Stabit")
          .doc("Student")
          .collection(FirebaseAuth.instance.currentUser!.email.toString())
          .doc("My Cources")
          .collection("Results")
          .doc("Exams")
          .collection("Result")
          .doc(DateTime.now().toString())
          .set({"Exam Date": DateTime.now().toString(), "scores": scores});

      NextScreen();
    }
  }

  int calculateScore(
      List<ExamQuestion> questions, Map<int, String> userAnswers) {
    int score = 0;
    if (userAnswers.isEmpty) {
      return 0;
    }
    for (int i = 0; i < questions.length; i++) {
      ExamQuestion question = questions[i];
      String? userAnswer = userAnswers[i];

      if (userAnswer != null) {
        if (userAnswer == question.correctOption) {
          score++;
        }
      }
    }

    return score;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Exam App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildTimer(),
            buildQuestion(),
            buildOptions(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                if (currentQuestionIndex > 0)
                  ElevatedButton(
                    onPressed: goToPreviousQuestion,
                    child: const Text('Previous'),
                  ),
                if (currentQuestionIndex < questions.length - 1)
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.pink),
                    ),
                    onPressed: goToNextQuestion,
                    child: const Text('Next'),
                  ),
              ],
            ),
            ElevatedButton(
              onPressed: AddResult,
              child: const Text('Submit Exam'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }

  Widget buildTimer() {
    return Countdown(
      seconds: initialTime,
      build: (BuildContext context, double time) {
        if (time == 0) {
          AddResult();
          NextScreen();
        }
        return Text(
          '${(time / 60).floor()}:${(time % 60).floor()}',
          style: const TextStyle(fontSize: 24),
        );
      },
      interval: const Duration(seconds: 1),
    );
  }

  Widget buildQuestion() {
    if (currentQuestionIndex >= 0 && currentQuestionIndex < questions.length) {
      return Text(
        'Q${currentQuestionIndex + 1}: ${questions[currentQuestionIndex].question}',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      );
    } else {
      return const Text(
        'No question available at this index.',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      );
    }
  }

  Widget buildOptions() {
    if (currentQuestionIndex >= 0 && currentQuestionIndex < questions.length) {
      final currentQuestion = questions[currentQuestionIndex];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: currentQuestion.options.map((option) {
          bool isSelected = userAnswers[currentQuestionIndex] == option;
          return ListTile(
            leading: Radio(
              value: option,
              groupValue: userAnswers[currentQuestionIndex],
              onChanged: (value) => selectAnswer(currentQuestionIndex, value!),
            ),
            title: Text(option),
          );
        }).toList(),
      );
    } else {
      return const Text(
        'No options available for this question.',
        style: TextStyle(fontSize: 20),
      );
    }
  }
}

class ExamQuestion {
  final String question;
  final List<String> options;
  final String correctOption;

  ExamQuestion({
    required this.question,
    required this.options,
    required this.correctOption,
  });
}
