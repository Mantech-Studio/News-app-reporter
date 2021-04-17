import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app_reporter/DatabaseManager.dart';

class UpdateBlogPage extends StatefulWidget {
  DocumentSnapshot ds;
  UpdateBlogPage(this.ds);
  @override
  _UpdateBlogPageState createState() => _UpdateBlogPageState();
}

class _UpdateBlogPageState extends State<UpdateBlogPage> {
  DateTime selectedDate = DateTime.now();
  late String title;
  late String description;
  final picker = ImagePicker();
  late File _image;
  String uid = FirebaseDb().getuid().toString();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Blogs'),
      ),
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

            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () async {
                Fluttertoast.showToast(
                    msg: 'Please wait ... updating blog',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                await FirebaseDb().UpdateBlog(widget.ds.id, Timestamp.now(),
                    description, title, widget.ds['category'], _image, uid);
                Navigator.pop(context);
              },
              child: Text('Update Blog'),
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
