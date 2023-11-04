import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stabit/components/my_button.dart';
import 'package:stabit/components/my_textfeild.dart';
import 'package:stabit/components/square_file.dart';

import '../services/auth_services.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  RegisterPage({
    super.key,
    this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();
  Future<void> UserList() async {
    await FirebaseFirestore.instance
        .collection('Admin')
        .doc("UserList")
        .collection("Users")
        .doc()
        .set({
      'Emial': emailController.text,
      'Password': passwordController.value.text,
    });
  }

  void signUserUp() async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        UserList();
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        errorMessage("Registered successfully!");
      } else {
        //Navigator.pop(context);
        errorMessage("Password dosen\t match");
      }

      // ignore: use_build_context_synchronously
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        errorMessage("Email not valid!");
      } else if (e.code == "wrong-password") {
        errorMessage("inavlid password!");
      } // else {
      //   showDialog(
      //       context: context,
      //       builder: (context) {
      //         return AlertDialog(
      //           title: Text(e.code.toString()),
      //         );
      //       });
      // }
    }
  }

  void errorMessage(String text1) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text(text1)),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              // ignore: unnecessary_const
              const SizedBox(height: 25),
              //logo

              const Icon(
                Icons.lock,
                size: 52,
              ),

              const SizedBox(
                height: 50,
              ),

              const Text(
                "let\s create an account for you!",
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 16,
                ),
              ),

              const SizedBox(
                height: 50,
              ),

              MyTextFeild(
                controller: emailController,
                obsecureText: false,
                hintText: 'Email',
              ),
              const SizedBox(
                height: 25,
              ),

              //password textfeild

              MyTextFeild(
                controller: passwordController,
                obsecureText: true,
                hintText: 'Password',
              ),

              const SizedBox(
                height: 10,
              ),

              const SizedBox(
                height: 25,
              ),

              //password textfeild

              MyTextFeild(
                controller: confirmPasswordController,
                obsecureText: true,
                hintText: ' Confirm Password',
              ),

              const SizedBox(
                height: 25,
              ),

              MyButton(
                text: "sign up",
                onTap: signUserUp,
              ),

              const SizedBox(
                height: 50,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "or continue with",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SquareFile(
                  imagePath: 'lib/images/google.png',
                  onTap: () {
                    AuthService().signInWithGoogle();
                  },
                ),
              ]),

              const SizedBox(
                height: 15,
              ),

              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account!",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Login  Now",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
