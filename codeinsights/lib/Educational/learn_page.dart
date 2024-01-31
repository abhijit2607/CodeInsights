import 'package:flutter/material.dart';
import 'course.dart';
import 'package:flutter_application_1/Python/learnpython.dart';
import 'package:flutter_application_1/HTML/learnhtml.dart';
import 'package:flutter_application_1/Java/learnjava.dart';
/*import 'package:flutter_application_1/C/learnc.dart';
import 'package:flutter_application_1/C++/learncplusplus.dart';
import 'package:flutter_application_1/Csharp/learncsharp.dart';*/
import 'package:flutter_application_1/underconstructionpage.dart';


class LearnPage extends StatelessWidget 
{
  LearnPage({super.key}); // Add the key parameter
  final List<Course> courses = 
  [
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
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Choose Your Course',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: const Color.fromARGB(255, 232, 156, 16)
      ),
      body:ListView.builder
      (
        itemCount: courses.length,
        itemBuilder: (context, index) 
        {
          final course = courses[index];
          return Card
          (
            child: ListTile
            (
              title: Text
              (
              course.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20, // Adjust the font size as desired
              color: Color.fromARGB(255, 7, 131, 255)
                  ),
              ),
              subtitle: Text(course.description, textAlign: TextAlign.center),
                onTap: () {
                  if (course.title == 'Python') {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LearnPythonPage()),
                    );
                  }
                  else if (course.title == 'HTML') {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LearnHTMLPage()),
                    );
                  }
                  else if (course.title == 'Java') {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LearnJavaPage()),
                    );
                  } 
                  else if (course.title == 'C') {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UnderConstructionPage()),
                    );
                  }
                  else if (course.title == 'C++') {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UnderConstructionPage()),
                    );
                  }
                  else if (course.title == 'C#') {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UnderConstructionPage()),
                    );
                  }// ... add more conditions for other courses
                },
            ),
          );
        },
      ),
    );
  }
}
