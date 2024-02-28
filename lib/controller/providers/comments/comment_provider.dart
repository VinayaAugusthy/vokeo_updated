import 'package:flutter/foundation.dart';

class CommentProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _comments = [];

  List<Map<String, dynamic>> get comments => _comments;

  void addComment(Map<String, dynamic> comment) {
    _comments.add(comment);
    notifyListeners();
  }
}
