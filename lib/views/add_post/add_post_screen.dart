// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../controller/providers/user_provider.dart';
import '../../controller/resourses/firestore_methods.dart';
import '../../controller/utils/spacing.dart';
import '../../controller/utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  Uint8List? _file;
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: TextButton(
              onPressed: () => _selectImage(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.upload),
                  getHorizontalSpace(10),
                  const Text(
                    'ADD POST',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: clearImage,
              ),
              actions: [
                TextButton(
                  onPressed: () => postImage(
                    user!.uid,
                    user.username,
                    user.photoUrl,
                  ),
                  child: const Text(
                    'Post',
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user!.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
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
                  ],
                ),
                getVerticalSpace(20),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  child: AspectRatio(
                    aspectRatio: 487 / 451,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: MemoryImage(_file!),
                          fit: BoxFit.fill,
                          alignment: FractionalOffset.topCenter,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            title: const Text("Select An Image"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take A Photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Choose from gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  postImage(
    String uid,
    String username,
    String profileImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profileImage,
      );
      if (res == "Success") {
        setState(() {
          _isLoading = false;
        });
        clearImage();
        showSnackbar(context, "Posted !!");
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

  void clearImage() {
    setState(() {
      _file = null;
    });
  }
}
