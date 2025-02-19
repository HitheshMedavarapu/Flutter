import 'package:firebase1/widgets/chats/chat_input_field.dart';
import 'package:firebase1/widgets/chats/chat_list.dart';
import 'package:firebase1/widgets/chats/chat_screen_header.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String chatTitle;
  final String chatId;
  final String userId;

  const ChatScreen({
    Key? key,
    required this.chatTitle,
    required this.chatId,
    required this.userId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        messages.add({
          'text': _messageController.text,
          'isSentByMe': true,
          'senderName': 'Me',
          'timestamp': 'Now',
        });
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ChatScreenHeader(
          chatTitle: widget.chatTitle,
          onBack: () => Navigator.pop(context),
          onOptions: () {},
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(messages: messages),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChatInputField(
              controller: _messageController,
              onSend: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
