import 'package:flutter/material.dart';
import 'custom_broadcast_input_screen.dart';
import 'battery_broadcast_screen.dart';

class BroadcastSelectionScreen extends StatefulWidget {
  const BroadcastSelectionScreen({super.key});

  @override
  State<BroadcastSelectionScreen> createState() =>
      _BroadcastSelectionScreenState();
}

class _BroadcastSelectionScreenState extends State<BroadcastSelectionScreen> {
  String _selectedOperation = 'Custom';

  final List<String> _operations = ['Custom', 'System battery'];

  void _proceed() {
    if (_selectedOperation == 'Custom') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CustomBroadcastInputScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BatteryBroadcastScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select a broadcast type',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedOperation,
              items: _operations.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedOperation = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(onPressed: _proceed, child: const Text('Proceed')),
          ],
        ),
      ),
    );
  }
}
