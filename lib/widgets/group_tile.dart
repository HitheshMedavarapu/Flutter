import 'package:flutter/material.dart';

class GroupTile extends StatelessWidget {
  final String groupIcon;
  final String groupName;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final VoidCallback onTap;

  const GroupTile({
    Key? key,
    required this.groupIcon,
    required this.groupName,
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
        backgroundImage: NetworkImage(groupIcon),
        radius: 25,
      ),
      title: Text(
        groupName,
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
