import 'package:flutter/material.dart';

import 'post.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;

  const PostDetailPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement the UI for the post detail page, including comments.
    // You can use a similar structure as PostHistoryPage to display comments.
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detail'),
      ),
      body: Column(
        children: [
          // Display post details (title, content, etc.)
          ListTile(
            title: Text(post.title),
            subtitle: Text(post.content),
          ),
          // Display comments (you'll need to fetch comments from Firebase)
          // You can use a StreamBuilder or FutureBuilder to get comments.
          // Add a comment input field and a button to submit comments.
        ],
      ),
    );
  }
}
