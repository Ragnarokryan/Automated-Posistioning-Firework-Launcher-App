import 'dart:async';
import 'dart:convert';
import '../Screens/animation_firework.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';


class PositioningScreen extends StatefulWidget {
  final BluetoothConnection? connection;
  const PositioningScreen({super.key, required this.connection});

  @override
  State<PositioningScreen> createState() => _PositioningScreenState();
}

class _PositioningScreenState extends State<PositioningScreen> {
  BluetoothConnection? _connection;
  final TextEditingController angleController1 = TextEditingController();
  final TextEditingController angleController2 = TextEditingController();
  final TextEditingController angleController3 = TextEditingController();
  final TextEditingController angleController4 = TextEditingController();
  late StreamSubscription<Uint8List> _dataReceivedSubscription;
  String? _angle1;
  String? _angle2;
  String? _angle3;
  String? _angle4;
  String? _actualAngle1;
  String? _actualAngle2;
  String? _actualAngle3;
  String? _actualAngle4;

  // State variable to keep track of angles set
  int anglesSet = 0;


  @override
  void initState() {
    super.initState();
  _sendDataToDevice("6");
    //Listen for incoming data from the Bluetooth connection
    _dataReceivedSubscription = widget.connection!.input!.listen((data) {
      // Decode the data as a UTF-8 string
      String decodedData = utf8.decode(data);
      // Process the received data
      _processReceivedData(decodedData);
    });
  }

  @override
  void dispose() {
    _dataReceivedSubscription.cancel();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.transparent,
    body: Stack(
      children: [
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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                // Conditionally display the message and counter
                if (!_allAnglesSet())
                  Text(
                    'Please enter angles for all mortars.\n$anglesSet of 4 set',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'CrimsonText',
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 16),

                // Build buttons with angle inputs
                _buildButtonWithAngleInput(
                  'Set Angle for Mortar A',
                  angleController1,
                  '1',
                  _angle1,
                  _actualAngle1,
                ),
                _buildButtonWithAngleInput(
                  'Set Angle for Mortar B',
                  angleController2,
                  '2',
                  _angle2,
                  _actualAngle2,
                ),
                _buildButtonWithAngleInput(
                  'Set Angle for Mortar C',
                  angleController3,
                  '3',
                  _angle3,
                  _actualAngle3,
                ),
                _buildButtonWithAngleInput(
                  'Set Angle for Mortar D',
                  angleController4,
                  '4',
                  _angle4,
                  _actualAngle4,
                ),
                const SizedBox(height: 16),

                // Other UI components
                _buildAuto90SetButton(),
              ],
            ),
          ],
        ),
    );
  }
  

