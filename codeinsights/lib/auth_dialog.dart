import 'package:flutter/material.dart';

import 'sign_in_screen.dart';


class AuthDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Authentication Required'),
      content: Text('Please log in or sign up to perform this action.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            // Navigate to the sign-in or sign-up screen
            // You can replace SignInScreen() and SignUpScreen() with your actual authentication screens
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
          },
          child: Text('Log In / Sign Up'),
        ),
      ],
    );
  }
}
