import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Text Example'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is a simple text.'),
            Text('This is styled text',
                style: TextStyle(fontSize: 24.0, color: Colors.blue)),
            Text('This is a text\nspanning multiple lines.'),
            Text('This text will wrap if it exceeds the width.', softWrap: true),
            Text('This text will be truncated with ellipsis.',
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

