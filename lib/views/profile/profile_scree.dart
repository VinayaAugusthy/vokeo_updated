// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vokeo/views/profile/post_view.dart';
import 'package:vokeo/views/profile/settings/widgets/settings.dart';
import '../../controller/resourses/auth_methods.dart';
import '../../controller/resourses/firestore_methods.dart';
import '../../controller/utils/utils.dart';
import '../authentication_screens/signin_screen.dart';
import '../bottom_nav/bottom_nav_screen.dart';
import '../edit_profile/edit_profile.dart';
import '../widgets/follow_button.dart';
import 'followers.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late var userDetails;
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int followings = 0;
  bool isFollowing = false;
  bool isLoading = false;

  List<dynamic> followersTopass = [];

  List<dynamic> followingsToPass = [];

  bool isQuit = false;

  late DocumentSnapshot<Map<String, dynamic>> userSnapshot;
  @override
  void initState() {
    super.initState();
    getData();
    getFollowers();
    getFollowings();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text(
                userData['username'],
                style: const TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BottomNavScreen(),
                  ),
                ),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              actions: [
                settingsButton(),
                logoutButton(),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(size.width * 0.005),
              child: ListView(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              userData['photoUrl'],
                            ),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColum(postLen, "Posts"),
                                    InkWell(
                                        onTap: () => Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FollowScreen(
                                                  followersList:
                                                      followersTopass,
                                                  uid: widget.uid,
                                                ),
                                              ),
                                            ),
                                        child: buildStatColum(
                                            followers, "Follwers")),
                                    InkWell(
                                      onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => FollowScreen(
                                              followersList: followingsToPass,
                                              isFollowers: false,
                                              uid: widget.uid),
                                        ),
                                      ),
                                      child: buildStatColum(
                                          followings, "Followings"),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: size.width * 0.00),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FirebaseAuth.instance.currentUser!.uid ==
                                              widget.uid
                                          ? FollowButton(
                                              text: "Edit profile",
                                              backgroundColor: Colors.black,
                                              borderColor: Colors.white,
                                              textColor: Colors.white,
                                              function: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditProfileScreen(
                                                            snap: userDetails),
                                                  ),
                                                );
                                              },
                                            )
                                          : isFollowing
                                              ? FollowButton(
                                                  text: "Unfollow",
                                                  backgroundColor: Colors.white,
                                                  borderColor: Colors.white,
                                                  textColor: Colors.black,
                                                  function: () async {
                                                    await FirestoreMethods()
                                                        .followUsers(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid'],
                                                    );
                                                    setState(() {
                                                      isFollowing = false;
                                                      followers--;
                                                    });
                                                  },
                                                )
                                              : FollowButton(
                                                  text: "Follow",
                                                  backgroundColor: Colors.blue,
                                                  borderColor: Colors.white,
                                                  textColor: Colors.white,
                                                  function: () async {
                                                    await FirestoreMethods()
                                                        .followUsers(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid'],
                                                    );
                                                    setState(() {
                                                      isFollowing = true;
                                                      followers++;
                                                    });
                                                  },
                                                )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          userData['bio'],
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Divider(),
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            );
                          }

                          return GridView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 1.5,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                DocumentSnapshot snap =
                                    (snapshot.data! as dynamic).docs[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PostView(snap: snap),
                                      ),
                                    );
                                  },
                                  child: Image(
                                    image: NetworkImage(snap['postUrl']),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
  }

  Column buildStatColum(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      followers = userSnap.data()!['followers'].length;
      followings = userSnap.data()!['followings'].length;
      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {
        userDetails = userSnap;
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackbar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  logoutButton() {
    return IconButton(
      onPressed: () async {
        _showLogoutDialog(context);
      },
      icon: const Icon(
        Icons.logout,
        color: Colors.white,
      ),
    );
  }

  settingsButton() {
    return IconButton(
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingScreens(),
          ),
        );
      },
      icon: const Icon(
        Icons.settings,
        color: Colors.white,
      ),
    );
  }

  Future<void> getFollowers() async {
    try {
      userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget
              .uid) // Replace 'uid' with the actual user ID you want to fetch
          .get();

      // Check if the document exists
      if (userSnapshot.exists) {
        // Check if the 'username' field exists in the document
        if (userSnapshot.data()!.containsKey('username')) {
          List<dynamic> followers = userSnapshot['followers'];

          followersTopass = followers;
        } else {
          print("'username' field doesn't exist in the document.");
        }

        print('Full snapshot: $userSnapshot');
      } else {
        print('Document with the specified UID does not exist.');
      }
    } catch (error) {
      print('Error fetching followers: $error');
    }
  }

  Future<void> getFollowings() async {
    try {
      userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // Check if the document exists
      if (userSnapshot.exists) {
        // Check if the 'username' field exists in the document
        if (userSnapshot.data()!.containsKey('username')) {
          List<dynamic> followers = userSnapshot['followings'];

          followingsToPass = followers;
        } else {
          print("'username' field doesn't exist in the document.");
        }

        print('Full snapshot: $userSnapshot');
      } else {
        print('Document with the specified UID does not exist.');
      }
    } catch (error) {
      print('Error fetching followers: $error');
    }
  }

  _showLogoutDialog(BuildContext context) {
    Widget yesButton = TextButton(
      child: const Text(
        "Yes",
      ),
      onPressed: () async {
        const Center(
          child: CircularProgressIndicator(backgroundColor: Colors.white),
        );
        Timer(const Duration(seconds: 5), () async {
          try {
            // Sign out the user
            AuthMethods().signout();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const SigninScreen(),
              ),
            );
          } catch (error) {
            print("Error during sign-out: $error");
          }
        });
      },
    );

    Widget noButton = TextButton(
      child: const Text(
        "No",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop(); // Close the dialog
      },
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: const Text("Logout", style: TextStyle(color: Colors.black)),
      content: const Text(
        "Are you sure you want to logout?",
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        yesButton,
        noButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
