import 'package:cloud_firestore/cloud_firestore.dart';

class CoucesModel {
  CoucesModel();

  final CollectionReference courceList = FirebaseFirestore.instance
      .collection("Stabit")
      .doc("Cources")
      .collection("AllCources");

  Future<List<Map<String, dynamic>>> retrieveDataAsList() async {
    QuerySnapshot querySnapshot = await courceList.get();
    List<Map<String, dynamic>> dataList = [];

    querySnapshot.docs.forEach((documentSnapshot) {
      dataList.add(documentSnapshot.data() as Map<String, dynamic>);
    });

    print(dataList);
    return dataList;
  }
}
