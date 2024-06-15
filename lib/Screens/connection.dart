import 'dart:async';
import '../Screens/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:audioplayers/audioplayers.dart';

class BluetoothApp extends StatelessWidget {
  final BluetoothConnection connection;
  const BluetoothApp({super.key, required this.connection});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BluetoothConnectionPage(),
    );
  }
}

class BluetoothConnectionPage extends StatefulWidget {
  const BluetoothConnectionPage({super.key});

  @override
  State<BluetoothConnectionPage> createState() =>
      _BluetoothConnectionPageState();
}

class _BluetoothConnectionPageState extends State<BluetoothConnectionPage> {
  bool scanning = false;
  BluetoothConnection? _connection;
  bool _connectionEstablished = false;

  @override
  void initState() {
    super.initState();
    _initializeBluetooth();
  }

  Future<void> _initializeBluetooth() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.location,
      Permission.bluetoothScan, // Request BLUETOOTH_SCAN permission
      Permission.bluetoothConnect, // Request BLUETOOTH_CONNECT permission
    ].request();

    // Check permissions
    if (statuses[Permission.bluetoothScan] != PermissionStatus.granted ||
        statuses[Permission.bluetoothConnect] != PermissionStatus.granted ||
        statuses[Permission.location] != PermissionStatus.granted) {
      // Permissions not granted, handle accordingly
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permissions are required. Please grant them.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Permissions granted, proceed with Bluetooth operations
      _connectToDevice();
    }
  }

  Future<void> scanDevices() async {
    setState(() {
      scanning = true;
    });

    // Start listening for discovered devices
    FlutterBluetoothSerial.instance.startDiscovery().listen(
      (BluetoothDiscoveryResult r) async {
        if (r.device.address == "98:D3:02:96:98:D7") {
          // Found the HC-05 device, stop scanning
          await FlutterBluetoothSerial.instance.cancelDiscovery();

          // Connect to the HC-05 device
          await _connectToDevice();
        }
      },
      onError: (dynamic error) {
        debugPrint('Error during discovery: $error');
      },
      onDone: () {
        // Scanning is complete
        setState(() {
          scanning = false;
        });
      },
    );
  }

  Future<void> _connectToDevice() async {
    try {
      final connection =
          await BluetoothConnection.toAddress("98:D3:02:96:98:D7");
      setState(() {
        _connection = connection;
      });

      if (_connection != null && _connection!.isConnected) {
        // AudioPlayer audioPlayer = AudioPlayer();

        // // Play MP3 sound file when connection is established
        // await audioPlayer.play(AssetSource(
        //     'The_Bluetooth_Device_Is_Connected_Successfully_Sound.mp3'));

        // Send the value 145 to the device
        // _connection!.output.add(Uint8List.fromList(utf8.encode("145")));
        // await _connection!.output.allSent;
        // debugPrint("Sent 145 to the connected device");

        // _connection!.input.listen((data) {
        // final receivedData = utf8.decode(data);
        // // Handle the received data here
        // });
        // Delay for 3 seconds when connecting
        setState(() {
          _connectionEstablished = true;
        });
        await Future.delayed(const Duration(seconds: 2)); // Display "Connected to HC-05" for 2 seconds
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BottomNavigationBarExample(connection: _connection!)),
        );
      } else {
        // Connection failed
        debugPrint("Failed to connect to device");
      }
    } catch (e) {
      debugPrint("Error connecting to device: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF64B5F6), // Light ocean blue
                        Color.fromARGB(210, 24, 14, 165), // Dark ocean blue
                      ],
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                Positioned(
                  top: 50,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: scanning
                            ? _buildConnectingText()
                            : _buildHeaderText(),
                      ),
                    ),
                  ),
                ),
                const Center(
                  child: Icon(
                    Icons.bluetooth,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  child: scanning
                      ? const CircularProgressIndicator()
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderText() {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 500),
    child: _connectionEstablished
        ? const Text(
            "Connected to HC-05",
            key:  ValueKey("connect_text"),
            style:  TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'CrimsonText',
            ),
          )
        : const Text(""),
  );
}

Widget _buildConnectingText() {
  if (!_connectionEstablished) {
    // Display "Connecting to HC-05..." with loading indicator
    return const Column(
      children: [
        Text(
          "Connecting to HC-05...",
          key:  ValueKey("connecting_text"),
          style:  TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'CrimsonText',
          ),
        ),
         SizedBox(height: 20),
         CircularProgressIndicator(),
      ],
    );
  } else {
    // Display "Connected to HC-05" after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _connectionEstablished = true;
      });
    });
    return const AnimatedSwitcher(
      duration:  Duration(milliseconds: 500),
      child:  Text(
        "Connected to HC-05",
        key:  ValueKey("connect_text"),
        style:  TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'CrimsonText',
        ),
      ),
    );
  }
}
}