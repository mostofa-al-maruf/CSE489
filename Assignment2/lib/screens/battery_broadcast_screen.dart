import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryBroadcastScreen extends StatefulWidget {
  const BatteryBroadcastScreen({super.key});

  @override
  State<BatteryBroadcastScreen> createState() => _BatteryBroadcastScreenState();
}

class _BatteryBroadcastScreenState extends State<BatteryBroadcastScreen> {
  final Battery _battery = Battery();
  int _batteryLevel = 0;
  BatteryState _batteryState = BatteryState.unknown;

  @override
  void initState() {
    super.initState();
    _initBattery();
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      if (mounted) {
        setState(() {
          _batteryState = state;
        });
        _getBatteryLevel();
      }
    });
  }

  Future<void> _initBattery() async {
    await _getBatteryLevel();
  }

  Future<void> _getBatteryLevel() async {
    final level = await _battery.batteryLevel;
    if (mounted) {
      setState(() {
        _batteryLevel = level;
      });
    }
  }

  String _getBatteryStateText(BatteryState state) {
    switch (state) {
      case BatteryState.charging:
        return 'Charging';
      case BatteryState.discharging:
        return 'Discharging';
      case BatteryState.full:
        return 'Full';
      case BatteryState.connectedNotCharging:
        return 'Connected (Not Charging)';
      case BatteryState.unknown:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Battery Status')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _batteryState == BatteryState.charging
                  ? Icons.battery_charging_full
                  : Icons.battery_full,
              size: 100,
              color: _batteryState == BatteryState.charging
                  ? Colors.green
                  : Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              'Battery Level: $_batteryLevel%',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'State: ${_getBatteryStateText(_batteryState)}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
