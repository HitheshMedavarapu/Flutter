import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final String username;
  final String profileImage;
  final String postText;
  final String? postImage;
  final int usefulCount;
  final int notUsefulCount;
  final VoidCallback onUsefulPressed;
  final VoidCallback onNotUsefulPressed;
  final VoidCallback onSharePressed;

  const PostWidget({
    Key? key,
    required this.username,
    required this.profileImage,
    required this.postText,
    this.postImage,
    required this.usefulCount,
    required this.notUsefulCount,
    required this.onUsefulPressed,
    required this.onNotUsefulPressed,
    required this.onSharePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(profileImage),
                  radius: 20,
                ),
                SizedBox(width: 10),
                Text(
                  username,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              postText,
              style: TextStyle(fontSize: 14),
            ),
            if (postImage != null) ...[
              SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(postImage!, fit: BoxFit.cover),
              ),
            ],
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.thumb_up, color: Colors.green),
                      onPressed: onUsefulPressed,
                    ),
                    Text("$usefulCount"),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.thumb_down, color: Colors.red),
                      onPressed: onNotUsefulPressed,
                    ),
                    Text("$notUsefulCount"),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.share, color: Colors.blue),
                  onPressed: onSharePressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
