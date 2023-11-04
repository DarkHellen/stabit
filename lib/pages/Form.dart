import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ProfileForm1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.deepPurple,
      title: 'Profile Form',
      theme: ThemeData(
        primaryColor: Colors.purple,
      ),
      home: ProfileForm(),
    );
  }
}

class ProfileForm extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String dob;
  late String occupation;
  late String phoneNumber;
  late String bio;
  late String interests;
  XFile? selectedImage;

  Future<String?> uploadImageToFirebaseStorage() async {
    print("entering into tc");
    try {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final UploadTask uploadTask =
          storageReference.putFile(File(selectedImage!.path));

      final TaskSnapshot downloadUrl = await uploadTask;
      final String imageUrl = await downloadUrl.ref.getDownloadURL();
      print("image uploaded");

      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final imageUrl = await uploadImageToFirebaseStorage();
      if (imageUrl != null) {
        final user = FirebaseAuth.instance.currentUser;
        final uid = user?.uid;

        await FirebaseFirestore.instance
            .collection('Stabit')
            .doc('Student')
            .collection(FirebaseAuth.instance.currentUser!.email!)
            .doc('Profile')
            .set({
          'Name': name,
          'DoB': dob,
          'Occupation': occupation,
          'PhoneNumber': phoneNumber,
          'Bio': bio,
          'Interests': interests,
          'ImageUrl': imageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
          ),
        );
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Profile Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.deepPurple),
                ),
                onPressed: () async {
                  final picker = ImagePicker();
                  final pickedImage =
                      await picker.pickImage(source: ImageSource.gallery);

                  if (pickedImage != null) {
                    setState(() {
                      selectedImage = pickedImage;
                    });
                  }
                },
                child: const Text('Select Image'),
              ),
              selectedImage != null
                  ? Image.file(File(selectedImage!.path))
                  : const SizedBox(),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Date of Birth'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your date of birth';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    dob = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Interests'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Interests';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    interests = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Occupation'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your occupation';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    occupation = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Bio'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your bio';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    bio = value;
                  });
                },
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.deepPurple),
                ),
                onPressed: () {
                  _submitForm();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
