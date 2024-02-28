import 'package:flutter/material.dart';
import '../../authentication_screens/signin_screen.dart';

class SignInToContinue extends StatelessWidget {
  const SignInToContinue({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VOKEO'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You are not signed in.',
              style: TextStyle(fontSize: 18),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SigninScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