// Add a method to check if all angles have been set via the button inputs.
  bool _allAnglesSet() {
    // Check if all angles have been set (4 in total).
    // Ensure the angles are set only via button inputs.
    return anglesSet == 4;
  }

  void _sendDataToDevice(String data) {
    widget.connection?.output.add(Uint8List.fromList(utf8.encode(data)));
    debugPrint("Sending data to device: $data");
    widget.connection?.output.allSent.then((_) {
      debugPrint("Data sent: $data");
    });
  }

  void _processReceivedData(String receivedData) {
    // Remove any non-numeric or special characters (e.g., newline)
    receivedData = receivedData.replaceAll(RegExp(r'[^0-9]'), '');

    // Process the received data in chunks of 3 digits
    for (int i = 0; i < receivedData.length; i += 3) {
      // Determine the servo index (1-4) based on the position of the chunk
      int servoIndex = (i ~/ 3) + 1;
      if (servoIndex > 4) break; // We only have 4 servos

      // Extract the 3-digit angle value from the chunk
      String angleChunk = receivedData.substring(i, i + 3);

      // Convert the angleChunk to an integer and back to a string to remove leading zeros
      int angleValue = int.parse(angleChunk);
      String formattedAngle = angleValue.toString();

      // Update the appropriate actual angle state variable for each servo
      setState(() {
        switch (servoIndex) {
          case 1:
            _actualAngle1 = formattedAngle;
            break;
          case 2:
            _actualAngle2 = formattedAngle;
            break;
          case 3:
            _actualAngle3 = formattedAngle;
            break;
          case 4:
            _actualAngle4 = formattedAngle;
            break;
        }
      });
    }
  }

  Future<void> _sendAngleToDevice(int servo, String angle) async {
    switch (servo) {
      case 1:
        setState(() {
          _angle1 = angle;
        });
        break;
      case 2:
        setState(() {
          _angle2 = angle;
        });
        break;
      case 3:
        setState(() {
          _angle3 = angle;
        });
        break;
      case 4:
        setState(() {
          _angle4 = angle;
        });
        break;
      default:
        // Handle invalid servo numbers here
        break;
    }

    try {
      if (_connection != null && _connection!.isConnected) {
        // Show success message on successful transmission
        //_showTransmissionSuccessSnackbar();
        debugPrint('Active Bluetooth connection');
      } else {
        // Handle the case where the connection is not established
        debugPrint('No active Bluetooth connection');
      }
    } on PlatformException catch (e) {
      // Handle platform exceptions here
      debugPrint("Error: $e");
    }

    // Update anglesSet count and data to send to device
    setState(() {
      anglesSet++;
    });
    String dataToSend = '$servo$angle';
    _sendDataToDevice(dataToSend);
  }

  Future<void> _showAngleInputDialog(
      TextEditingController controller, String servo) async {
    String? enteredAngle; // Store the entered angle
    String? enteredAngleError; // Store the error message

    // Show dialog to input angle
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Enter Angle between 60 to 120'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    decoration: InputDecoration(
                      hintText: '',
                      errorText: enteredAngleError,
                    ),
                    onChanged: (value) {
                      // Update the entered angle
                      enteredAngle = value;
                      int angle = int.tryParse(value) ?? 0;
                      if (angle < 60 || angle > 120) {
                        setState(() {
                          enteredAngleError =
                              'Invalid angle. Enter angle between 60 and 120.';
                        });
                      } else {
                        setState(() {
                          enteredAngleError = null;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    if (_validateAngle(controller.text)) {
                      Navigator.of(context).pop(enteredAngle);
                      setState(() {
                        // Update the angle state variable here
                        switch (servo) {
                          case '1':
                            _angle1 = enteredAngle;
                            break;
                          case '2':
                            _angle2 = enteredAngle;
                            break;
                          case '3':
                            _angle3 = enteredAngle;
                            break;
                          case '4':
                            _angle4 = enteredAngle;
                            break;
                        }
                      });
                      _sendDataToDevice('$servo$enteredAngle');
                      // Update anglesSet counter when an angle is set
                      setState(() {
                        anglesSet++;
                      });
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((result) {
      // Clear the text field
      controller.clear();
      // Clear the error message
      setState(() {
        enteredAngleError = null;
      });
    });
  }

  bool _validateAngle(String value) {
    if (value.isEmpty) {
      return false;
    }
    int angle = int.tryParse(value) ?? 0;
    return angle >=60 && angle <= 120;
  }

  Widget _buildButtonWithAngleInput(
    String buttonText,
    TextEditingController controller,
    String servo,
    String? inputAngle,
    String? actualAngle,
  ) {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                await _showAngleInputDialog(controller, servo);
              },
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontFamily: 'CrimsonText',
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Input Angle: ${inputAngle != null ? '$inputAngle°' : ''}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 63, 194, 255),
                    fontFamily: 'CrimsonText',
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Actual Angle: ${actualAngle != null ? '$actualAngle°' : ''}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 227, 56, 53),
                    fontFamily: 'CrimsonText',
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildAuto90SetButton() {
    return ElevatedButton(
      onPressed: () {
        // Clear all angle controllers and set the angles to 90
        angleController1.clear();
        angleController2.clear();
        angleController3.clear();
        angleController4.clear();
        // Send 90 degrees to all servos
        _sendAngleToDevice(1, '90');
        _sendAngleToDevice(2, '90');
        _sendAngleToDevice(3, '90');
        _sendAngleToDevice(4, '90');
        // Reset anglesSet counter to 4 since all angles will be set to 90
        setState(() {
          anglesSet = 4;
        });
      },
      child: const Text('Auto 90 Set',
          style: TextStyle(
            fontFamily: 'CrimsonText',
            fontSize: 20,
          )),
    );
  }
}
