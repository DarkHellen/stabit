import 'dart:convert';
//import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stabit/pages/My%20Cources%20page.dart';

class Payments extends StatefulWidget {
  Payments(
      {Key? key,
      required this.fees,
      required this.cource,
      required this.TeacherName,
      required this.photo,
      required this.desc})
      : super(key: key);
  final fees;
  final cource;
  final TeacherName;
  final photo;
  final desc;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Payments> {
  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    final cource = widget.cource;
    final teacherName = widget.TeacherName;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Checkout'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("cource name : $cource"),
            const SizedBox(
              height: 25,
            ),
            Text("cource name : $teacherName"),
            TextButton(
              child: const Text('Confirm Payment'),
              onPressed: () async {
                await makePayment(widget.cource, widget.desc, widget.fees,
                    widget.TeacherName, widget.photo);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment(
      String name, String desc, String price, String tn, String photo) async {
    try {
      paymentIntent = await createPaymentIntent(price, 'INR');

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.dark,
                  merchantDisplayName: 'sujal'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet(name, desc, price, tn, photo);
    } catch (err) {
      throw Exception(err);
    }
  }

  displayPaymentSheet(
      String name, String desc, String price, String tn, String photo) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        await addCource(name, desc, price, tn, photo);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const My_Cource_Page()));
        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text("Payment Successful!"),
                    ],
                  ),
                ));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  Text("Payment Failed"),
                ],
              ),
              Text("Stripe Error: ${e.error}"),
            ],
          ),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  Text("Payment Failed"),
                ],
              ),
              Text("Stripe Error: ${e.toString()}"),
            ],
          ),
        ),
      );
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      // Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };
      String encodedBody = body.keys
          .map((key) => "$key=${Uri.encodeComponent(body[key])}")
          .join("&");

      // Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: encodedBody,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create payment intent');
      }
    } on StripeException catch (e) {
      print('Stripe Error: $e');
      throw Exception('Stripe Error: $e');
    } catch (err) {
      print('Error: $err');
      throw Exception('Error: $err');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  Future<void> addCource(
      String name, String desc, String price, String tn, String photo) async {
    await FirebaseFirestore.instance
        .collection("Admin")
        .doc("SelledCources")
        .collection("Cources")
        .doc()
        .set({
      'Cource Name': name,
      'Description': desc,
      'Price': price,
      'Date-of-purchase': DateTime.now(),
      'Teacher Name': tn,
      'Photo': photo
    });

    CollectionReference videosCollection = FirebaseFirestore.instance
        .collection("Stabit")
        .doc("Cources")
        .collection("PaidCources");
    // Assuming "Videos" is the collection with video URLs.

// You need to use .doc(name).get() to retrieve a specific document, not .doc(name).get.
    DocumentSnapshot videoSnapshot = await videosCollection.doc(name).get();

    List<String> videoUrls = [];

    if (videoSnapshot.exists) {
      Map<String, dynamic>? data =
          videoSnapshot.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('videos')) {
        // Assuming the video URLs are stored in an array field called 'videos' in the document.
        videoUrls = List<String>.from(data['videos']);
      }
    }
    return await FirebaseFirestore.instance
        .collection("Stabit")
        .doc("Student")
        .collection(FirebaseAuth.instance.currentUser!.email.toString())
        .doc("My Cources")
        .collection("Cources")
        .doc(name)
        .set({
      'Cource Name': name,
      'Description': desc,
      'Price': price,
      'Date-of-purchase': DateTime.now(),
      'Teacher Name': tn,
      'Photo': photo,
      'Videos': videoUrls
    });
  }
}
