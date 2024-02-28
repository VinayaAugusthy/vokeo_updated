// ignore_for_file: use_build_context_synchronously, duplicate_ignore, avoid_print

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../controller/resourses/auth_methods.dart';
import '../../controller/utils/spacing.dart';
import '../../controller/utils/utils.dart';
import '../bottom_nav/bottom_nav_screen.dart';
import '../widgets/text_field.dart';

class EditProfileScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const EditProfileScreen({super.key, required this.snap});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController bioController = TextEditingController();

  TextEditingController usernameController = TextEditingController();

  bool isLoading = false;

  Uint8List? _image;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    usernameController.text = widget.snap['username'];
    bioController.text = widget.snap['bio'];
    print(widget.snap['uid']);
  }

  @override
  void dispose() {
    super.dispose();

    bioController.dispose();
    usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: ListView(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              // getVerticalSpace(10),
              Row(
                children: [getVerticalSpace(150)],
              ),
              Stack(
                children: [
                  (_image != null
                      ? CircleAvatar(
                          radius: 55,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : CircleAvatar(
                          radius: 55,
                          backgroundImage:
                              NetworkImage(widget.snap['photoUrl']),
                        )),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: IconButton(
                      onPressed: () {
                        selectImage();
                      },
                      icon: const Icon(Icons.camera_alt_sharp),
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 50, 20, 60),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        textFormField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            hintText: "Username",
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        getVerticalSpace(20),
                        textFormField(
                          controller: bioController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.add_reaction_outlined,
                              color: Colors.white,
                            ),
                            hintText: "Bio",
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        getVerticalSpace(20),
                        getVerticalSpace(20),
                        SizedBox(
                          height: 40,
                          width: 300,
                          child: ElevatedButton.icon(
                            onPressed: updateProfile,
                            icon: const Icon(Icons.update),
                            label: const Text('Update Profile'),
                          ),
                        ),
                        getVerticalSpace(150),
                        isLoading
                            ? const LinearProgressIndicator()
                            : Container()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);

    setState(() {
      _image = img;
    });
  }

  updateProfile() async {
    setState(() {
      isLoading = true;
    });
    if (_image == null) {
      showSnackbar(context, "Please select a profile picture.");
      return;
    }
    String res = await AuthMethods().updateUser(
      uid: widget.snap['uid'],
      username: usernameController.text,
      bio: bioController.text,
      file: _image!,
    );

    if (res == 'Success') {
      // ignore: use_build_context_synchronously
      showSnackbar(context, "Profile Updated");

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const BottomNavScreen(),
          ),
          (route) => false);
    }

    setState(() {
      isLoading = false;
    });
  }
}
