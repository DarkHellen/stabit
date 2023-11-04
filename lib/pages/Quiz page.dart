import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/Drawer.dart';
import 'Results page.dart';

class QuizPage extends StatefulWidget {
  final String name;

  QuizPage({Key? key, required this.name}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<QuizQuestion> quizQuestions = [];
  int currentQuestionIndex = 0;
  String? selectedAnswer = "";
  int score = 0;
  bool hasTakenQuiz = false;

  @override
  void initState() {
    super.initState();
    checkIfQuizTaken();
    fetchQuizQuestions(widget.name).then((questions) {
      setState(() {
        quizQuestions = questions;
      });
    });
  }

  void checkIfQuizTaken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool takenQuiz = prefs.getBool('hasTakenQuiz') ?? false;

    if (takenQuiz) {
      String lastQuizCourse = prefs.getString('lastQuizCourse') ?? "";

      if (lastQuizCourse == widget.name) {
        DateTime quizDateTime =
            DateTime.parse(prefs.getString('quizDateTime')!);

        if (DateTime.now().difference(quizDateTime).inHours >= 24) {
          setHasTakenQuiz(false);
        }
      }
    }

    setState(() {
      hasTakenQuiz = takenQuiz;
    });
  }

  void setHasTakenQuiz(bool taken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (taken) {
      prefs.setBool('hasTakenQuiz', true);
      prefs.setString('lastQuizCourse', widget.name);
      prefs.setString('quizDateTime', DateTime.now().toString());
    } else {
      prefs.remove('hasTakenQuiz');
      prefs.remove('lastQuizCourse');
      prefs.remove('quizDateTime');
    }

    setState(() {
      hasTakenQuiz = taken;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: const Text("Quiz"),
        backgroundColor: Colors.deepPurple,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: hasTakenQuiz
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                        'https://media.tenor.com/WH_sqjbDds8AAAAi/yellow-duckling-happy.gif'),
                    const Text(
                      "You have already taken the quiz!",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              )
            : quizQuestions.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Question ${currentQuestionIndex + 1}: ${quizQuestions[currentQuestionIndex].question}",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      ...quizQuestions[currentQuestionIndex]
                          .options
                          .map((option) {
                        return ListTile(
                          title: Text(option),
                          leading: Radio<String>(
                            value: option,
                            groupValue: selectedAnswer,
                            onChanged: (value) {
                              setState(() {
                                selectedAnswer = value!;
                              });
                            },
                          ),
                        );
                      }).toList(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.pink),
                          ),
                          onPressed: () {
                            String correctAnswer =
                                quizQuestions[currentQuestionIndex]
                                    .correctAnswer;
                            if (selectedAnswer == correctAnswer) {
                              setState(() {
                                score++;
                              });
                            }

                            if (currentQuestionIndex <
                                quizQuestions.length - 1) {
                              setState(() {
                                currentQuestionIndex++;
                                selectedAnswer = null;
                              });
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Quiz Result"),
                                    content: Text(
                                        "Your score is $score/${quizQuestions.length}"),
                                    actions: [
                                      TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.pink),
                                        ),
                                        onPressed: () {
                                          AddResult(score);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Result_Page(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          "OK",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                              setHasTakenQuiz(true);
                            }
                          },
                          child: const Text("Submit"),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Future<void> _refreshPage() async {
    List<QuizQuestion> refreshedQuestions =
        await fetchQuizQuestions(widget.name);
    setState(() {
      quizQuestions = refreshedQuestions;
      currentQuestionIndex = 0;
      selectedAnswer = null;
      score = 0;
    });
  }

  Future<void> AddResult(int scores) async {
    final int incorrect = scores - quizQuestions.length;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setHasTakenQuiz(true);

    await prefs.setBool('hasTakenQuiz', true);
    return await FirebaseFirestore.instance
        .collection("Stabit")
        .doc("Student")
        .collection(FirebaseAuth.instance.currentUser!.email.toString())
        .doc("My Cources")
        .collection("Results")
        .doc("Quiz")
        .collection("Result")
        .doc(DateTime.now().toString())
        .set({
      "quizdate": DateTime.now().toString(),
      "scores": scores,
      "CorrectAnswer": scores,
      "IncorrectAnswer": incorrect,
    });
  }

  Future<List<QuizQuestion>> fetchQuizQuestions(String name) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("Stabit")
        .doc("Cources")
        .collection("PaidCources")
        .doc(name)
        .collection("Quiz")
        .get();

    List<QuizQuestion> questions = [];

    querySnapshot.docs.forEach((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      List<dynamic> options = data['options'];
      int correctAnswerIndex = data['correctAnswerIndex'];
      String correctAnswer = options[correctAnswerIndex];
      String question = data['question'];

      questions.add(QuizQuestion(
        question: question,
        options: List<String>.from(options),
        correctAnswer: correctAnswer,
      ));
    });

    return questions;
  }
}

class QuizQuestion {
  String question;
  List<String> options;
  String correctAnswer;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}
