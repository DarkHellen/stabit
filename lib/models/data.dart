import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'User_model.dart';

// ignore: must_be_immutable
class Data extends StatelessWidget {
  var name;
  var email;
  var phoneno;
  var dor;
  var dob;
  var photo;
  Data(
      {super.key,
      this.name,
      this.email,
      this.phoneno,
      this.dor,
      this.dob,
      this.photo});

  DataBaseManager d1 = new DataBaseManager();
  final Email = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<StudentProfile?>(
        future: d1.getUser(Email!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            name = snapshot.data!.name;
            email = snapshot.data!.email;
            phoneno = snapshot.data!.phoneno;
            dor = snapshot.data!.dor;
            dob = snapshot.data!.dob;
            photo = snapshot.data!.photo;
            return Text(snapshot.data!.email);
          } else if (snapshot.hasError) {
            print('${snapshot.error}');
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  String getPhoto() {
    @override
    Widget build(BuildContext context) {
      return FutureBuilder<StudentProfile?>(
        future: d1.getUser(Email!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            name = snapshot.data!.name;
            email = snapshot.data!.email;
            phoneno = snapshot.data!.phoneno;
            dor = snapshot.data!.dor;
            dob = snapshot.data!.dob;
            photo = snapshot.data!.photo;
            print(dob);
            return Text(snapshot.data!.email);
          } else if (snapshot.hasError) {
            print('${snapshot.error}');
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      );
    }

    photo ??= "https://clipart-library.com/img1/1081840.gif";
    return photo;
  }
}
