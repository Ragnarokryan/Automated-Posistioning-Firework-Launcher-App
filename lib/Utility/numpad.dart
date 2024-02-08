import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeP(),
      theme: ThemeData(primarySwatch: Colors.red),
    );
  }
}

class HomeP extends StatefulWidget {
  const HomeP({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomeP> {
  String input = "";
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
              'Entered angle: $input',
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
                  input = value;
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
                  input = _angleController.text;
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