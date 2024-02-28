// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart' as model;
import '../../controller/providers/user_provider.dart';
import '../../controller/resourses/firestore_methods.dart';
import '../widgets/comment_card.dart';
import '../widgets/text_field.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen(
      {super.key,
      required this.snap,
      required DocumentSnapshot<Object?> documentSnap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Comments",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) => CommentCard(
              snap: (snapshot.data! as dynamic).docs[index].data(),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(
            left: 16,
            right: 8,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user!.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                    left: 16,
                  ),
                  child: textFormField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.white),
                      hintText: "Comment as ${user.username}",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().postComments(
                    widget.snap['postId'],
                    _commentController.text,
                    user.uid,
                    user.username,
                    user.photoUrl,
                  );
                  if (widget.snap['uid'] !=
                      FirebaseAuth.instance.currentUser!.uid) {
                    await FirestoreMethods().showNotifications(
                        postId: widget.snap['postId'],
                        text: "commented",
                        uid: FirebaseAuth.instance.currentUser!.uid,
                        name: user.username,
                        profilePic: user.photoUrl,
                        owner: widget.snap['uid'],
                        postUrl: widget.snap['postUrl']);
                  }
                  setState(() {
                    _commentController.text = '';
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    "Post",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
