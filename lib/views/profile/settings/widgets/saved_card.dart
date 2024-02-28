// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:vokeo/views/profile/profile_scree.dart';
import 'package:vokeo/controller/utils/spacing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedPostCard extends StatefulWidget {
  final snap;
  const SavedPostCard({super.key, required this.snap});

  @override
  State<SavedPostCard> createState() => _SavedPostCardState();
}

class _SavedPostCardState extends State<SavedPostCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () =>
                    Get.to(ProfileScreen(uid: widget.snap['postOwner'])),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.snap['profileImage']),
                ),
              ),
              getHorizontalSpace(10),
              Text(
                widget.snap['username'],
                style: const TextStyle(color: Colors.white),
              ),
              getHorizontalSpace(MediaQuery.of(context).size.width * .55),
            ],
          ),
        ),
        getVerticalSpace(10),
        Row(
          children: [
            Text(
              widget.snap['description'],
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        getVerticalSpace(10),
        Image(
          image: NetworkImage(widget.snap['postUrl']),
        ),
        getVerticalSpace(10),
        IconButton(
          onPressed: () => FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('savedPost')
              .doc(widget.snap['postId'])
              .delete(),
          icon: const Icon(
            Icons.delete_forever_outlined,
            color: Colors.white,
          ),
        ),
        const Divider()
      ],
    );
  }
}
