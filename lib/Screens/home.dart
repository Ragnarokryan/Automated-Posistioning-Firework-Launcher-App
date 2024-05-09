import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/Utility/anglebttn.dart';

void main() => runApp(const HomeScreen());
String enteredAngle ="";
class AngleWidget extends State<HomePage> {
  //String enteredAngle = "";
  final int maxDigits = 3;
  final TextEditingController _angleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _showAngleInputDialog(context);
              },
              child: const Text('Angle'),
            ),
            const SizedBox(height: 20),
            Text(
              'Entered angle: $enteredAngle',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

Future<void> _showAngleInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Angle'),
          content: TextField(
            controller: _angleController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            maxLength: maxDigits,
            onChanged: (value) {
              if (value.length <= maxDigits) {
                setState(() {
                  enteredAngle = value;
                });
              }
            },
            decoration: const InputDecoration(
              labelText: "Angle between 30 - 150",
              counterText: "",
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _angleController.clear();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  enteredAngle = _angleController.text;
                });
                _angleController.clear();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Something'),
         ),
         body: Text('Angle: $enteredAngle', 
         style: const TextStyle(fontSize: 18)),
          ),
      );
  }
}