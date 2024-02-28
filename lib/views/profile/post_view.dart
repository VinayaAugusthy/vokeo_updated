// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import '../../controller/utils/spacing.dart';

class PostView extends StatelessWidget {
  final snap;
  const PostView({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          snap['description'],
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              getVerticalSpace(MediaQuery.of(context).size.height * .01),
              Image(
                //  fit: BoxFit.contain,
                image: NetworkImage(snap['postUrl']),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
