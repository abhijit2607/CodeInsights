import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPost(String title, String content, String username) async {
    await _firestore.collection('posts').add({
      'title': title,
      'content': content,
      'username': username,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Post>> getPosts() {
    return _firestore.collection('posts').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Post(
          title: data['title'] ?? '',
          content: data['content'] ?? '',
          username: data['username'] ?? '',
        );
      }).toList();
    });
  }
}
