// /lib/post.dart
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
