import 'dart:math';


class Comment {
  late String commentId;

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
    commentId = _generateCommentId();
  }

  void addReply(Comment reply) {
    replies.add(reply);
  }

  String _generateCommentId() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return String.fromCharCodes(List.generate(
        8, (index) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}
