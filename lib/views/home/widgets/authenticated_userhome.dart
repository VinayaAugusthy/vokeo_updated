import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vokeo/views/home/widgets/post_card.dart';
import 'package:vokeo/views/home/widgets/shimmer.dart';

import '../../../controller/providers/home_provider.dart';
import '../../chat/chat_home.dart';

class AuthenticatedUserHome extends StatelessWidget {
  const AuthenticatedUserHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'VOKEO',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 167, 128, 128),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatHomeScreen(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.message_outlined,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Consumer<HomeScreenProvider>(
        builder: (context, homeScreenProvider, child) {
          if (homeScreenProvider.username.isEmpty) {
            homeScreenProvider.getUsername();
            homeScreenProvider.listenToChange(context);
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  homeScreenProvider.username.isEmpty) {
                return const LoadingShimmer();
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("No posts available."),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => PostCard(
                  snap: snapshot.data!.docs[index].data(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
