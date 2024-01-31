import 'package:flutter/material.dart';

class LearnCPage extends StatelessWidget {
  LearnCPage({super.key});

  final List<String> topics = [
    'C Introduction',
    'Basic Syntax',
    'Variables and Data Types',
    'Operators and Expressions',
    'Control Flow Statements',
    'Functions',
    'Arrays',
    'Pointers',
    'Structures',
    'Unions',
    'File I/O',
    'Memory Management',
    'Preprocessor Directives',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 213, 241, 3),
        title: const Text('Learn C'),
      ),
      body: ListView.separated(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return ListTile(
            title: Text(topic),
            onTap: () {
              // Navigate to the individual topic page (yet to be implemented)
            },
          );
        },
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }
}