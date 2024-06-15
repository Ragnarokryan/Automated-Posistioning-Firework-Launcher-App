import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../Screens/connect_position.dart';
import '../Screens/ignition_screen.dart';

class BottomNavigationBarExampleApp extends StatelessWidget {
  final BluetoothConnection connection;
  const BottomNavigationBarExampleApp({super.key, required this.connection});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavigationBarExample(connection: connection),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  final BluetoothConnection connection;
  const BottomNavigationBarExample({super.key, required this.connection});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
  extends State<BottomNavigationBarExample> {
  late final BluetoothConnection connection;
  late final List<Widget> _screens;
  final List<bool> _loadedScreens = [
    true,
    true,
  ]; // Keep track of loaded screens

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    connection = widget.connection;

    _screens = [
      PositioningScreen(connection: connection),
      IgnitionScreen(connection: connection),
    ];
    // Start Bluetooth device discovery when the widget is initialized
    _initializeBluetooth();
  }

  Future<void> _initializeBluetooth() async {
    // Request necessary permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.location,
    ].request();

    // Check if permissions are granted
    if (statuses[Permission.bluetooth] != PermissionStatus.granted ||
        statuses[Permission.location] != PermissionStatus.granted) {
      // Permissions not granted, handle accordingly
      // For example, show a message to the user or request permissions again
    } else {
      // Permissions granted, proceed with Bluetooth operations
      scanDevices();
    }
  }

  Future<void> scanDevices() async {
    // Start listening for discovered devices
    FlutterBluetoothSerial.instance.startDiscovery().listen(
      (BluetoothDiscoveryResult r) async {
        if (r.device.address == "98:D3:02:96:98:D7") {
          // Found the HC-05 device, stop scanning
          await FlutterBluetoothSerial.instance.cancelDiscovery();

          // Attempt to connect to the HC-05 device
          var connection = await connectToDevice(context);

          // Handle the connection result
          if (connection != null) {
            // Update the connection state using the provider
            setState(() {
              connection = connection; // Update the connection
            });
          } else {
            // Handle connection error
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Connection Error'),
                  content: const Text('Failed to connect to the device.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
      },
      onError: (dynamic error) {
        debugPrint('Error during discovery: $error');
      },
      onDone: () {
        // Scanning is complete
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.wifi_tethering),
            label: 'Positioning', // Empty label, using icon only
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department),
            label: 'Ignition', // Empty label, using icon only
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // Adjust selected item color as needed
        selectedLabelStyle: const TextStyle(
          fontFamily: 'CrimsonText',
        ),
        unselectedItemColor:
            Colors.grey, // Adjust unselected item color as needed
        onTap: _onItemTapped,
      ),
    );
  }

void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
    // Transmit data based on the selected screen
    if (index == 0) {
      //Transmit "6" when the PositioningScreen is accessed
      _transmitData("6");
    } else if (index == 1) {
      //Transmit "7" when the IgnitionScreen is accessed
      _transmitData("7");
    }
    // Check if the screen is already loaded, if not load it
    if (!_loadedScreens[index]) {
      _loadedScreens[index] = true;
    }
  });
}

void _transmitData(String data) {
    // Send the data using the Bluetooth connection
    widget.connection.output.add(Uint8List.fromList(utf8.encode(data)));
    widget.connection.output.allSent.then((_) {
        debugPrint("Sent data: $data");
    });
}
}

Future<BluetoothConnection?> connectToDevice(BuildContext context) async {
  try {
    final connection = await BluetoothConnection.toAddress("98:D3:02:96:98:D7");
    if (connection.isConnected) {
      return connection; // Return the connection object
    } else {
      return null;
    }
  } catch (e) {
    debugPrint('Error connecting to device: $e');
    return null; // Handle connection error here
  }
}