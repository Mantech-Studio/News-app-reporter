import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayBlog extends StatefulWidget {
  DocumentSnapshot ds;
  DisplayBlog(this.ds);
  @override
  _DisplayBlogState createState() => _DisplayBlogState();
}

class _DisplayBlogState extends State<DisplayBlog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Blog Page'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Text(widget.ds['title']),
            Container(
              height: 100,
              width: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(widget.ds['image_url']),
                ),
              ),
            ),
            Text(widget.ds['description']),
            Text(widget.ds['date']),
            Text(widget.ds['category']),
          ],
        ),
      ),
    );
  }
}
