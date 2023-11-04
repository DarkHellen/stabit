import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:stabit/components/Drawer.dart';
import 'package:stabit/pages/Form.dart';

import 'package:stabit/pages/cource_page.dart';

import 'package:stabit/pages/profilrpage.dart';

class HomePage extends StatelessWidget {
  var i = 0;

  HomePage({super.key});
  int index = 0;
  //final screens = [HomePage(), ProfilePage()];

  final user = FirebaseAuth.instance.currentUser?.email?.split("@");

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: Scaffold(
            drawer: const SideDrawer(),
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              actions: [
                Center(child: Text("hi!  " + user!.first)),
                IconButton(
                    onPressed: signOut, icon: const Icon(Icons.logout_sharp))
              ],
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
                      MaterialPageRoute(builder: (context) => ProfileForm1()));
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
            body: Center(
              child: Image.network(
                  'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2Fa5%2F05%2Fa8%2Fa505a8238d241ea60906a3723cd0444a.jpg&f=1&nofb=1&ipt=2b80e109cc7a6dce42e17254527cee7593b1171137412a1058d0d3a56a129071&ipo=images'),
            )));
  }
}
