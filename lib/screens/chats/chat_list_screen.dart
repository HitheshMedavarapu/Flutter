import 'package:flutter/material.dart';
import 'chats_screen.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chats")),
      body: ListView.builder(
        itemCount: 10, // Dummy count, replace with actual chat list
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text("User $index"),
            subtitle: Text("Last message preview..."),
            trailing: Text("12:00 PM"), // Dummy time
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatsScreen()),
              );
            },
          );
        },
      ),
    );
  }
}
