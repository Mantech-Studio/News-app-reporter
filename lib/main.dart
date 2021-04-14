import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news_app_reporter/LoginScreen.dart';
import 'package:news_app_reporter/PageController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (FirebaseAuth.instance.currentUser?.uid == null) {
    runApp(MaterialApp(
      home: LoginPage(),
    ));
  } else {
    runApp(MaterialApp(
      home: PageControllerScreen(),
    ));
  }
}
