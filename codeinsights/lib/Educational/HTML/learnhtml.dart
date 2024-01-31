import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnHTMLPage extends StatelessWidget {
  LearnHTMLPage({super.key});

  final List<String> topics = [
    'HTML Introduction',
    'Elements and Structure',
    'Text and Formatting',
    'Links and Images',
    'Lists and Tables',
    'Forms and Input',
    'Media and Embedding',
    'Semantic Elements',
    'Accessibility',
    'Responsive Design'
  ];

  final Map<String, String> topicUrls = {
    'HTML Introduction':'https://www.w3schools.com/html/html_intro.asp',
    'Elements and Structure':'https://www.w3schools.com/html/html_elements.asp#:~:text=The%20element%20is%20the,end%20tag%20.&text=The%20element%20defines%20the,end%20tag%20.',
    'Text and Formatting':'https://www.w3schools.com/html/html_formatting.asp',
    'Links and Images':'https://www.w3schools.com/tags/tag_frame.asp',
    'Lists and Tables':'https://blog.eduonix.com/html5-tutorials/html-tables-and-lists/',
    'Forms and Input':'https://www.w3schools.com/html/html_forms.asp',
    'Media and Embedding':'https://www.w3schools.com/tags/tag_embed.asp',
    'Semantic Elements':'https://www.w3schools.com/html/html5_semantic_elements.asp',
    'Accessibility':'https://www.w3schools.com/html/html_accessibility.asp',
    'Responsive Design':'https://www.w3schools.com/html/html_responsive.asp',
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
