// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vokeo/models/user.dart' as model;
import '../../../controller/providers/user_provider.dart';
import '../../../controller/resourses/firestore_methods.dart';
import '../../../controller/utils/utils.dart';
import '../../comment/comment_screen.dart';
import '../../edit_post/edit_post_screen.dart';
import '../../profile/profile_scree.dart';
import '../../search/view_post.dart';
import '../../widgets/like_animation.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final TextEditingController _textFieldController = TextEditingController();

  bool isLikeAnimating = false;
  int commentCount = 0;

  late String data;

  String username = "";

  late DocumentSnapshot postSnap;

  late DocumentReference profileDetails;

  //late DocumentSnapshot currentUserSnapshot;

  @override
  void dispose() {
    super.dispose();
    _textFieldController.dispose();
  }

  @override
  void initState() {
    super.initState();
    // getCurrentUser();
    getPostDetails();
    getProfileDetails();
    getComments();
  }

  void getPostDetails() async {
    try {
      postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .get();
    } catch (er) {
      showSnackbar(
        context,
        er.toString(),
      );
    }
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .get();

      setState(() {
        commentCount = snap.docs.length;
      });
    } catch (er) {
      showSnackbar(
        context,
        er.toString(),
      );
    }
    //setState(() {});
  }

  void getProfileDetails() async {
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.snap['uid'])
          .get();

      setState(() {
        username = (snap.data() as Map<String, dynamic>)['username'];
      });

      //print(username);
    } catch (e) {
      showSnackbar(
        context,
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profileImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(uid: widget.snap['uid']),
                            ),
                          ),
                          child: Text(
                            username,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                //====================Edit deletepost===========================================
                widget.snap['uid'] == FirebaseAuth.instance.currentUser!.uid
                    ? PopupMenuButton(
                        color: Colors.black,
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        onSelected: (value) {
                          if (value == 0) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditPostScreen(snap: widget.snap),
                              ),
                            );
                          }
                          if (value == 1) {
                            deletePost(
                              widget.snap['postId'].toString(),
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem(
                              value: 0, //---add this line
                              child: Text('Edit',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            const PopupMenuItem(
                              value: 1,
                              child: Text('Delete',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ];
                        })
                    : PopupMenuButton(
                        color: Colors.black,
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        onSelected: (value) {
                          if (value == 0) {
                            savePost(snap: widget.snap);
                          }
                        },
                        itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 0,
                                child: Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ])
                //====================Edit deletepost===========================================
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                user!.uid,
                widget.snap['postId'],
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ViewPost(postUrl: widget.snap['postUrl']),
                    ),
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: Image(
                      image: NetworkImage(widget.snap['postUrl']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    duration: const Duration(milliseconds: 400),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 100,
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user!.uid),
                smallLike: true,
                child: IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likePost(
                        user.uid,
                        widget.snap['postId'],
                        widget.snap['likes'],
                      );

                      if (widget.snap['uid'] !=
                              FirebaseAuth.instance.currentUser!.uid &&
                          widget.snap['likes'].contains(user.uid)) {
                        await FirestoreMethods().showNotifications(
                            postUrl: widget.snap['postUrl'],
                            postId: widget.snap['postId'],
                            text: "liked",
                            owner: postSnap['uid'],
                            name: user.username,
                            profilePic: user.photoUrl,
                            uid: FirebaseAuth.instance.currentUser!.uid);
                      }
                    },
                    icon: widget.snap['likes'].contains(user.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          )),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentScreen(
                        snap: widget.snap, documentSnap: postSnap),
                  ),
                ),
                icon: const Icon(
                  Icons.comment_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.snap['likes'].length}  Likes",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: widget.snap['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "  ${widget.snap['description']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CommentScreen(
                            snap: widget.snap, documentSnap: postSnap),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "View all $commentCount comments",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(
                      widget.snap['datePublished'].toDate(),
                    ),
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deletePost(String postId) async {
    String res = await FirestoreMethods().deletePost(postId);
    if (res == "Deleted") {
      showSnackbar(context, "Post Deleted");
    }
  }

  Future<void> savePost({required snap}) async {
    String res = "error";

    try {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('savedPost')
          .doc(widget.snap['postId']);

      DocumentSnapshot docSnap = await docRef.get();

      if (docSnap.exists) {
        res = "saved";
      } else {
        res = await FirestoreMethods().savePostForFuture(snap);
      }
    } catch (e) {
      showSnackbar(
        context,
        e.toString(),
      );
    }

    if (res == 'success') {
      showSnackbar(
        context,
        "Post saved",
      );
    } else if (res == "saved") {
      showSnackbar(context, "This post already saved");
    } else {
      showSnackbar(context, res);
    }
  }
}
