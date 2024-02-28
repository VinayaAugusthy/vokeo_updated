import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vokeo/views/home/widgets/authenticated_userhome.dart';
import 'package:vokeo/views/home/widgets/unauthenticated_userhome.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the user is signed in
    if (FirebaseAuth.instance.currentUser != null) {
      return const AuthenticatedUserHome();
    } else {
      // Handle the case when the user is not signed in
      return const SignInToContinue();
    }
  }
}
