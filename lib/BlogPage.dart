import 'package:flutter/material.dart';
import 'package:news_app_reporter/AddBlogPage.dart';

class BlogPage extends StatefulWidget {
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('This is blog Page'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddBlogPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
