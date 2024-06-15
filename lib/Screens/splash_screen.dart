import '../Screens/connection.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = const Duration(seconds: 4);
    return Timer(duration, navigateToDeviceScreen);
  }

  navigateToDeviceScreen() {
    // Navigate to the next screen without passing BluetoothConnection
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const BluetoothConnectionPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.white,
      Colors.red,
      Colors.white,
      Colors.blue,
    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 60.0,
      fontFamily: 'CrimsonText',
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/1_Firework.jpg', fit: BoxFit.cover),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 400,
                  child: DefaultTextStyle(
                    style: colorizeTextStyle,
                    child: AnimatedTextKit(
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'Automated Positioning Firework Launcher',
                          textAlign: TextAlign.center,
                          colors: colorizeColors,
                          textStyle: colorizeTextStyle,
                        ),
                      ],
                      isRepeatingAnimation: true,
                    ),
                  ),
                ),
                SizedBox(
                  width: 400,
                  child: Image.asset('assets/Mortar.png', width: 430),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
