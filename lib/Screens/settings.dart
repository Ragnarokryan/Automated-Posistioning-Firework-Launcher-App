import 'package:flutter/material.dart';
//import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';

class BleSettingsScreen extends StatelessWidget {
  const BleSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const Text('BLE Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bluetooth Status:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildBluetoothStatus(),
            const SizedBox(height: 16),
            const Text(
              'Scan for Devices:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Implement scan functionality
              },
              child: const Text('Scan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBluetoothStatus() {
    // Bluetooth status (e.g., connected, disconnected, etc.)
    bool isBluetoothEnabled = true;
    if (isBluetoothEnabled == false){
      return const Text(
      'Disabled',
      style: TextStyle(
        fontSize: 18,
        color: Colors.red,
      ),
    );
    }
    else{
      return const Text(
      'Enabled',
      style: TextStyle(
        fontSize: 18,
        color: Colors.green,
      ),
    );
    }
  }
}
