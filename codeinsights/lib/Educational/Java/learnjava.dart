import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnJavaPage extends StatelessWidget {
  LearnJavaPage({super.key});

  final List<String> topics = [
    'Java Introduction',
    'Variables and Data Types',
    'Operators and Expressions',
    'Control Flow Statements',
    'Arrays',
    'Methods',
    'Classes and Objects',
    'Inheritance',
    'Interfaces',
    'Exception Handling',
    'Packages',
    'File I/O',
    'Multithreading',
    'Collections Framework',
    'Generics',
    'Networking',
    'Database Connectivity',
  ];

  final Map<String, String> topicUrls = {
    'Java Introduction':'https://www.w3schools.com/java/java_intro.asp',
    'Variables and Data Types':'https://www.guru99.com/java-variables.html',
    'Operators and Expressions':'https://www.informit.com/articles/article.aspx?p=22065&seqNum=6',
    'Control Flow Statements':'https://www.javatpoint.com/control-flow-in-java',
    'Arrays':'https://www.w3schools.com/java/java_arrays.asp',
    'Methods':'https://www.w3schools.com/java/java_methods.asp',
    'Classes and Objects':'https://www.w3schools.com/java/java_classes.asp',
    'Inheritance':'https://www.geeksforgeeks.org/inheritance-in-java/',
    'Interfaces':'https://www.w3schools.com/java/java_interface.asp',
    'Exception Handling':'https://www.javatpoint.com/exception-handling-in-java',
    'Packages':'https://www.w3schools.com/java/java_packages.asp',
    'File I/O':'https://www.tutorialspoint.com/java/java_files_io.htm',
    'Multithreading':'https://www.geeksforgeeks.org/multithreading-in-java/',
    'Collections Framework':'https://docs.oracle.com/javase/8/docs/technotes/guides/collections/overview.html',
    'Generics':'https://www.geeksforgeeks.org/generics-in-java/',
    'Networking':'https://www.javatpoint.com/java-networking',
    'Database Connectivity':'https://www.geeksforgeeks.org/introduction-to-jdbc/',
  };
  
  
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 113, 0),
        title: const Text('Learn Python'),
      ),
      body: ListView.separated(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return ListTile(
            title: Text(topic),
            onTap: () async {
  final topicUrl = topicUrls[topic];
  // ignore: deprecated_member_use
  if (await canLaunch(topicUrl!)) {
    // ignore: deprecated_member_use
    await launch(topicUrl);
  } else {
    // Handle the case where the URL cannot be launched
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cannot launch URL: $topicUrl')),
    );
  }
},
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}