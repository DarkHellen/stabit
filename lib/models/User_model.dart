import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/cupertino.dart";

import "../firebase_options.dart";

class DataBaseManager extends StatelessWidget {
  DataBaseManager() {
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  final CollectionReference profileList = FirebaseFirestore.instance
      .collection("Stabit")
      .doc("Student")
      .collection("Profile");

  Future<void> createUser(String name, String Email, String phoneno, String dor,
      String dob, String photo) async {
    return await profileList.doc(Email).set({
      'Name': name,
      'E-mail': Email,
      'Phone-No': phoneno,
      'Date-of-Registration': dor,
      'Date-of-Birth': dob,
      'Photo': photo
    });
  }

  Future<StudentProfile?> getUser(String Email) async {
    final snapshot = await profileList
        .where("E-mail", isEqualTo: "sujalbugalia12@gmail.com")
        .get();
    final userdata = snapshot.docs
        .map((e) => StudentProfile.fromJson(
            e as DocumentSnapshot<Map<String, dynamic>>))
        .singleOrNull;
    return userdata;
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class StudentProfile {
  final String name;
  final String email;
  final String phoneno;
  final String dor;
  final String dob;
  late final String photo;

  StudentProfile({
    required this.name,
    required this.email,
    required this.dob,
    required this.dor,
    required this.phoneno,
    required this.photo,
  });

  toJson() {
    return {
      name: name,
      email: email,
      phoneno: phoneno,
      dob: dob,
      dor: dor,
      photo: photo,
    };
  }

  factory StudentProfile.fromJson(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final json = document.data()!;

    return StudentProfile(
      name: json['Name'],
      email: json['E-mail'],
      phoneno: json['Phone-No'],
      dob: json['Date-of-Birth'],
      dor: json['Date-of-Registration'],
      photo: json['Photo'],
    );
  }
}
