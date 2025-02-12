import 'package:flutter/material.dart';
import 'group_chats_screen.dart';

class GroupListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Group Chats")),
      body: ListView.builder(
        itemCount: 5, // Dummy count, replace with actual group list
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Icon(Icons.group)),
            title: Text("Group $index"),
            subtitle: Text("Last group message..."),
            trailing: Text("1:30 PM"), // Dummy time
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GroupChatsScreen()),
              );
            },
          );
        },
      ),
    );
  }
}
