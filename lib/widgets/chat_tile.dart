import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final String profileImage;
  final String username;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final VoidCallback onTap;

  const ChatTile({
    Key? key,
    required this.profileImage,
    required this.username,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(profileImage),
        radius: 25,
      ),
      title: Text(
        username,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey[600]),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          if (unreadCount > 0)
            Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                unreadCount.toString(),
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
