import 'package:flutter/material.dart';
import 'package:news_app_reporter/BlogPage.dart';
import 'package:news_app_reporter/DatabaseManager.dart';
import 'package:news_app_reporter/HoroscopePage.dart';
import 'package:news_app_reporter/LoginScreen.dart';
import 'package:news_app_reporter/ProfilePage.dart';

class PageControllerScreen extends StatefulWidget {
  @override
  _PageControllerScreenState createState() => _PageControllerScreenState();
}

class _PageControllerScreenState extends State<PageControllerScreen> {
  final PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('ABC News'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () async {
                await FirebaseDb().signout();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false);
              },
            )
          ],
        ),
        body: PageView(
          scrollDirection: Axis.horizontal,
          pageSnapping: true,
          controller: controller,
          children: [
            BlogPage(),
            HoroscopePage(),
            ProfilePage(),
          ],
        ),
      ),
    );
  }
}
