import 'package:flutter/material.dart';
import '../../utils/theme.dart'; // ✅ Import the theme

class PostCard extends StatelessWidget {
  final String username;
  final String userProfile;
  final String postText;
  final String? postImage;
  final int usefulCount;
  final int notUsefulCount;
  final VoidCallback onUseful;
  final VoidCallback onNotUseful;

  const PostCard({
    Key? key,
    required this.username,
    required this.userProfile,
    required this.postText,
    this.postImage,
    required this.usefulCount,
    required this.notUsefulCount,
    required this.onUseful,
    required this.onNotUseful,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 5,
      color: theme.cardColor, // ✅ Uses theme's card color
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(userProfile),
                  radius: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  username,
                  style: theme.textTheme.titleLarge?.copyWith(
                    // ✅ FIXED
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Post Content
            Text(
              postText,
              style: theme.textTheme.bodyMedium, // ✅ FIXED
            ),

            // Post Image (if available)
            if (postImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(postImage!, fit: BoxFit.cover),
                ),
              ),

            // Actions Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.thumb_up),
                      color: theme.primaryColor, // ✅ Use theme color
                      onPressed: onUseful,
                    ),
                    Text("$usefulCount"),
                    IconButton(
                      icon: const Icon(Icons.thumb_down),
                      color: Colors.red, // ✅ Negative action color
                      onPressed: onNotUseful,
                    ),
                    Text("$notUsefulCount"),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  color: theme.primaryColor, // ✅ Use theme color
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
