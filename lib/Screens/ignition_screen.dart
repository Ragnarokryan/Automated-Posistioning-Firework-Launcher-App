//import 'package:bluetooth_classic_example/Screens/connection_page.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
//import 'package:provider/provider.dart';
import '../Screens/animation_firework.dart';

class IgnitionScreen extends StatelessWidget {
  final BluetoothConnection connection;
  const IgnitionScreen({super.key, required this.connection});

  @override
  Widget build(BuildContext context) {
    // Remove 'const' from the MaterialApp definition
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IgnitionScreenApp(connection: connection),
    );
  }
}

class IgnitionScreenApp extends StatefulWidget {
  final BluetoothConnection connection;
  const IgnitionScreenApp({super.key, required this.connection});

  @override
  State<IgnitionScreenApp> createState() => _IgnitionScreenState();
}

class _IgnitionScreenState extends State<IgnitionScreenApp> {
  late BluetoothConnection connection;
  TextEditingController delayController = TextEditingController();
  TextEditingController mortarController = TextEditingController();
  TextEditingController secondMortarController = TextEditingController();
  TextEditingController thirdMortarController = TextEditingController();
  TextEditingController fourthMortarController = TextEditingController();
  TextEditingController secondDelayController = TextEditingController();
  TextEditingController thirdDelayController = TextEditingController();
  TextEditingController fourthDelayController = TextEditingController();
  StreamSubscription<Uint8List>? dataReceivedSubscription;
  String receivedData = "";
  bool isCustomSequenceSet = false;
  final List<String> availableMortars = ['A', 'B', 'C', 'D'];

  // Track selected mortars
  String? firstMortar;
  String? secondMortar;
  String? thirdMortar;
  String? fourthMortar;

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with initial values if needed
    delayController.text = '0';
    secondDelayController.text = '0';
    thirdDelayController.text = '0';
    fourthDelayController.text = '0';
    _resetIgnitionPage();
  }

  // void _sendCustomSequenceToDevice() {
  //   // Retrieve user input from TextEditingController instances
  //   int initialDelay = int.tryParse(delayController.text) ?? 0;
  //   String firstMortar = mortarController.text.toUpperCase();
  //   String secondMortar = secondMortarController.text.toUpperCase();
  //   String thirdMortar = thirdMortarController.text.toUpperCase();
  //   String fourthMortar = fourthMortarController.text.toUpperCase();

  //   int secondDelay = int.tryParse(secondDelayController.text) ?? 0;
  //   int thirdDelay = int.tryParse(thirdDelayController.text) ?? 0;
  //   int fourthDelay = int.tryParse(fourthDelayController.text) ?? 0;

  //   // Construct the data packet in the specified order: Initial Delay, 1st Mortar,
  //   // Second Delay, 2nd Mortar, Third Delay, 3rd Mortar, Fourth Delay, 4th Mortar
  //   String dataToSend = '$initialDelay,$firstMortar,$secondDelay,$secondMortar,'
  //       '$thirdDelay,$thirdMortar,$fourthDelay,$fourthMortar';

  //   // Transmit the data packet over the Bluetooth connection
  //   _sendDataToDevice(dataToSend);
  // }

  void _sendDataToDevice(String data) {
    widget.connection.output.add(Uint8List.fromList(utf8.encode(data)));
    debugPrint("Sending data to device: $data");
    widget.connection.output.allSent.then((_) {
      debugPrint("Data sent: $data");
    });
  }

  // Initialization of buttonPressed map with default values
  Map<String, bool> buttonPressed = {
    'A': false,
    'B': false,
    'C': false,
    'D': false,
  };
  
  int firedMortarsCount = 0;

  Future<void> _resetIgnitionPage() async {
    setState(() {
      if(firedMortarsCount == 4){
      firedMortarsCount = 0;
      buttonPressed = {
        'A': false,
        'B': false,
        'C': false,
        'D': false,
      };
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            //key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            body: Stack(children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Night_sky.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
              const Positioned.fill(
                child: FireworksAnimation(),
              ),
              Center(
                // Wrap the Column with Center widget
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                'Individually Fired Mortars: $firedMortarsCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
                    FilledButton(
                onPressed: buttonPressed['A']!
                    ? null
                    : () {
                        setState(() {
                          buttonPressed['A'] = true;
                          _sendDataToDevice('A');
                          firedMortarsCount++;
                          _resetIgnitionPage();
                        });
                      },
                style: FilledButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  backgroundColor: buttonPressed['A'] == true 
                  ? Colors.red[100] 
                  : Colors.red[800],
                ),
                child: const Text(
                  'Fire A',
                  style: TextStyle(fontFamily: 'CrimsonText'),
                ),
              ),
                    const SizedBox(height: 10),
                    FilledButton(
                      onPressed: buttonPressed['B']!
                    ? null
                    : () {
                        setState(() {
                          buttonPressed['B'] = true;
                          _sendDataToDevice('B');
                          firedMortarsCount++;
                          _resetIgnitionPage();
                        });
                      },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(200, 50),
                        backgroundColor: buttonPressed['B'] == true
                            ? Colors.red[100]
                            : Colors.red[800],
                      ),
                      child: const Text('Fire B',
                          style: TextStyle(fontFamily: 'CrimsonText')),
                    ),
                    const SizedBox(height: 10),
                    FilledButton(
                      onPressed: buttonPressed['C']!
                    ? null
                    : () {
                        setState(() {
                          buttonPressed['C'] = true;
                          _sendDataToDevice('C');
                          firedMortarsCount++;
                          _resetIgnitionPage();
                        });
                      },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(200, 50),
                        backgroundColor: buttonPressed['C'] == true
                            ? Colors.red[100]
                            : Colors.red[800],
                      ),
                      child: const Text('Fire C',
                          style: TextStyle(fontFamily: 'CrimsonText')),
                    ),
                    const SizedBox(height: 10),
                    FilledButton(
                      onPressed: buttonPressed['D']!
                    ? null
                    : () {
                        setState(() {
                          buttonPressed['D'] = true;
                          _sendDataToDevice('D');
                          firedMortarsCount++;
                          _resetIgnitionPage();
                        });
                      },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(200, 50),
                        backgroundColor: buttonPressed['D'] == true
                            ? Colors.red[100]
                            : Colors.red[800],
                      ),
                      child: const Text('Fire D',
                          style: TextStyle(fontFamily: 'CrimsonText')),
                    ),
                  ],
                ),
              )
            ]),
    ));
  }
}

  // Widget _buildFireButton() {
  //   // Check the condition and return the appropriate button
  //   if (isCustomSequenceSet) {
  //     // Return a FilledButton with red color when isCustomSequenceSet is true
  //     return FilledButton(
  //       onPressed: () {
  //         // Implement fire button logic
  //         _sendCustomSequenceToDevice();
  //       },
  //       style: FilledButton.styleFrom(
  //         minimumSize: const Size(200, 50),
  //         backgroundColor: Colors.red, // Red color when true
  //       ),
  //       child: const Text(
  //         'Fire',
  //         style: TextStyle(
  //           fontFamily: 'CrimsonText',
  //           fontSize: 20,
  //           color: Colors.blue,
  //         ),
  //       ),
  //     );

  //   } else {
  //     // Return a FilledButton.tonal with light red color when isCustomSequenceSet is false
  //     return FilledButton.tonal(
  //       onPressed: () {
  //         // Implement fire button logic
  //         _sendDataToDevice('FIRE_DEFAULT');
  //       },
  //       style: ButtonStyle(
  //         minimumSize: MaterialStateProperty.all(const Size(200, 50)),
  //         backgroundColor: MaterialStateProperty.all(
  //             Colors.red[100]), // Light red color when false
  //       ),
  //       child: const Text(
  //         'Fire',
  //         style: TextStyle(
  //           fontFamily: 'CrimsonText',
  //           fontSize: 20,
  //           color: Colors.blue,
  //         ),
  //       ),
  //     );
  //   }
  // }

