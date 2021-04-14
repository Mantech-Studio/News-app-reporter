import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> addUser() async {
    // Call the user's CollectionReference to add a new user
    String uid = FirebaseDb().getuid().toString();
    CollectionReference users =
        FirebaseFirestore.instance.collection('All News');

    await firebase_storage.FirebaseStorage.instance
        .ref('blog/$uid$title.png')
        .putFile((_image));
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('blog/$uid$title.png')
        .getDownloadURL();
    return users
        .add({
          'title': title,
          'description': description,
          'date': selectedDate.toString().split(' ')[0],
          'category': category,
          'uid': uid,
          'image_url': downloadURL,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Blog')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
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
              onPressed: () {
                getImage();
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
                await addUser();
                Navigator.pop(context);
              },
              child: Text('Upload Blog'),
              color: Colors.blueAccent,
            )
          ],
        ),
      ),
    );
  }
}
