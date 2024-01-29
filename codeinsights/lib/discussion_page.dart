import 'package:flutter/material.dart';

import 'auth.dart';
import 'auth_dialog.dart';
import 'comment_screen.dart';
import 'create_post_screen.dart';
import 'post.dart';


class DiscussionPage extends StatefulWidget {
  @override
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  final AuthService _auth = AuthService();
  List<Post> posts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discussion Page'),
        actions: [
          if (_auth.currentUser != null)
            TextButton(
              onPressed: () async {
                await _auth.signOut();
                _refreshPage();
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          if (_auth.currentUser == null)
            TextButton(
              onPressed: () {
                _auth.currentUser == null ? showAuthDialog(context) : null;
              },
              child: Text(
                _auth.currentUser == null
                    ? 'Sign In'
                    : 'Logged in as ${_auth.currentUser?.username}',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          return buildPostItem(posts[index]);
        },
      ),
      floatingActionButton: _auth.currentUser != null
          ? FloatingActionButton(
              onPressed: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreatePostScreen()),
                );

                if (result != null && result is Post) {
                  setState(() {
                    result.userId = _auth.currentUser!.uid;
                    posts.add(result);
                  });
                }
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  Widget buildPostItem(Post post) {
    return ListTile(
      title: Text(post.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.content),
          SizedBox(height: 8), // Add some space between content and username
          if (post.username != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Posted by ',
                ),
                Text(
                  post.username!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ), // Use post.username
              ],
            ),
        ],
      ),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CommentScreen(post: post)),
        );
        _refreshPage();
      },
    );
  }

  void _refreshPage() {
    setState(() {});
  }

  void showAuthDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AuthDialog();
      },
    ).then((_) => _refreshPage());
  }
}
