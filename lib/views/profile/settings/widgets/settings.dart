import 'package:flutter/material.dart';
import 'package:vokeo/views/profile/settings/terms.dart';
import 'package:vokeo/views/profile/settings/widgets/saved_posts.dart';
import 'package:vokeo/controller/utils/spacing.dart';

class SettingScreens extends StatelessWidget {
  const SettingScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Color.fromARGB(255, 167, 128, 128),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.sizeOf(context).width * 0.08,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getVerticalSpace(60),
              GestureDetector(
                child: const Text(
                  'Saved Posts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SavedPosts(),
                    ),
                  );
                },
              ),
              getVerticalSpace(30),
              GestureDetector(
                child: const Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TermsAndConditions(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
