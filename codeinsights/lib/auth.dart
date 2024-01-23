import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String uid;
  final String? username;

  User({required this.uid, this.username});
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw FirebaseAuthException(message: e.toString());
    }
  }


  Future<void> signUpWithEmailAndPassword(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user?.uid ?? '';
      await _createUser(uid, username);

    } catch (e) {
      throw FirebaseAuthException(message: e.toString());
    }
  }

  Future<void> _createUser(String uid, String username) async {
    await _firestore.collection('users').doc(uid).set({
      'username': username,
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> getUsername(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('users').doc(uid).get();
    return snapshot.data()?['username'];
  }

  User? get currentUser {
    User? user = _auth.currentUser != null
        ? User(uid: _auth.currentUser!.uid, username: _auth.currentUser!.displayName)
        : null;

    return user;
  }
}

class FirebaseAuthException implements Exception {
  final String message;

  FirebaseAuthException({required this.message});
}
