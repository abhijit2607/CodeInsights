import 'comment.dart';


class Post {
  String title;
  String content;
  String userId;
  String username;
  List<Comment> comments;

  Post({
    required this.title,
    required this.content,
    required this.userId,
    required this.username,
    List<Comment>? comments,
  }) : comments = comments ?? [];

  void addComment(Comment comment) {
    comments.add(comment);
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}

