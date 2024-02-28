// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profileImage;
  final likes;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profileImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "postId": postId,
        "username": username,
        "postUrl": postUrl,
        "profileImage": profileImage,
        "likes": likes,
        "datePublished": datePublished,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        username: snapshot['username'],
        description: snapshot['description'],
        uid: snapshot['uid'],
        postId: snapshot['postId'],
        postUrl: snapshot['postUrl'],
        profileImage: snapshot['profileImage'],
        likes: snapshot['likes'],
        datePublished: snapshot['datePublished']);
  }
}
