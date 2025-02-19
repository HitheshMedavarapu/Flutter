import 'package:flutter/material.dart';

class ChatScreenHeader extends StatelessWidget {
  final String chatTitle;
  final VoidCallback onBack;
  final VoidCallback onOptions;

  const ChatScreenHeader({
    Key? key,
    required this.chatTitle,
    required this.onBack,
    required this.onOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(chatTitle),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBack,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: onOptions,
        ),
      ],
    );
  }
}
