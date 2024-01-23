// /lib/comment.dart

import 'dart:math';

class Comment {
  late String commentId; // Initialize the field

  final String text;
  final String userId;
  final String username;
  List<Comment> replies;

  Comment({
    required this.text,
    required this.userId,
    required this.username,
    List<Comment>? replies,
  }) : replies = replies ?? [] {
    commentId = _generateCommentId(); // Generate a unique comment ID
  }

  // Method to add a new reply to the comment
  void addReply(Comment reply) {
    replies.add(reply);
  }

  String _generateCommentId() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return String.fromCharCodes(List.generate(8, (index) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}
