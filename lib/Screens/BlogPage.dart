import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app_reporter/Screens/DisplayBlogScreen.dart';
import 'package:news_app_reporter/Screens/UpdateBlogScreen.dart';
import 'AddBlogPage.dart';
import 'package:news_app_reporter/DatabaseManager.dart';

class BlogPage extends StatefulWidget {
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  String uid = FirebaseDb().getuid().toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Retrieving data form database
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('All News')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('No Data available'));
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  if (ds['uid'] == uid) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DisplayBlog(ds)));
                      },
                      child: Card(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              width: 400,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                      ds['image_url']),
                                ),
                              ),
                            ),
                            Text(ds['title']),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateBlogPage(ds)));
                                    },
                                    icon: Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () async {
                                      CollectionReference profile =
                                          FirebaseFirestore.instance
                                              .collection('profile');
                                      await profile.doc(uid).update({
                                        'total_blogs': FieldValue.increment(-1)
                                      });
                                      FirebaseDb()
                                          .DeleteBlog(ds.id, ds['category']);
                                    },
                                    icon: Icon(Icons.delete))
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Text('');
                  }
                });
          }
        },
      ),
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
