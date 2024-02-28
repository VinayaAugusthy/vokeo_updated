import 'package:flutter/material.dart';

Widget textFormField(
    {style = const TextStyle(color: Colors.white),
    cursorColor = Colors.white,
    controller,
    keyboardType,
    decoration,
    isObscure = false}) {
  return TextFormField(
    style: style,
    cursorColor: Colors.white,
    controller: controller,
    keyboardType: TextInputType.emailAddress,
    decoration: decoration,
    obscureText: isObscure,
  );
}
