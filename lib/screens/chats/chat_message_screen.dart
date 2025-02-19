import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatMessageScreen extends StatefulWidget {
  final String chatId;
  final String userId;
  final String chatTitle;

  const ChatMessageScreen({
    Key? key,
    required this.chatId,
    required this.userId,
    required this.chatTitle,
  }) : super(key: key);

  @override
  _ChatMessageScreenState createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _markMessagesAsRead();
  }

  void _markMessagesAsRead() async {
    String currentUserId = _auth.currentUser!.uid;
    DocumentReference chatRef =
        FirebaseFirestore.instance.collection('chats').doc(widget.chatId);

    await chatRef.update({
      'unreadCount.$currentUserId': 0, // Reset unread count
    });
  }

  void _sendMessage({String? imageUrl}) async {
    if (_messageController.text.trim().isEmpty && imageUrl == null) return;

    String currentUserId = _auth.currentUser!.uid;
    String messageText = _messageController.text.trim();

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
      'senderId': currentUserId,
      'text': imageUrl == null ? messageText : null,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Update chat metadata
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .update({
      'lastMessage': imageUrl == null ? messageText : "📷 Image",
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCount.${widget.userId}':
          FieldValue.increment(1), // Increase unread for receiver
      'typingStatus.$currentUserId': false, // Reset typing status
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void _updateTypingStatus(bool isTyping) async {
    if (_isTyping == isTyping) return; // Prevent unnecessary updates
    setState(() => _isTyping = isTyping);

    String currentUserId = _auth.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .update({
      'typingStatus.$currentUserId': isTyping,
    });
  }

  Future<void> _pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    File file = File(image.path);
    String fileName =
        'chats/${widget.chatId}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    UploadTask uploadTask =
        FirebaseStorage.instance.ref().child(fileName).putFile(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    _sendMessage(imageUrl: downloadUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.chatTitle)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var messageData =
                        messages[index].data() as Map<String, dynamic>;
                    bool isMe =
                        messageData['senderId'] == _auth.currentUser!.uid;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: messageData['imageUrl'] != null
                            ? Image.network(
                                messageData['imageUrl'],
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                            : Text(
                                messageData['text'] ?? '',
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                ),
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .doc(widget.chatId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const SizedBox.shrink();
              }

              var chatData = snapshot.data!.data() as Map<String, dynamic>;
              bool isOtherUserTyping =
                  chatData['typingStatus']?[widget.userId] ?? false;

              return isOtherUserTyping
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${widget.chatTitle} is typing...",
                        style: const TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.grey),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.green),
                  onPressed: _pickAndUploadImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onChanged: (text) {
                      _updateTypingStatus(text.isNotEmpty);
                    },
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
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
