// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vokeo/views/authentication_screens/signin_screen.dart';

import '../../controller/resourses/auth_methods.dart';
import '../../controller/utils/spacing.dart';
import '../../controller/utils/utils.dart';
import '../widgets/text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController bioController = TextEditingController();

  TextEditingController usernameController = TextEditingController();

  bool isLoading = false;

  Uint8List? _image;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    bioController.dispose();
    usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: ListView(children: [
        Container(
          color: const Color.fromARGB(200, 195, 144, 200),
          child: Column(
            children: [
              getVerticalSpace(100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getHorizontalSpace(size.width * 0.08),
                  const Text(
                    'VOKEO',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Stack(
                children: [
                  (_image != null
                      ? CircleAvatar(
                          radius: 55,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 55,
                          backgroundImage: AssetImage('assets/nodp.png'),
                        )),
                  Positioned(
                    right: 0,
                    bottom: 0.5,
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
                  padding: EdgeInsets.fromLTRB(
                    size.width * 0.08,
                    size.width * 0.1,
                    size.width * 0.08,
                    size.width * 0.08,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        textFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.email_rounded,
                              color: Colors.white,
                            ),
                            hintText: "Email",
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        getVerticalSpace(20),
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
                        textFormField(
                            controller: passwordController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.password,
                                color: Colors.white,
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            isObscure: true),
                        getVerticalSpace(20),
                        SizedBox(
                          height: 40,
                          width: 300,
                          child: isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : ElevatedButton.icon(
                                  onPressed: signupUser,
                                  icon: const Icon(Icons.check),
                                  label: const Text('Signup'),
                                ),
                        ),
                        getVerticalSpace(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account ? "),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SigninScreen(),
                                ),
                              ),
                              child: const Text(
                                "Signin",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            )
                          ],
                        )
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

  signupUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signupUser(
        email: emailController.text,
        password: passwordController.text,
        username: usernameController.text,
        bio: bioController.text,
        file: _image!);

    if (res != 'Success') {
      // ignore: use_build_context_synchronously
      showSnackbar(context, res);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const SigninScreen(),
          ),
          (route) => false);
    }

    setState(() {
      isLoading = false;
    });
  }
}
