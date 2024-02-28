// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/utils/spacing.dart';
import '../../profile/profile_scree.dart';
import '../../search/view_post.dart';

class NotificationCard extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const NotificationCard({super.key, required this.snap});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  late DocumentSnapshot userSnap;

  @override
  Widget build(BuildContext context) {
    // model.User user = Provider.of<UserProvider>(context).getUser;

    return widget.snap['owner'] == FirebaseAuth.instance.currentUser!.uid
        ? Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(
                        ProfileScreen(uid: widget.snap['commentedBy']),
                      ),
                      child: CircleAvatar(
                        radius: 23, // Adjust the radius as needed
                        backgroundImage:
                            NetworkImage(widget.snap['profilePic']),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => Get.to(
                                ProfileScreen(uid: widget.snap['commentedBy']),
                              ),
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: widget.snap['name'],
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  widget.snap['text'] == "commented"
                                      ? const TextSpan(
                                          text: " Commented on your post",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        )
                                      : widget.snap['text'] == "followed"
                                          ? const TextSpan(
                                              text: " started following you ",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            )
                                          : const TextSpan(
                                              text: " Liked your post",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            )
                                ]),
                              ),
                            ),
                            getVerticalSpace(5),
                            Text(
                              DateFormat.MMMd('en_US').add_jm().format(
                                    widget.snap['datePublished'].toDate(),
                                  ),
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    ),
                    widget.snap['text'] == "commented" ||
                            widget.snap['text'] == "liked"
                        ? GestureDetector(
                            onTap: () => Get.to(
                              ViewPost(postUrl: widget.snap['postUrl']),
                            ),
                            child: ClipRRect(
                              child: Image.network(
                                widget.snap['postUrl'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : const Text(""),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.white24,
              )
            ],
          )
        : Container();
  }

  Future<void> getCurrentUser() async {
    try {
      userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      // Check if the document exists
    } catch (error) {
      print('Error fetching followers: $error');
    }
  }
}
