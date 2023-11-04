import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  UserData();
  final Email = FirebaseAuth.instance.currentUser!.email.toString();
  var name = "";
  var occupation = "";
  var contactNo = "";
  var bio = "";
  var photo = "";
  var city = "";
  var dob = "";

  Future<Map<String, dynamic>> retrieveDataAsList() async {
    print(Email);

    final CollectionReference courceList = FirebaseFirestore.instance
        .collection("Stabit")
        .doc("Student")
        .collection(Email);

    DocumentSnapshot<Object?> documentSnapshot =
        await courceList.doc("Student Profile").get();

    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    name = data["Name"];
    print(data);

    return data;
  }

  //////////////////////////////////////////////
  Map<String, dynamic> retrieveDataAsList1() {
    print(Email);

    final CollectionReference courceList = FirebaseFirestore.instance
        .collection("Stabit")
        .doc("Student")
        .collection(Email);

    Map<String, dynamic> data = {};

    courceList.doc("Student Profile").get().then((value) {
      if (value.exists) {
        data = value.data()! as Map<String, dynamic>;
        name = data["Name"];
        print(name);
      }
    });

    print(data["Name"]);

    print(data);

    return data;
  }
  /////////////////////////////////////////////
}

// name = data["Name"];
//     occupation = data["Occupation"];
//     email = data["Email"];
//     contactNo = data["Contact No"];
//     bio = data["Bio"];
//     photo = data["Photo"];
//     city = data["City"];
//     dob = data["Date of birth"];