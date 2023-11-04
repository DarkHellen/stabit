import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyCource {
  MyCource() {}
  final Email = FirebaseAuth.instance.currentUser!.email.toString();

  Future<List<Map<String, dynamic>>> retrieveDataAsList() async {
    print(Email);

    final CollectionReference courceList = FirebaseFirestore.instance
        .collection("Stabit")
        .doc("Student")
        .collection(Email)
        .doc("My Cources")
        .collection("Cources");
    print(courceList);
    QuerySnapshot querySnapshot = await courceList.get();
    print(querySnapshot.docs.length);
    List<Map<String, dynamic>> dataList = [];

    querySnapshot.docs.forEach((documentSnapshot) {
      dataList.add(documentSnapshot.data() as Map<String, dynamic>);
      print(documentSnapshot.data());
    });
    print(dataList);
    return dataList;
  }
}
