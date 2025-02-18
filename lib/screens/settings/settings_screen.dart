import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _chatNotifications = true;
  bool _groupChatNotifications = true;
  bool _suggestions = true;
  bool _promotions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (bool value) {
              setState(() {
                _darkMode = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Chat Notifications'),
            value: _chatNotifications,
            onChanged: (bool value) {
              setState(() {
                _chatNotifications = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Group Chat Notifications'),
            value: _groupChatNotifications,
            onChanged: (bool value) {
              setState(() {
                _groupChatNotifications = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Suggestions'),
            value: _suggestions,
            onChanged: (bool value) {
              setState(() {
                _suggestions = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Promotions'),
            value: _promotions,
            onChanged: (bool value) {
              setState(() {
                _promotions = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
