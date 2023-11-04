import 'package:flutter/material.dart';
import 'package:stabit/pages/ExamCource.dart';
import 'package:stabit/pages/QuizCource.dart';
import 'package:stabit/pages/home_page.dart';

import '../pages/Feedback Page.dart';
import '../pages/My Cources page.dart';
import '../pages/Results page.dart';
import '../pages/contact Page.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.pink,
            ),
            child: InkWell(
              onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()))
              },
              child: const Text(
                "Home",
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          ListTile(
            splashColor: Colors.deepPurple,
            title: const Text('My Cources'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const My_Cource_Page()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.co2),
            splashColor: Colors.deepPurple,
            title: const Text('Quiz'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const QuizCource()));
            },
          ),
          ListTile(
            splashColor: Colors.deepPurple,
            title: const Text('Exams'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ExamCource()));
            },
          ),
          ListTile(
            splashColor: Colors.deepPurple,
            title: const Text('Results'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Result_Page()));
            },
          ),
          ListTile(
            splashColor: Colors.deepPurple,
            title: const Text('Feedback'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Feedback_Page()));
            },
          ),
          ListTile(
            splashColor: Colors.deepPurple,
            title: const Text('Contact'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Contact_Page()));
            },
          ),
        ],
      ),
    );
  }
}
