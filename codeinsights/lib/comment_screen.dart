import 'package:flutter/material.dart';

import 'auth.dart';
import 'auth_dialog.dart';
import 'comment.dart';
import 'post.dart';

class CommentScreen extends StatefulWidget {
  final Post post;

  CommentScreen({required this.post});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController _commentController = TextEditingController();
  final AuthService _auth = AuthService();
  Set<String> collapsedComments = Set<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Post Title: ${widget.post.title}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Post Content: ${widget.post.content}'),
            SizedBox(height: 16),
            Text(
              'Comments:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.post.comments.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildCommentItem(widget.post.comments[index]);
                },
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(labelText: 'Add a comment...'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_auth.currentUser != null) {
                  if (_commentController.text.isNotEmpty) {
                    Comment newComment = Comment(
                      text: _commentController.text,
                      userId: _auth.currentUser!.uid,
                      username: _auth.currentUser!.username ?? '',
                    );
                    setState(() {
                      widget.post.addComment(newComment);
                      _commentController.clear();
                    });
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AuthDialog();
                    },
                  );
                }
              },
              child: Text('Add Comment'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCommentItem(Comment comment) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comment.text,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder<String?>(
                future: _auth.getUsername(comment.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    String username = snapshot.data ?? '';
                    return Text(
                      'Replying as $username',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _handleReply(comment);
                },
                child: Text('Reply'),
              ),
            ],
          ),
          SizedBox(height: 8),
          if (!collapsedComments.contains(comment.commentId) &&
              comment.replies.isNotEmpty)
            Container(
              margin: EdgeInsets.only(left: 16),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: comment.replies.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildCommentItem(comment.replies[index]);
                },
              ),
            ),
          if (comment.replies.isNotEmpty)
            TextButton(
              onPressed: () {
                toggleCollapse(comment.commentId);
              },
              child: Text(
                collapsedComments.contains(comment.commentId)
                    ? 'Show ${comment.replies.length} replies'
                    : 'Hide replies',
                style: TextStyle(color: Colors.blue),
              ),
            ),
        ],
      ),
    );
  }

  void _handleReply(Comment parentComment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reply to Comment'),
          content: TextField(
            controller: _commentController,
            decoration: InputDecoration(labelText: 'Enter your reply...'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (_auth.currentUser != null) {
                  if (_commentController.text.isNotEmpty) {
                    Comment reply = Comment(
                      text: _commentController.text,
                      userId: _auth.currentUser!.uid,
                      username: _auth.currentUser!.username ?? '',
                    );

                    parentComment.addReply(reply);
                    _commentController.clear();

                    setState(() {});

                    Navigator.pop(context);
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AuthDialog();
                    },
                  );
                }
              },
              child: Text('Reply'),
            ),
          ],
        );
      },
    );
  }

  void toggleCollapse(String commentId) {
    setState(() {
      if (collapsedComments.contains(commentId)) {
        collapsedComments.remove(commentId);
      } else {
        collapsedComments.add(commentId);
      }
    });
  }
}
