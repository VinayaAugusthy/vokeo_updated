// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vokeo/controller/resourses/storage_methods.dart';

import '../../../models/user.dart' as model;
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../views/bottom_nav/bottom_nav_screen.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  Future<String> signupUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error has been occured";

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        //Registering user

        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
            email: email,
            uid: cred.user!.uid,
            photoUrl: photoUrl,
            username: username,
            bio: bio,
            followers: [],
            followings: []);

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = "Now you can login with credentials";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> signinuser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";

    try {
      if (password.isNotEmpty || email.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        res = "Success";
      } else {
        res = "Please fill all fields";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == "user-not-found") {
        res = "User not registred";
      } else if (err.code == "wrong-password") {
        res = "Wrong password";
      }
    } catch (err) {
      print(err.toString());
    }

    return res;
  }

  Future<String> signout() async {
    String res = "error";
    Timer(const Duration(seconds: 5), () async {
      await GoogleSignIn().disconnect();
      res = "Success";
    });
    Timer(const Duration(seconds: 5), () async {
      await _auth.signOut();
      res = "success";
    });
    return res;
  }

  Future<String> resetPassword(String email) async {
    String res = "Some error occured";

    try {
      await _auth.sendPasswordResetEmail(email: email);
      res = "Success";
    } on FirebaseAuthException catch (err) {
      if (err.code == "user-not-found") {
        res = "User not registred";
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
    return res;
  }

  Future<bool> signInWithGoogle() async {
    bool result = false;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credentials);

      User? user = userCredential.user;

      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          model.User googleUser = model.User(
              email: user.email!,
              uid: userCredential.user!.uid,
              photoUrl: user.photoURL!,
              username: user.displayName!.trim(),
              bio: "######",
              followers: [],
              followings: []);

          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(
                googleUser.toJson(),
              );
        }
        result = true;
      } else {
        GoogleSignIn().signIn();
        Get.to(const BottomNavScreen());
      }
    } catch (err) {
      print(err);
    }

    return result;
  }

  Future<String> updateUser({
    required String username,
    required String bio,
    required Uint8List file,
    required String uid,
  }) async {
    String res = "error";

    String photoUrl =
        await StorageMethods().uploadImageToStorage('profilePics', file, false);

    DocumentReference docRef = _firestore.doc('users/$uid');

    try {
      // Update the specific field using the update method
      await docRef.update({
        'username': username,
        'bio': bio,
        'photoUrl': photoUrl,
      });

      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
