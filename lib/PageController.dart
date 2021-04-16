import 'package:flutter/material.dart';
import 'Screens/BlogPage.dart';
import 'package:news_app_reporter/DatabaseManager.dart';
import 'Screens/HoroscopePage.dart';
import 'Screens/LoginScreen.dart';
import 'Screens/ProfilePage.dart';

class PageControllerScreen extends StatefulWidget {
  @override
  _PageControllerScreenState createState() => _PageControllerScreenState();
}

class _PageControllerScreenState extends State<PageControllerScreen> {
  //used to control page number
  final PageController controller = PageController(initialPage: 0);
  int pageno = 0;
  _onPageViewChange(int page) {
    setState(() {
      pageno = page;
    });

  }

  void buttonTapped(int index) {
    setState(() {
      pageno = index;
      controller.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

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
                //Sign out Function is called
                await FirebaseDb().signout();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false);
              },
            )
          ],
        ),
        body: Column(children: [
          Row(
            children: [
              FlatButton(
                shape: pageno == 0
                    ? Border(bottom: BorderSide(color: Colors.red, width: 2))
                    : Border(bottom: BorderSide(color: Colors.white, width: 2)),
                onPressed: () {
                  buttonTapped(0);
                },
                child: Text('Blog Page'),
              ),
              FlatButton(
                shape: pageno == 1
                    ? Border(bottom: BorderSide(color: Colors.red, width: 2))
                    : Border(bottom: BorderSide(color: Colors.white, width: 2)),
                onPressed: () {
                  buttonTapped(1);
                },
                child: Text('Horoscope Page'),
              ),
              FlatButton(
                shape: pageno == 2
                    ? Border(bottom: BorderSide(color: Colors.red, width: 2))
                    : Border(bottom: BorderSide(color: Colors.white, width: 2)),
                onPressed: () {
                  buttonTapped(2);
                },
                child: Text('Profile Page'),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              scrollDirection: Axis.horizontal,
              pageSnapping: true,
              controller: controller,
              onPageChanged: _onPageViewChange,
              children: [
                BlogPage(),
                HoroscopePage(),
                ProfilePage(),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
