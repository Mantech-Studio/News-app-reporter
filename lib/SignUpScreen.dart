import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app_reporter/AddProfileScreen.dart';
import 'package:news_app_reporter/DatabaseManager.dart';

class SignUpPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SignUpPage> {
  late String nameController;
  late String passwordController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('News App'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign up',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    onChanged: (val1) {
                      setState(() {
                        nameController = val1;
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    onChanged: (val2) {
                      setState(() {
                        passwordController = val2;
                      });
                    },
                  ),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Sign Up'),
                      onPressed: () async {
                        await Firebase.initializeApp();
                        String txt = await FirebaseDb().registerwithemail(
                            nameController, passwordController);
                        if (txt == 'Account Created') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpProfile()),
                          );
                        } else {
                          await Fluttertoast.showToast(
                              msg: txt,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          Navigator.pop(context);
                        }

                        //print(nameController.text);
                        // print(passwordController.text);
                      },
                    )),
                Container(
                    child: Row(
                  children: <Widget>[
                    Text('Already have account?'),
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
              ],
            )));
  }
}