// Helper method to build mortar and delay fields
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Widget _buildMortarAndDelayField(String labelText,
  //     TextEditingController mortarController, String? selectedMortar) {
  //   // List of available mortars excluding the selected one
  //   List<String> updatedAvailableMortars = List.from(availableMortars);
  //   if (selectedMortar != null) {
  //     updatedAvailableMortars.remove(selectedMortar);
  //   }

  //   return Column(
  //     children: [
  //       const SizedBox(height: 8),
  //       if (labelText == '1st Mortar:') // Conditionally add delay field
  //         ...[
  //         DropdownButtonFormField<String>(
  //           value: '0',
  //           onChanged: (String? newValue) {
  //             setState(() {
  //               delayController.text = newValue!;
  //             });
  //           },
  //           decoration: const InputDecoration(
  //             labelText: 'Initial Delay: 0-3 seconds',
  //           ),
  //           items: ['0', '1', '2', '3'].map((String value) {
  //             return DropdownMenuItem<String>(
  //               value: value,
  //               child: Text(value),
  //             );
  //           }).toList(),
  //         ),
  //         const SizedBox(height: 8),
  //       ],
  //       DropdownButtonFormField<String>(
  //         value: selectedMortar,
  //         onChanged: (String? newValue) {
  //           if (newValue != null) {
  //             updatedAvailableMortars.add(newValue);
  //           }
  //           setState(() {
  //             mortarController.text = newValue!;
  //           });
  //         },
  //         decoration: InputDecoration(
  //           labelText: labelText,
  //         ),
  //         items: updatedAvailableMortars.map((String mortar) {
  //           return DropdownMenuItem<String>(
  //             value: mortar,
  //             child: Text(mortar),
  //           );
  //         }).toList(),
  //       ),
  //       if (labelText != '4th Mortar:') // Conditionally add delay field
  //         ...[
  //         const SizedBox(height: 8),
  //         DropdownButtonFormField<String>(
  //           value: '0',
  //           onChanged: (String? newValue) {
  //             setState(() {
  //               delayController.text = newValue!;
  //             });
  //           },
  //           decoration: const InputDecoration(
  //             labelText: 'Delay: 0-3 seconds',
  //           ),
  //           items: ['0', '1', '2', '3'].map((String value) {
  //             return DropdownMenuItem<String>(
  //               value: value,
  //               child: Text(value),
  //             );
  //           }).toList(),
  //         ),
  //       ],
  //     ],
  //   );
  // }
