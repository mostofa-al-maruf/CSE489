import 'package:flutter/material.dart';
import 'custom_broadcast_display_screen.dart';

class CustomBroadcastInputScreen extends StatefulWidget {
  const CustomBroadcastInputScreen({super.key});

  @override
  State<CustomBroadcastInputScreen> createState() =>
      _CustomBroadcastInputScreenState();
}

class _CustomBroadcastInputScreenState
    extends State<CustomBroadcastInputScreen> {
  final TextEditingController _controller = TextEditingController();

  void _sendCustomBroadcast() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CustomBroadcastDisplayScreen(message: _controller.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Broadcast')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter text to broadcast',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendCustomBroadcast,
              child: const Text('Send Broadcast'),
            ),
          ],
        ),
      ),
    );
  }
}
