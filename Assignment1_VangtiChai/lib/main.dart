import 'package:flutter/material.dart';

void main() {
  runApp(const VangtiChaiApp());
}

class VangtiChaiApp extends StatelessWidget {
  const VangtiChaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VangtiChai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: const Color(0xFF009688),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF009688),
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      ),
      home: const VangtiChaiHome(),
    );
  }
}

class VangtiChaiHome extends StatefulWidget {
  const VangtiChaiHome({super.key});

  @override
  State<VangtiChaiHome> createState() => _VangtiChaiHomeState();
}

class _VangtiChaiHomeState extends State<VangtiChaiHome> {
  String _amountString = '';

  final List<int> _denominations = [500, 100, 50, 20, 10, 5, 2, 1];

  void _appendDigit(String digit) {
    setState(() {
      _amountString += digit;
    });
  }

  void _clear() {
    setState(() {
      _amountString = '';
    });
  }

  int get _amount {
    if (_amountString.isEmpty) return 0;
    return int.tryParse(_amountString) ?? 0;
  }

  Map<int, int> get _changeCounts {
    final counts = <int, int>{};
    int remaining = _amount;
    for (final denom in _denominations) {
      counts[denom] = remaining ~/ denom;
      remaining = remaining % denom;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VangtiChai'),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final screenWidth = MediaQuery.of(context).size.width;
          final isTablet = screenWidth >= 600;

          if (orientation == Orientation.portrait) {
            return _buildPortraitLayout(isTablet);
          } else {
            return _buildLandscapeLayout(isTablet);
          }
        },
      ),
    );
  }

  // ========== PORTRAIT LAYOUT ==========
  Widget _buildPortraitLayout(bool isTablet) {
    final textScale = isTablet ? 1.5 : 1.0;

    return Column(
      children: [
        _buildTakaHeader(textScale),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 40,
                child: _buildChangeTableSingleColumn(textScale),
              ),
              Expanded(
                flex: 60,
                child: _buildKeypad3Col(textScale),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ========== LANDSCAPE LAYOUT ==========
  Widget _buildLandscapeLayout(bool isTablet) {
    final textScale = isTablet ? 1.4 : 1.0;

    return Column(
      children: [
        _buildTakaHeader(textScale),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 50,
                child: _buildChangeTableTwoColumns(textScale),
              ),
              Expanded(
                flex: 50,
                child: _buildKeypad4Col(textScale),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ========== TAKA HEADER ==========
  Widget _buildTakaHeader(double textScale) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16.0 * textScale,
        vertical: 16.0 * textScale,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Taka: ',
            style: TextStyle(
              fontSize: 22.0 * textScale,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          Text(
            _amountString.isEmpty ? '' : _amountString,
            style: TextStyle(
              fontSize: 22.0 * textScale,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ========== CHANGE TABLE - SINGLE COLUMN (Portrait) ==========
  Widget _buildChangeTableSingleColumn(double textScale) {
    final counts = _changeCounts;
    return Padding(
      padding: EdgeInsets.only(
        left: 24.0 * textScale,
        top: 8.0 * textScale,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _denominations.map((denom) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0 * textScale),
            child: Text(
              '$denom: ${counts[denom]}',
              style: TextStyle(
                fontSize: 18.0 * textScale,
                color: Colors.black,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ========== CHANGE TABLE - TWO COLUMNS (Landscape) ==========
  Widget _buildChangeTableTwoColumns(double textScale) {
    final counts = _changeCounts;
    final leftDenoms = [500, 100, 50, 20];
    final rightDenoms = [10, 5, 2, 1];

    return Padding(
      padding: EdgeInsets.only(
        left: 24.0 * textScale,
        top: 8.0 * textScale,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: leftDenoms.map((denom) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0 * textScale),
                  child: Text(
                    '$denom: ${counts[denom]}',
                    style: TextStyle(
                      fontSize: 18.0 * textScale,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: rightDenoms.map((denom) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0 * textScale),
                  child: Text(
                    '$denom: ${counts[denom]}',
                    style: TextStyle(
                      fontSize: 18.0 * textScale,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ========== KEYPAD - 3 COLUMNS (Portrait) ==========
  Widget _buildKeypad3Col(double textScale) {
    return Padding(
      padding: EdgeInsets.all(8.0 * textScale),
      child: Column(
        children: [
          _buildKeypadRow(['1', '2', '3'], textScale),
          _buildKeypadRow(['4', '5', '6'], textScale),
          _buildKeypadRow(['7', '8', '9'], textScale),
          _buildKeypadRow(['0', 'CLEAR'], textScale, flexes: [1, 2]),
        ],
      ),
    );
  }

  // ========== KEYPAD - 4 COLUMNS (Landscape) ==========
  Widget _buildKeypad4Col(double textScale) {
    return Padding(
      padding: EdgeInsets.all(8.0 * textScale),
      child: Column(
        children: [
          _buildKeypadRow(['1', '2', '3', '4'], textScale),
          _buildKeypadRow(['5', '6', '7', '8'], textScale),
          _buildKeypadRow(['9', '0', 'CLEAR'], textScale, flexes: [1, 1, 2]),
        ],
      ),
    );
  }

  // ========== KEYPAD ROW ==========
  Widget _buildKeypadRow(List<String> labels, double textScale, {List<int>? flexes}) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: labels.asMap().entries.map((entry) {
          int idx = entry.key;
          String label = entry.value;
          int flex = flexes != null ? flexes[idx] : 1;
          
          return Expanded(
            flex: flex,
            child: Padding(
              padding: EdgeInsets.all(4.0 * textScale),
              child: ElevatedButton(
                onPressed: () {
                  if (label == 'CLEAR') {
                    _clear();
                  } else {
                    _appendDigit(label);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE0E0E0),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 20.0 * textScale,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
