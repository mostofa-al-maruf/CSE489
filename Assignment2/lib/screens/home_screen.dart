import 'package:flutter/material.dart';

import 'broadcast_selection_screen.dart';
import 'image_scale_screen.dart';
import 'video_screen.dart';
import 'audio_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // We'll manage navigation using a simple index or by pushing routes.
  // The assignment says "Create flow with help of drawer widget and their designated activities"
  // So replacing the body based on drawer selection is a common approach.

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const BroadcastSelectionScreen(),
    const ImageScaleScreen(),
    const VideoScreen(),
    const AudioScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'BroadMedia\nMenu Options',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('Broadcast Receiver'),
              onTap: () => _onItemTapped(0),
              selected: _selectedIndex == 0,
            ),
            ListTile(
              title: const Text('Image Scale'),
              onTap: () => _onItemTapped(1),
              selected: _selectedIndex == 1,
            ),
            ListTile(
              title: const Text('Video'),
              onTap: () => _onItemTapped(2),
              selected: _selectedIndex == 2,
            ),
            ListTile(
              title: const Text('Audio'),
              onTap: () => _onItemTapped(3),
              selected: _selectedIndex == 3,
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}
