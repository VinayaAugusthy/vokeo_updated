// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:vokeo/controller/resourses/storage_methods.dart';

import '../../models/message.dart';
import '../../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profileImage,
  ) async {
    String res = "Some error occured";

    try {
      String photoUrl = await StorageMethods().uploadImageToStorage(
        "posts",
        file,
        true,
      );

      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profileImage: profileImage,
          likes: []);

      _firebaseFirestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUsers(
    String uid,
    String followId,
  ) async {
    try {
      DocumentSnapshot snap =
          await _firebaseFirestore.collection('users').doc(uid).get();
      List followings = (snap.data()! as dynamic)['followings'];

      if (followings.contains(followId)) {
        await _firebaseFirestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firebaseFirestore.collection('users').doc(uid).update({
          'followings': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firebaseFirestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firebaseFirestore.collection('users').doc(uid).update({
          'followings': FieldValue.arrayUnion([followId])
        });
      }
    } catch (err) {
      print(
        err.toString(),
      );
    }
  }

  Future<void> likePost(String uid, String postId, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> postComments(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();

        await _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'postId': postId,
          'text': text,
          'commentId': commentId,
          'name': name,
          'uid': uid,
          'datePublished': DateTime.now()
        });
      } else {
        print('Empty comment');
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<String> deletePost(String postId) async {
    String res = "Error";

    print(postId);

    try {
      await _firebaseFirestore.collection('posts').doc(postId).delete();
      res = "Deleted";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updateData(String newValue, String postId) async {
    String res = "error";
    DocumentReference docRef = _firebaseFirestore.doc('posts/$postId');

    try {
      // Update the specific field using the update method
      await docRef.update({'description': newValue});

      res = "Success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> savePostForFuture(snap) async {
    String res = "error";
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('savedPost')
          .doc(snap['postId'])
          .set({
        'postId': snap['postId'],
        'postUrl': snap['postUrl'],
        'profileImage': snap['profileImage'],
        'username': snap['username'],
        'description': snap['description'],
        'postOwner': snap['uid'],
        'dateSaved': DateTime.now(),
      });
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> showNotifications({
    required String postId,
    required String text,
    required String uid,
    required String name,
    required String profilePic,
    required String owner,
    required String postUrl,
  }) async {
    print(uid);
    print(owner);
    print('reached here');
    try {
      var id = [owner, postId];
      if (text.isNotEmpty) {
        if (text == "commented") {
          id.sort();
          id.add('comment');
        } else if (text == "liked") {
          id.sort();
          id.add('liked');
        } else {
          id.sort();
          id.add('followed');
        }

        String notificationId = id.join("_");

        await _firebaseFirestore
            .collection('users')
            .doc(owner)
            .collection('notifications')
            .doc(notificationId)
            .set({
          'profilePic': profilePic,
          'postId': postId,
          'text': text,
          'notoficationId': notificationId,
          'name': name,
          'commentedBy': uid,
          'datePublished': DateTime.now(),
          'owner': owner,
          'postUrl': postUrl
        });
      } else {
        print('Empty comment');
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> sendMessage(
      {required receiverId, required message, required senderId}) async {
    final Timestamp timeStamp = Timestamp.now();

    print(senderId);
    print(receiverId);

    Message newMessage = Message(
        senderId: senderId,
        receiverId: receiverId,
        timeStamp: timeStamp,
        message: message);

    List<String> ids = [senderId, receiverId];

    ids.sort();

    String chatRoomId = ids.join("_");

    await _firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection('messages')
        .add(
          newMessage.toMap(),
        );
  }

  Stream<QuerySnapshot> getMessages(String sender, String receiver) {
    List<String> ids = [sender, receiver];

    ids.sort();

    String chatRoomId = ids.join("_");
    return _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timeStamp', descending: false)
        .snapshots();
  }

  saveNotifications({required postId, required String text, required String uid, required String name, required String profilePic, required owner, required postUrl}) {}
}
