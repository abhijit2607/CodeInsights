// /lib/create_post_screen.dart

import 'package:flutter/material.dart';

import 'auth.dart';
import 'post.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isNotEmpty &&
                    _contentController.text.isNotEmpty) {
                  // Retrieve the user ID from AuthService
                  String userId = _auth.currentUser?.uid ?? "exampleUserId";
                  // Retrieve the username using the new method
                  String username = await _auth.getUsername(userId) ?? "exampleUser";
                  Post newPost = Post(
                    title: _titleController.text,
                    content: _contentController.text,
                    userId: userId,
                    username: username,
                  );
                  Navigator.pop(context, newPost);
                }
              },
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
