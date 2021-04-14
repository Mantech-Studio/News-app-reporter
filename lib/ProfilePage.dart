import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app_reporter/DatabaseManager.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    String uid = FirebaseDb().getuid().toString();
    CollectionReference users =
        FirebaseFirestore.instance.collection('profile');
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data()!;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    child: CachedNetworkImage(imageUrl: data['image_url']),
                  ),
                  Text('Full Name: ${data['full_name']}'),
                  Text('Mobile Number: ${data['mobile_number']}'),
                  Text('Company: ${data['company']}'),
                ],
              ),
            );
            //Text("Full Name: ${data['full_name']} ${data['company']}");
          }

          return Text("loading");
        },
      ),
    );
  }
}
