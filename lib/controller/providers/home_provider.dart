// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vokeo/controller/providers/user_provider.dart';

class HomeScreenProvider extends ChangeNotifier {
  String username = "";

  Future<void> getUsername() async {
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snap.exists) {
        username = (snap.data() as Map<String, dynamic>)['username'];
        notifyListeners(); // Notify listeners of the change
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> listenToChange(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
    notifyListeners(); // Notify listeners of the change
  }
}
