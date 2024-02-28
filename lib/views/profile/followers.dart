import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vokeo/views/profile/profile_scree.dart';

class FollowScreen extends StatelessWidget {
  final bool isFollowers;
  final String uid;
  final List<dynamic> followersList;

  const FollowScreen({
    Key? key,
    required this.uid,
    this.isFollowers = true,
    required this.followersList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          isFollowers ? "Followers" : "Followings",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: isFollowers
          ? ShowFollowersOrFollowings(followersList: followersList)
          : ShowFollowersOrFollowings(
              followersList: followersList, isFollowers: false),
    );
  }
}

class ShowFollowersOrFollowings extends StatelessWidget {
  const ShowFollowersOrFollowings(
      {Key? key, required this.followersList, this.isFollowers = true})
      : super(key: key);

  final List<dynamic> followersList;
  // ignore: prefer_typing_uninitialized_variables
  final isFollowers;

  @override
  Widget build(BuildContext context) {
    if (followersList.isEmpty) {
      return Center(
        child: isFollowers
            ? const Text(
                "Nobody follows you !!",
                style: TextStyle(color: Colors.white),
              )
            : const Text(
                "You are not following anybody !!",
                style: TextStyle(color: Colors.white),
              ),
      );
    }

    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('users')
          .where('uid', whereIn: followersList)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("Nothing to show"),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        var userDataList = snapshot.data!.docs;
        return ListView.builder(
          itemCount: userDataList.length,
          itemBuilder: (context, index) {
            var userData = userDataList[index].data();

            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(uid: userData['uid']),
                  ),
                );
              },
              child: ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(userData['photoUrl']),
                ),
                title: Text(
                  "${userData['username']}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
