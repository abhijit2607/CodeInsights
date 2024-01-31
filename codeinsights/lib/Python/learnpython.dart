import 'package:flutter/material.dart';
//import 'package:flutter_application_1/webview_page.dart';
import 'package:url_launcher/url_launcher.dart';


class LearnPythonPage extends StatelessWidget {
  LearnPythonPage({super.key});

  final List<String> topics = [
    'Python Introduction',
    'Variables and Data Types',
    'Operators and Expressions',
    'Control Flow',
    'Functions',
    'Data Structures',
    'Modules and Packages',
    'Object-Oriented Programming',
    'Exception Handling',
    'Regular Expressions',
    'Web Development with Python (Flask, Django)',
    'Data Analysis with Python (Pandas, NumPy, Matplotlib)',
  ];

  final Map<String, String> topicUrls = {
    'Python Introduction': 'https://www.w3schools.com/python/python_intro.asp',
    'Variables and Data Types':'https://www.edureka.co/blog/variables-and-data-types-in-python/',
    'Operators and Expressions':'https://realpython.com/python-operators-expressions/',
    'Control Flow':'https://www.pythoncheatsheet.org/cheatsheet/control-flow',
    'Data Structures':'https://www.geeksforgeeks.org/python-data-structures/',
    'Modules and Packages':'https://realpython.com/python-modules-packages/',
    'Object-Oriented Programming':'https://realpython.com/python3-object-oriented-programming/',
    'Exception Handling':'https://www.geeksforgeeks.org/python-exception-handling/',
    'Regular Expressions':'https://www.geeksforgeeks.org/regular-expression-python-examples/',
    'Web Development with Pytho (Flask, Django)':'https://realpython.com/tutorials/web-dev/',
    'Data Analysis with Python (Pandas, NumPy, Matplotlib)':'https://www.geeksforgeeks.org/data-analysis-with-python/',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 22, 22, 23),
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
