import 'package:flutter/material.dart';
import 'package:vokeo/controller/utils/spacing.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(
          size.width * 0.1,
        ),
        child: SizedBox(
          height: size.height,
          width: size.width * 0.85,
          child: Card(
            color: Colors.grey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getVerticalSpace(10),
                    const Center(
                      child: Text(
                        'TERMS & CONDITIONS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    getVerticalSpace(20),
                    const Text(
                      '1. Acceptance of Terms',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    getVerticalSpace(10),
                    const Text(
                      'By accessing or using VOKEO, you agree to comply with and be bound by these Terms and Conditions. If you do not agree to these terms, please do not use the application.',
                    ),
                    getVerticalSpace(20),
                    const Text(
                      '2. Account Registration',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    getVerticalSpace(10),
                    const Text(
                      'a. You are responsible for maintaining the security of your account credentials and ensuring the accuracy of the information you provide during registration.',
                    ),
                    getVerticalSpace(10),
                    const Text(
                      'b. You agree to promptly update your account information to ensure its accuracy.',
                    ),
                    getVerticalSpace(10),
                    const Text(
                      'c. You are solely responsible for any activities that occur under your account.',
                    ),
                    getVerticalSpace(20),
                    const Text(
                      '3. Privacy',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    getVerticalSpace(10),
                    const Text(
                      'Your use of VOKEO is subject to our Privacy Policy, which can be found [link to Privacy Policy]. Please review the Privacy Policy to understand how we collect, use, and disclose your personal information.',
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
