import 'package:flutter/material.dart';

class LearnCPlusPlusPage extends StatelessWidget {
  LearnCPlusPlusPage({super.key});

  final List<String> topics = [
    'C++ Introduction',
    'Basic Syntax',
    'Operators and Expressions',
    'Control Flow Statements',
    'Functions',
    'Arrays',
    'Pointers',
    'Classes and Objects',
    'Inheritance',
    'Polymorphism',
    'Templates',
    'Exception Handling',
    'Standard Template Library (STL)',
    'File I/O',
    'Memory Management',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 78, 191, 37),
        title: const Text('Learn C++'),
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