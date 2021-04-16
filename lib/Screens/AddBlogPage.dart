import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app_reporter/DatabaseManager.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddBlogPage extends StatefulWidget {
  @override
  _AddBlogPageState createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  String category = 'Please Select Category';
  DateTime selectedDate = DateTime.now();
  String dropdownValue = 'Please Select Category';
  final picker = ImagePicker();
  late File _image;
  late String title;
  late String description;
  late String username;
  var docid;
  // Retrieving user id and storing it in uid
  String uid = FirebaseDb().getuid().toString();
  // Widget to select Date
  _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    ))!;
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  // Function to get the image from gallery
  Future getImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

        print(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  // Function to get the current users username
  Future<void> getemail() async {
    FirebaseFirestore.instance
        .collection("profile")
        .doc(uid)
        .snapshots()
        .listen((event) {
      setState(() {
        username = event.get("full_name");
      });
    });
  }

  //Function to Add Data to Database (category-> All news)
  Future<void> addUser() async {
    // Call the user's CollectionReference to add a new user

    CollectionReference users =
        FirebaseFirestore.instance.collection('All News');
    CollectionReference profile =
        FirebaseFirestore.instance.collection('profile');
    await firebase_storage.FirebaseStorage.instance
        .ref('blog/$uid$title.png')
        .putFile((_image));
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('blog/$uid$title.png')
        .getDownloadURL();
    await addcategory(downloadURL);
    await profile.doc(uid).update({'total_blogs': FieldValue.increment(1)});
    return users
        .doc(docid)
        .set({
          'title': title,
          'description': description,
          'date': selectedDate.toString().split(' ')[0],
          'category': category,
          'uid': uid,
          'image_url': downloadURL,
          'username': username,
          'views': 0,
          'impression': 0,
        })
        .then((value) => print('blog added'))
        .catchError((error) => print("Failed to add user: $error"));
  }

  //Function to add data based on category
  Future<void> addcategory(downloadUrl) async {
    // Call the user's CollectionReference to add a new user
    String uid = FirebaseDb().getuid().toString();
    CollectionReference users =
        FirebaseFirestore.instance.collection('$category');
    return users.add({
      'title': title,
      'description': description,
      'date': selectedDate.toString().split(' ')[0],
      'category': category,
      'uid': uid,
      'image_url': downloadUrl,
      'username': username,
      'views': 0,
      'impression': 0,
    }).then((value) {
      setState(() {
        docid = value.id;
      });
    }).catchError((error) => print("Failed to add user: $error"));
  }

  @override
  void initState() {
    // TODO: implement initState
    getemail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Blog')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // TODO: check if data entered is valid and displaying error message
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
                onChanged: (val1) {
                  setState(() {
                    title = val1;
                  });
                },
              ),
            ),
            FlatButton(
              onPressed: () async {
                await getImage();
                Fluttertoast.showToast(
                    msg: 'Image Added',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
              child: Text('Add Image'),
              color: Colors.blueAccent,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
                onChanged: (val2) {
                  setState(() {
                    description = val2;
                  });
                },
              ),
            ),
            Row(
              children: [
                Text('Category: '),
                SizedBox(
                  width: 10,
                ),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                      category = dropdownValue;
                    });
                  },
                  items: <String>[
                    'Please Select Category',
                    'International',
                    'National',
                    'City',
                    'Buisness'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            Row(
              children: [
                Text('Date :'),
                SizedBox(width: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    RaisedButton(
                      onPressed: () => _selectDate(context), // Refer step 3
                      child: Text(
                        'change date',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      color: Colors.blueAccent,
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () async {
                Fluttertoast.showToast(
                    msg: 'Please wait ... uploading blog',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                await addUser();
                Navigator.pop(context);
              },
              child: Text('Upload Blog'),
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
