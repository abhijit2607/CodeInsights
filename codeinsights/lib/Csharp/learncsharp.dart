import 'package:flutter/material.dart';

class LearnCSharpPage extends StatelessWidget {
  LearnCSharpPage({super.key});

  final List<String> topics = [
    'C# Introduction',
    'Variables and Data Types',
    'Operators and Expressions',
    'Control Flow Statements',
    'Methods',
    'Classes and Objects',
    'Inheritance',
    'Interfaces',
    'Exception Handling',
    'LINQ',
    'Asynchronous Programming',
    'Windows Forms',
    'ASP.NET',
    'Entity Framework',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 227, 62, 62),
        title: const Text('Learn C#'),
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