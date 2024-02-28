import 'package:flutter/material.dart';
import 'package:vokeo/models/user.dart';

import '../resourses/auth_methods.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  final AuthMethods _authMethods = AuthMethods();

  User? get getUser => _user;
  bool get isUserAuthenticated => _user != null;
  refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
