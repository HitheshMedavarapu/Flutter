import 'package:flutter/material.dart';
import '../settings/settings_screen.dart';
import '../chats/chats_screen.dart';
import '../group_chats/group_chats_screen.dart';
import '../marketplace/marketplace_screen.dart';
import '../maps/maps_screen.dart';
import 'feed_screen.dart';
import '../profile/profile_screen.dart'; // Import profile screen
import 'package:flutter_redux/flutter_redux.dart';
import '../../redux/auth/auth_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2; // Default is Home

  final List<Widget> _screens = [
    ChatsScreen(),
    GroupChatsScreen(),
    FeedScreen(),
    MarketplaceScreen(),
    MapsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unif1"),
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: _openSettings,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person), // Profile icon
            onPressed: _openProfile,
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chats"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Groups"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.store), label: "Marketplace"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Maps"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
