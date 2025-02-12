import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupChatsScreen extends StatefulWidget {
  @override
  _GroupChatsScreenState createState() => _GroupChatsScreenState();
}

class _GroupChatsScreenState extends State<GroupChatsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Group Chats")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('groupChats').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No group chats available."));
          }

          var groups = snapshot.data!.docs;

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              var group = groups[index].data() as Map<String, dynamic>;
              String groupId = groups[index].id;
              String groupName = group['name'] ?? 'Unnamed Group';
              String groupIcon = group['groupIcon'] ?? '';

              return ListTile(
                leading: groupIcon.isNotEmpty
                    ? CircleAvatar(backgroundImage: NetworkImage(groupIcon))
                    : const CircleAvatar(child: Icon(Icons.group)),
                title: Text(groupName),
                subtitle: Text("${group['unreadCount'] ?? 0} unread messages"),
                onTap: () {
                  // Navigate to group chat screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupChatScreen(
                          groupId: groupId, groupName: groupName),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class GroupChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;

  const GroupChatScreen(
      {Key? key, required this.groupId, required this.groupName})
      : super(key: key);

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    String currentUserId = _auth.currentUser!.uid;
    String messageText = _messageController.text.trim();

    await _firestore
        .collection('groupChats')
        .doc(widget.groupId)
        .collection('messages')
        .add({
      'senderId': currentUserId,
      'text': messageText,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('groupChats').doc(widget.groupId).update({
      'lastMessage': messageText,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCount': FieldValue.increment(1),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.groupName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('groupChats')
                  .doc(widget.groupId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No messages yet."));
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message =
                        messages[index].data() as Map<String, dynamic>;
                    bool isMe = message['senderId'] == _auth.currentUser!.uid;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[300] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          message['text'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
