import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  late final email, password;

  Future<void> UserList() async {
    await FirebaseFirestore.instance
        .collection('Admin')
        .doc("UserList")
        .collection("Users")
        .doc()
        .set({
      'Emial': email,
      'Password': password,
    });
  }

  //Google sign in
  signInWithGoogle() async {
    //Begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    //Obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    email = gUser.email;
    password = gUser.serverAuthCode;
    UserList();

    final credential = GoogleAuthProvider.credential(
        idToken: gAuth.idToken, accessToken: gAuth.accessToken);
    //At the end sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
