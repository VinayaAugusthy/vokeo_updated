import 'package:flutter/material.dart';
import 'package:vokeo/views/authentication_screens/reset_password.dart';
import 'package:vokeo/views/authentication_screens/signup_screen.dart';

import '../../controller/resourses/auth_methods.dart';
import '../../controller/utils/spacing.dart';
import '../../controller/utils/utils.dart';
import '../bottom_nav/bottom_nav_screen.dart';
import '../widgets/text_field.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(200, 195, 144, 200),
      resizeToAvoidBottomInset: false,
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getVerticalSpace(50),
                Row(
                  children: [
                    getHorizontalSpace(100),
                    const Text(
                      'VOKEO',
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(size.width * 0.06),
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ResetPassword(),
                                    ),
                                  ),
                                  child: const Text(
                                    'Forgot password ? ',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          getVerticalSpace(20),
                          SizedBox(
                            height: size.width * 0.12,
                            width: size.width * 0.7,
                            child: isLoading != true
                                ? ElevatedButton.icon(
                                    onPressed: signinUser,
                                    icon: const Icon(Icons.check),
                                    label: const Text('Login'),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                          getVerticalSpace(20),
                          const Text(
                            'OR',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          getVerticalSpace(20),
                          SizedBox(
                            height: size.width * 0.12,
                            width: size.width * 0.7,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                bool result =
                                    await AuthMethods().signInWithGoogle();

                                if (result) {
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const BottomNavScreen(),
                                    ),
                                  );
                                } else {
                                  // ignore: use_build_context_synchronously
                                  showSnackbar(context,
                                      "Error Occured in google signin");
                                }
                              },
                              icon: const Image(
                                image: AssetImage('assets/google.png'),
                                height: 20,
                                width: 20,
                              ),
                              label: const Text('Signin with Google'),
                            ),
                          ),
                          getVerticalSpace(60),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account ? "),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
                                ),
                                child: const Text(
                                  "Signup",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
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
    );
  }

  signinUser() async {
    setState(() {
      isLoading = true;
    });

    String res = await AuthMethods().signinuser(
        email: emailController.text, password: passwordController.text);

    if (res == "Success") {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const BottomNavScreen(),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      showSnackbar(context, res);
    }
    setState(() {
      isLoading = false;
    });
  }
}
