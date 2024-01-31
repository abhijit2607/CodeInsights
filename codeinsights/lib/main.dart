import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'auth.dart';
import 'learn_page.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

final AuthService authService = AuthService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBNNhBzISxqg452EzXHAejKNhZGTKr4wC8",
      authDomain: "codeinsights-792b1.firebaseapp.com",
      databaseURL:
          "https://codeinsights-792b1-default-rtdb.asia-southeast1.firebasedatabase.app",
      projectId: "codeinsights-792b1",
      storageBucket: "codeinsights-792b1.appspot.com",
      messagingSenderId: "358578040162",
      appId: "1:358578040162:web:86afd7f66fb5a71e36903b",
    ),
  );
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Codewire',
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: MyHomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = Post.random("default_username"); // Set a default username
  var history = <Post>[];

  GlobalKey<AnimatedListState>? historyListKey;

  void getNext(String username) {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState;
    animatedList?.insertItem(0);
    current = Post.random(username);
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
    var animatedList = historyListKey?.currentState;
    animatedList?.insertItem(0);
    notifyListeners();
    FirestoreService().addPost(title, content, current.username);
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPost(String title, String content, String username) async {
    try {
      await _firestore.collection('posts').add({
        'title': title,
        'content': content,
        'username': username,
      });
    } catch (e) {
      print('Error adding post: $e');
    }
  }

  Stream<List<Post>> getPosts() {
    try {
      return _firestore.collection('posts').snapshots().map(
        (snapshot) {
          return snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return Post(
              data['title'],
              data['content'],
              userId: doc.id,
              username: data['username'],
            );
          }).toList();
        },
      );
    } catch (e) {
      print('Error getting posts: $e');
      return Stream.value([]);
    }
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

    Widget _buildLeadingWidget() {
      final screenWidth = MediaQuery.of(context).size.width;

      if (screenWidth < 450) {
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceEvenly, // Align children to the start (left)
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 105.0,
                    right: 100.0), // Adjust the left padding as needed
                child: Text(
                  'CW',
                  style: TextStyle(
                    fontFamily: 'TeXGyreBonum',
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                padding: EdgeInsets.only(left: 20, right: 0),
                onPressed: () {
                  // Add your search icon action here
                },
              ),
            ],
          ),
        );
      } else {
        return _buildLogoImage();
      }
    }

    var leadingWidget = _buildLeadingWidget();

    var mainArea = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            leadingWidget,
            if (MediaQuery.of(context).size.width >= 450)
              ElevatedButton(
                onPressed: () {
                  _showPostDialog(context, appState);
                },
                child: Text('Start Discussion',
                    style: TextStyle(color: Colors.white)),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(child: mainArea),
                  ],
                ),
                Positioned(
                  bottom: 8,
                  left: 305,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          _showPostDialog(context, appState);
                        },
                        tooltip: 'Start Discussion',
                        child: Icon(Icons.post_add),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                        ),
                      ),
                      if (MediaQuery.of(context).size.width >=
                          1024) // Only show the search box for desktop view
                        Container(
                          width: 200, // Adjust the width as needed
                          padding: EdgeInsets.only(left: 8),
                          child: TextField(
                            // Add your search text field properties here
                            decoration: InputDecoration(
                              hintText: 'Search',
                              // ... other properties
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Row(
              children: [
                if (MediaQuery.of(context).size.width >= 450 &&
                    MediaQuery.of(context).size.width < 900)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: FloatingActionButton(
                        onPressed: () {
                          _showPostDialog(context, appState);
                        },
                        tooltip: 'Start Discussion',
                        child: Icon(Icons.post_add),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 900,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                        padding: EdgeInsets.only(top: 10, bottom: 0),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.notifications),
                        label: Text('Notifications'),
                        padding: EdgeInsets.only(top: 0, bottom: 0),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.book),
                        label: Text('Education'),
                        padding: EdgeInsets.only(top: 0, bottom: 0),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.fitness_center),
                        label: Text('Exercise'),
                        padding: EdgeInsets.only(top: 0, bottom: 0),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                        if (value == 2) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LearnPage()),
                          );
                        }
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

      drawer: MediaQuery.of(context).size.width < 450
          ? _buildDrawer(context)
          : null,

      bottomNavigationBar: MediaQuery.of(context).size.width < 1024
          ? BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: 'Notifications',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book),
                  label: 'Education',
                ),
              ],
              currentIndex: selectedIndex,
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                  // Add logic to navigate to the corresponding page based on the index
                  if (index == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LearnPage()),
                    );
                  }
                });
              },
            )
          : null, // Hide bottom navigation bar on desktop
    );
  }

  Widget _buildLogoImage() {
    return Image.asset('assets/logo.png', width: 180, height: 180);
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 29, 29, 30),
            ),
            child: Text(
              'Codewire',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              // Handle item 1 tap
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              // Handle item 2 tap
            },
          ),
          ListTile(
            title: Text('Login'),
            onTap: () {
              _showLoginDialog(context);
            },
          ),
          ListTile(
            title: Text('Sign Up'),
            onTap: () {
              _showSignUpDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    // Implement the login dialog here
    // You can use the same StatefulBuilder pattern as in the _showPostDialog method
    Navigator.pop(context); // Close the drawer
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignInScreen()));
  }

  void _showSignUpDialog(BuildContext context) {
    // Implement the sign-up dialog here
    // You can use the same StatefulBuilder pattern as in the _showPostDialog method
    Navigator.pop(context); // Close the drawer
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpScreen()));
  }

  void _showPostDialog(BuildContext context, MyAppState appState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            String title = '';
            String content = '';
            bool showWarning = true;

            return AlertDialog(
              title: Text('Write a Post'),
              content: Container(
                width: 900,
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
                              print(
                                  'Image picked: ${result.files.single.path}');
                            }
                          },
                          child: Text('Add Image'),
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
    return StreamBuilder<List<Post>>(
      stream: FirestoreService().getPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No posts yet.'));
        } else {
          var posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              var post = posts[index];
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
        child: Text('No Notifications yet.'),
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
  final String userId;
  final String username;
  final List<Comment> comments; // Add a list of comments to the Post class

  Post(this.title, this.content, {this.userId = '', this.username = '', List<Comment>? comments})
      : comments = comments ?? []; // Initialize the comments list

  factory Post.random(String username) {
    return Post(
      'Title ${DateTime.now().millisecondsSinceEpoch}',
      'Content ${DateTime.now().millisecondsSinceEpoch}',
      username: username,
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

class BottomIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const BottomIconButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          color: Colors.white,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
class Comment {
  final String userId;
  final String username;
  final String content;

  Comment({required this.userId, required this.username, required this.content});
}


    // Author: Seirennn@github.com

