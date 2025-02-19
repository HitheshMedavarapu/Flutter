import 'package:flutter/material.dart';
import 'chat_bubble.dart';

class ChatList extends StatelessWidget {
  final List<Map<String, dynamic>> messages;

  const ChatList({Key? key, required this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return ChatBubble(
          message: message['text'],
          isSentByMe: message['isSentByMe'],
          senderName: message['senderName'],
          timestamp: message['timestamp'],
        );
      },
    );
  }
}
