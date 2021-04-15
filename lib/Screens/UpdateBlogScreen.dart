import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
            // FlatButton(
            //   onPressed: () async {
            //     await getImage();
            //     Fluttertoast.showToast(
            //         msg: 'Image Added',
            //         toastLength: Toast.LENGTH_SHORT,
            //         gravity: ToastGravity.BOTTOM,
            //         timeInSecForIosWeb: 1,
            //         backgroundColor: Colors.red,
            //         textColor: Colors.white,
            //         fontSize: 16.0);
            //   },
            //   child: Text('Add Image'),
            //   color: Colors.blueAccent,
            // ),
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
                    msg: 'Please wait ... updating blog',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                await FirebaseDb().UpdateBlog(
                    widget.ds.id,
                    selectedDate.toString().split(' ')[0],
                    description,
                    title,
                    widget.ds['category']);
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