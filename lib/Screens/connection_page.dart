// import 'dart:async';
// import 'package:bluetooth_classic_example/Screens/nav_bar.dart';
// //import 'package:bluetooth_classic_example/Screens/positioning_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:permission_handler/permission_handler.dart';

// class BluetoothApp extends StatelessWidget {
//   const BluetoothApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: BluetoothConnectionPage(),
//     );
//   }
// }

// class BluetoothConnectionPage extends StatefulWidget {
//   const BluetoothConnectionPage({Key? key}) : super(key: key);

//   @override
//   State<BluetoothConnectionPage> createState() =>
//       _BluetoothConnectionPageState();
// }

// class _BluetoothConnectionPageState extends State<BluetoothConnectionPage> {
//   bool scanning = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeBluetooth();
//   }

//   Future<void> _initializeBluetooth() async {
//     // Request necessary permissions
//     Map<Permission, PermissionStatus> statuses = await [
//       Permission.bluetooth,
//       Permission.location,
//     ].request();

//     // Check if permissions are granted
//     if (statuses[Permission.bluetooth] != PermissionStatus.granted ||
//         statuses[Permission.location] != PermissionStatus.granted) {
//       // Permissions not granted, handle accordingly
//       // For example, show a message to the user or request permissions again
//     } else {
//       // Permissions granted, proceed with Bluetooth operations
//       scanDevices();
//     }
//   }

//   Future<void> scanDevices() async {
//     setState(() {
//       scanning = true;
//     });

//     // Start listening for discovered devices
//     FlutterBluetoothSerial.instance.startDiscovery().listen(
//       (BluetoothDiscoveryResult r) async {
//         if (r.device.address == "98:D3:02:96:98:D7") {
//           // Found the HC-05 device, stop scanning
//           await FlutterBluetoothSerial.instance.cancelDiscovery();

//           // Connect to the HC-05 device
//           await connectToDevice();
//         }
//       },
//       onError: (dynamic error) {
//         debugPrint('Error during discovery: $error');
//       },
//       onDone: () {
//         // Scanning is complete
//         setState(() {
//           scanning = false;
//         });
//       },
//     );
//   }

// Future<BluetoothConnection?> connectToDevice() async {
//   try {
//     final connection = await BluetoothConnection.toAddress("98:D3:02:96:98:D7");
//     if (connection.isConnected) {
//       // Push BottomNavigationBarExample onto navigation stack
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => BottomNavigationBarExample(connection: connection)));
//       return connection; // Return the connection object
//     } else {
//       return null;
//     }
//   } catch (e) {
//     debugPrint('Error connecting to device: $e');
//     return null; // Handle connection error here
//   }
// }

// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const SizedBox(height: 20),
//           Expanded(
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 Container(
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         Color(0xFF64B5F6), // Light ocean blue
//                         Color.fromARGB(210, 24, 14, 165), // Dark ocean blue
//                       ],
//                     ),
//                   ),
//                   width: MediaQuery.of(context).size.width,
//                   height: MediaQuery.of(context).size.height,
//                 ),
//                 Positioned(
//                   top: 50,
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Center(
//                       child: AnimatedSwitcher(
//                         duration: const Duration(milliseconds: 500),
//                         child: scanning
//                             ? _buildConnectingText()
//                             : _buildHeaderText(),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Center(
//                   child: Icon(
//                     Icons.bluetooth,
//                     size: 100,
//                     color: Colors.white,
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 20,
//                   child: scanning
//                       ? const CircularProgressIndicator()
//                       : const SizedBox.shrink(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeaderText() {
//     return const Text(
//       "Connected to HC-05",
//       key: ValueKey("connect_text"),
//       style: TextStyle(
//         color: Colors.white,
//         fontSize: 24,
//         fontWeight: FontWeight.bold,
//         fontFamily: 'CrimsonText'
//       ),
//     );
//   }

//   Widget _buildConnectingText() {
//     return const Text(
//       "Connecting to HC-05...",
//       key: ValueKey("connecting_text"),
//       style: TextStyle(
//         color: Colors.white,
//         fontSize: 24,
//         fontWeight: FontWeight.bold,
//         fontFamily: 'CrimsonText'
//       ),
//     );
//   }
// }
