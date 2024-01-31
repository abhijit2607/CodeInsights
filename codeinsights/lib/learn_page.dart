import 'package:codeinsights/HTML/learnhtml.dart';
import 'package:codeinsights/Java/learnjava.dart';
import 'package:codeinsights/Python/learnpython.dart';
import 'package:codeinsights/underconstructionpage.dart';
import 'package:flutter/material.dart';

import 'course.dart';
import 'main.dart';

class LearnPage extends StatelessWidget {
  LearnPage({super.key}); // Add the key parameter
  final List<Course> courses = [
    // Your course data here
    Course(title: 'Python', description: 'Learn Python programming'),
    Course(title: 'HTML', description: 'Master the art of Web development'),
    Course(title: 'Java', description: 'Master the art of Java development'),
    Course(title: 'C', description: 'Learn C programming'),
    Course(title: 'C++', description: 'Learn C++ programming'),
    Course(title: 'C#', description: 'Learn C# programming'),
    // Add more courses as needed...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose Your Course',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 22, 22, 23),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Card(
            child: ListTile(
              title: Text(
                course.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromARGB(255, 7, 131, 255),
                ),
              ),
              subtitle: Text(course.description, textAlign: TextAlign.center),
              onTap: () {
                if (course.title == 'Python') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LearnPythonPage()),
                  );
                } else if (course.title == 'HTML') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LearnHTMLPage()),
                  );
                } else if (course.title == 'Java') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LearnJavaPage()),
                  );
                } else if (course.title == 'C' ||
                    course.title == 'C++' ||
                    course.title == 'C#') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UnderConstructionPage()),
                  );
                } // ... add more conditions for other courses
              },
            ),
          );
        },
      ),
    );
  }
}