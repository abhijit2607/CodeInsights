// /lib/firebase.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

void initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBNNhBzISxqg452EzXHAejKNhZGTKr4wC8",
      authDomain: "codeinsights-792b1.firebaseapp.com",
      databaseURL: "https://codeinsights-792b1-default-rtdb.asia-southeast1.firebasedatabase.app",
      projectId: "codeinsights-792b1",
      storageBucket: "codeinsights-792b1.appspot.com",
      messagingSenderId: "358578040162",
      appId: "1:358578040162:web:86afd7f66fb5a71e36903b",
      measurementId: "G-76CCB3YP27",
    ),
  );
}