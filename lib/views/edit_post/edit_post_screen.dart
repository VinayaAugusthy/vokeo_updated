// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../controller/providers/user_provider.dart';
import '../../controller/resourses/firestore_methods.dart';
import '../../controller/utils/spacing.dart';
import '../../controller/utils/utils.dart';
import '../bottom_nav/bottom_nav_screen.dart';

class EditPostScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const EditPostScreen({super.key, required this.snap});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.snap['description'];
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

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
        actions: [
          TextButton(
            onPressed: () => {
              updateCaption(
                  widget.snap['postId'].toString(), _descriptionController.text)
            },
            child: const Text(
              'Update Caption',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          _isLoading ? const LinearProgressIndicator() : Container(),
          getVerticalSpace(100),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user!.photoUrl),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  controller: _descriptionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Write a caption",
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487 / 451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.snap['postUrl']),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          getVerticalSpace(20),
          const Divider()
        ],
      ),
    );
  }

  updateCaption(String postId, String text) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods()
          .updateData(_descriptionController.text, postId);
      if (res == "Success") {
        setState(() {
          _isLoading = false;
        });

        showSnackbar(context, "Caption Updated!!");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const BottomNavScreen()),
            (route) => false);
      } else {
        setState(() {
          _isLoading = false;
        });

        showSnackbar(context, res);
      }
    } catch (err) {
      showSnackbar(
        context,
        err.toString(),
      );
    }
  }
}
