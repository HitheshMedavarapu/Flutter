import 'package:flutter/material.dart';
import '../../widgets/post_card.dart';
import '../../utils/theme.dart'; // ✅ Use theme

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final List<Map<String, dynamic>> _posts = [
    {
      "username": "John Doe",
      "userProfile": "https://randomuser.me/api/portraits/men/1.jpg",
      "postText": "Excited to start my first semester at NYU! Anyone here?",
      "postImage": "https://source.unsplash.com/random/800x600?college",
      "usefulCount": 12,
      "notUsefulCount": 2,
    },
    {
      "username": "Emma Watson",
      "userProfile": "https://randomuser.me/api/portraits/women/2.jpg",
      "postText": "Looking for a roommate near Harvard. DM me!",
      "postImage": null,
      "usefulCount": 8,
      "notUsefulCount": 1,
    },
    {
      "username": "Mike Johnson",
      "userProfile": "https://randomuser.me/api/portraits/men/3.jpg",
      "postText": "Selling my books from last semester. Anyone interested?",
      "postImage": "https://source.unsplash.com/random/800x600?books",
      "usefulCount": 20,
      "notUsefulCount": 4,
    },
  ];

  void _increaseUseful(int index) {
    setState(() {
      _posts[index]["usefulCount"]++;
    });
  }

  void _increaseNotUseful(int index) {
    setState(() {
      _posts[index]["notUsefulCount"]++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppThemes.backgroundGradient(), // ✅ Uses the app theme
        child: ListView.builder(
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            final post = _posts[index];
            return PostCard(
              username: post["username"],
              userProfile: post["userProfile"],
              postText: post["postText"],
              postImage: post["postImage"],
              usefulCount: post["usefulCount"],
              notUsefulCount: post["notUsefulCount"],
              onUseful: () => _increaseUseful(index),
              onNotUseful: () => _increaseNotUseful(index),
            );
          },
        ),
      ),
    );
  }
}
