// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Codesights',
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: MyHomePage(),
        debugShowCheckedModeBanner: false, // Remove the debug banner
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = Post.random();
  var history = <Post>[];

  GlobalKey? historyListKey;

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = Post.random();
    notifyListeners();
  }

  var favorites = <Post>[];

  void toggleFavorite([Post? post]) {
    post = post ?? current;
    if (favorites.contains(post)) {
      favorites.remove(post);
    } else {
      favorites.add(post);
    }
    notifyListeners();
  }

  void removeFavorite(Post post) {
    favorites.remove(post);
    notifyListeners();
  }

  void addPost(String title, String content) {
    history.insert(0, Post(title, content));
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  final picker = ImagePicker();
  List<File> _images = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

@override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = PostHistoryPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    var mainArea = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(top: 5, bottom: 5, right: 5), // Adjusted top margin
          child: ElevatedButton(
            onPressed: () {
              _showPostDialog(context, appState);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text('Start Discussion'),
          ),
        ),
        Expanded(
          child: ColoredBox(
            color: colorScheme.surfaceVariant,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: page,
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.book),
                        label: 'Education',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.fitness_center),
                        label: 'Exercise',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 900,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.book),
                        label: Text('Education'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.fitness_center),
                        label: Text('Exercise'),                       
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
  void _showPostDialog(BuildContext context, MyAppState appState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            String title = '';
            String content = '';
            bool showWarning = false;

            return AlertDialog(
              title: Text('Write a Post'),
              content: Container(
                width: 600,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Title',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextField(
                      controller: titleController,
                      onChanged: (value) {
                        title = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Write your title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    if (showWarning && title.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          'Required field',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Content',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextField(
                      controller: contentController,
                      onChanged: (value) {
                        content = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Write your content',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                    if (showWarning && content.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          'Required field',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(height: 10),
                    if (_images.isNotEmpty)
                      Container(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _images.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  margin: EdgeInsets.only(right: 8),
                                  child: Stack(
                                    children: [
                                      Image.file(
                                        _images[index],
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _images.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            color: Colors.red,
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'jpeg', 'png'],
                            );
                            if (result != null && result.files.isNotEmpty) {
                              setState(() {
                                _images.add(File(result.files.single.path!));
                              });
                              print('Image picked: ${result.files.single.path}');
                            }
                          },
                          child: Text('Add Image'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Handle inline code feature
                            print('Inline Code added');
                          },
                          child: Text('Inline Code'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (title.isEmpty || content.isEmpty) {
                      setState(() {
                        showWarning = true;
                      });
                    } else {
                      appState.addPost(title, content);
                      titleController.clear();
                      contentController.clear();
                      _images.clear();

                      print('Post Submitted');
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class PostHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    return ListView.builder(
      itemCount: appState.history.length,
      itemBuilder: (context, index) {
        var post = appState.history[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            title: Text(post.title),
            subtitle: Text(post.content),
          ),
        );
      },
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        Expanded(
          child: GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              childAspectRatio: 400 / 80,
            ),
            children: [
              for (var post in appState.favorites)
                ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
                    color: theme.colorScheme.primary,
                    onPressed: () {
                      appState.removeFavorite(post);
                    },
                  ),
                  title: Text(
                    post.asLowerCase,
                    semanticsLabel: post.asPascalCase,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class Post {
  final String title;
  final String content;

  Post(this.title, this.content);

  factory Post.random() {
    return Post(
      'Title ${DateTime.now().millisecondsSinceEpoch}',
      'Content ${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  String get asLowerCase => '$title $content'.toLowerCase();

  String get asPascalCase => '${title.capitalize()} ${content.capitalize()}';
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}
