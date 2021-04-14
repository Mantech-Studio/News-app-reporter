import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:news_app_reporter/SelectImageScreen.dart';

class SignUpProfile extends StatefulWidget {
  @override
  _SignUpProfileState createState() => _SignUpProfileState();
}

class _SignUpProfileState extends State<SignUpProfile> {
  late String name;
  late String mobnumber;
  late String company;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Profile'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Full Name',
                  ),
                  onChanged: (val1) {
                    setState(() {
                      name = val1;
                    });
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                  ),
                  onChanged: (val2) {
                    setState(() {
                      mobnumber = val2.toString();
                    });
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Company',
                  ),
                  onChanged: (val3) {
                    setState(() {
                      company = val3;
                    });
                  },
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SelectImage(name, mobnumber, company)),
                  );
                },
                child: Text('Next'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
