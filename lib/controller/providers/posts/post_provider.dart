import 'package:flutter/foundation.dart';

class PostCardProvider with ChangeNotifier {
  String username = "";
  bool isLikeAnimating = false;
  int commentCount = 0;

  void updateUsername(String newUsername) {
    username = newUsername;
    notifyListeners();
  }

  void updateIsLikeAnimating(bool newValue) {
    isLikeAnimating = newValue;
    notifyListeners();
  }

  void updateCommentCount(int newCount) {
    commentCount = newCount;
    notifyListeners();
  }
}
