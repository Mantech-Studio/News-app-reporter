import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseDb {
  FirebaseAuth auth = FirebaseAuth.instance;
  //Retrieving user id
  getuid() {
    return auth.currentUser!.uid;
  }

  //Anonymous sign-in
  signinanony() async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    return userCredential.user!.uid;
  }

  //register with email and password
  registerwithemail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      print(e);
    }
    return 'Account Created';
  }

  //Signin with email and Password

  signinwithemail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user!.uid != null) {
        return 'Login Successful';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
  }

  // Function to Update the blog
  UpdateBlog(docid, date, desc, title, category) async {
    await UpdateCategoryBlog(docid, date, desc, title, category);
    CollectionReference users =
        FirebaseFirestore.instance.collection('All News');
    return users
        .doc(docid)
        .update({
          'date': date,
          'description': desc,
          'title': title,
        })
        .then((value) => print("Blog Updated"))
        .catchError((error) => print("Failed to update Blog: $error"));
  }

  // Function to Update Category the blog
  UpdateCategoryBlog(docid, date, desc, title, category) {
    CollectionReference users = FirebaseFirestore.instance.collection(category);
    return users
        .doc(docid)
        .update({
          'date': date,
          'description': desc,
          'title': title,
        })
        .then((value) => print("Category Blog Updated"))
        .catchError((error) => print("Failed to update Category Blog: $error"));
  }

  // Function To Delete a blog
  DeleteBlog(docid, category) async {
    await DeleteCategoryBlog(docid, category);
    CollectionReference blog =
        FirebaseFirestore.instance.collection('All News');
    return blog
        .doc(docid)
        .delete()
        .then((value) => print("Blog Deleted"))
        .catchError((error) => print("Failed to delete Blog: $error"));
  }

  DeleteCategoryBlog(docid, category) {
    CollectionReference blog = FirebaseFirestore.instance.collection(category);
    return blog
        .doc(docid)
        .delete()
        .then((value) => print("Category Blog Deleted"))
        .catchError((error) => print("Failed to delete Blog: $error"));
  }

  //Reset Password
  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  //Sign Out

  signout() async {
    await FirebaseAuth.instance.signOut();
  }
}
