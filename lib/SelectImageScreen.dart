import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app_reporter/DatabaseManager.dart';
import 'package:news_app_reporter/LoginScreen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SelectImage extends StatefulWidget {
  String name;
  String mobnum;
  String company;
  SelectImage(this.name, this.mobnum, this.company);
  @override
  _SelectImageState createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  late File _image;
  final picker = ImagePicker();
  bool loading = false;
  Future getImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        loading = true;
        print(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> addUser() async {
    // Call the user's CollectionReference to add a new user
    String uid = FirebaseDb().getuid().toString();
    CollectionReference users =
        FirebaseFirestore.instance.collection('profile');

    await firebase_storage.FirebaseStorage.instance
        .ref('profile/$uid.png')
        .putFile((_image));
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('profile/$uid.png')
        .getDownloadURL();
    return users
        .doc(uid)
        .set({
          'full_name': widget.name,
          'company': widget.company,
          'mobile_number': widget.mobnum,
          'image_url': downloadURL,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Column(
        children: [
          loading == false
              ? Text('Please Select an Image')
              : Container(height: 200, width: 200, child: Image.file(_image)),
          FlatButton(
              onPressed: () async {
                await addUser();
                await Fluttertoast.showToast(
                    msg: 'Account Created',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false);
              },
              child: Text('Done'),
              color: Colors.blueAccent)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
