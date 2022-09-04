import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:word_app/model/user.dart' as model;
import 'package:word_app/services/storage_methods.dart';
import 'package:word_app/view/screens/login_page.dart';
import 'package:word_app/view/screens/main_page.dart';

class AuthMethods {
  // Firebase Authentication methods
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storageMethods = StorageMethods();

  // Sign up a user with email and password name and profile image
  Future<User?> signUpWithEmailAndPassword({
    required String email,
      required String password,
      required String name,
      required PickedFile profileImage,
      required BuildContext context
      }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        String urlDownload = await storageMethods.uploadImage(profileImage);

        await _auth.currentUser!.updateDisplayName(name);

        model.User userModel = model.User(
            uid: user.uid,
            email: user.email!,
            displayName: user.displayName,
            photoURL: urlDownload);

        await _firestore.collection('users').doc(user.uid).set(userModel.toJson());

        // if signup is successful navigate to main page
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, MainPage.routeName);
      }
    });

      }
      return user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.code.toString()),
        ),
      );
    } catch (e) {
      print(e);
    }

    

    return null;
  }

  // Sign in a user with email and password
  Future<User?> signInWithEmailAndPassword({
    required String email,
      required String password,
      required BuildContext context
      }) async {
    try {
      UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.code.toString()),
        ),
      );
    } catch (e) {
      print(e);
    }

    // if signin is successful navigate to main page
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, MainPage.routeName);
      }
    });

    return null;
  }

  // Sign out a user
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();

    // if signout is successful navigate to login page
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      }
    });
  }
}
