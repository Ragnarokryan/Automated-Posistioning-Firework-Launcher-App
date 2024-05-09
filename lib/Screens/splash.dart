import 'package:flutter/material.dart';
import 'package:myapp/Screens/second_screen.dart';
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
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const BottomNavigationBarExampleApp()));
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
      fontSize: 50.0,
      fontFamily: 'RaleWay',
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('lib/assets/1_Firework.jpg', fit: BoxFit.cover),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  //width: 1000.0,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'Automated Positioning Firework Launcher',
                        textAlign: TextAlign.center,
                        textStyle: colorizeTextStyle,
                        colors: colorizeColors,
                      ),
                    ],
                    isRepeatingAnimation: true,
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Image.asset(
                    'lib/assets/Mortar.png',
                    width: 430,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}