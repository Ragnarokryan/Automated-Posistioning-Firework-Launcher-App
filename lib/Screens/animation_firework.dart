import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const IgnitionScreen());
}

class IgnitionScreen extends StatelessWidget {
  const IgnitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FireworksAnimation(),
      ),
    );
  }
}

class FireworksAnimation extends StatefulWidget {
  const FireworksAnimation({super.key});

  @override
  FireworksAnimationState createState() => FireworksAnimationState();
}

class FireworksAnimationState extends State<FireworksAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Firework> _fireworks;
  static const int _numFireworks = 11;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // Create fireworks instances and pass the screen size
    _fireworks = List.generate(
      _numFireworks,
      (index) => Firework(
        controller: _controller,
        explodeTime: const Duration(seconds: 4),
        width: size.width,
        height: size.height,
      ),
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: FireworksPainter(_fireworks),
          size: size,
          // Set `isComplex` to true to enable transparency
          isComplex: true,
          // Set `willChange` to true to optimize for animations
          willChange: true,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class FireworksPainter extends CustomPainter {
  final List<Firework> fireworks;

  FireworksPainter(this.fireworks);

  @override
  void paint(Canvas canvas, Size size) {
    // Paint fireworks explosions
    for (final firework in fireworks) {
      if (firework.exploded) {
        // Paint smaller dots
        for (final dot in firework.smallerDots) {
          final smallerPaint = Paint()
            ..color = dot.color.withOpacity(dot.opacity)
            ..strokeWidth = 1.5
            ..style = PaintingStyle.fill;

          canvas.drawCircle(
              Offset(dot.currentX, dot.currentY), dot.size, smallerPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Firework {
  final AnimationController controller;
  final Duration explodeTime;
  final double width;
  final double height; // Add width and height properties
  List<Dot> smallerDots = [];
  Timer? explodeTimer;
  bool exploded = false;
  bool particleLaunched = false;
  late Particle particle;

  // Define the list of allowed colors
  final List<Color> allowedColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.amber,
    Colors.yellow,
    Colors.white,
  ];

  Firework({
    required this.controller,
    required this.explodeTime,
    required this.width, // Accept screen width
    required this.height, // Accept screen height
  }) {
    // Start the explosion timer
    explodeTimer = Timer.periodic(explodeTime, (_) {
      explode();
    });

    // Create the particle
    particle = Particle(
      controller: controller,
      explodeTime: explodeTime,
    );
  }

  void explode() {
    if (exploded) return; // Prevent multiple explosions
    exploded = true;

    // Launch the particle if not already launched
    if (!particleLaunched) {
      particle.launch();
      particleLaunched = true;
    }

    // Use the full screen size for explosion location
    final random = Random();
    final explosionX = random.nextDouble() * width; // Use the full width
    final explosionY = random.nextDouble() * height; // Use the full height

    // Fixed size for all smaller dots
    const dotSize = 1.2;

    // Generate random number of smaller dots
    final numDots = random.nextInt(20) + 70;

    // Generate smaller dots with fixed size and restricted colors
    for (int i = 0; i < numDots; i++) {
      final dot = Dot(
        x: explosionX,
        y: explosionY,
        color: allowedColors[i % allowedColors.length],
        angle: random.nextDouble() * 2 * pi,
        distance: random.nextDouble() * 20,
        size: dotSize,
        startTime: DateTime.now(),
        explodeTime: explodeTime,
      );
      smallerDots.add(dot);
    }

    // Clear smaller dots after the explode time
    Future.delayed(explodeTime, () {
      smallerDots.clear();
      exploded = false; // Reset exploded state
      particle.reset(); // Reset the particle
      particleLaunched = false;
    });
  }
}

class Particle {
  final AnimationController controller;
  final Duration explodeTime;
  late Animation<double> animation;
  double startX = 0; // Start X position (initially at the bottom of the screen)
  double startY = 0; // Start Y position (initially at the bottom of the screen)
  double endX = 0; // End X position (explosion X position)
  double endY = 0; // End Y position (explosion Y position)

  Particle({
    required this.controller,
    required this.explodeTime,
  }) {
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 1, curve: Curves.linear),
      ),
    );

    // Set the end position at the explosion point
    endX = 300; // Explosion X position (center of the screen)
    endY = 300; // Explosion Y position (center of the screen)
  }

  void launch() {
    controller.forward(from: 0); // Start the animation
  }

  void reset() {
    controller.reset(); // Reset the animation
  }

  void paint(Canvas canvas, Size size, Paint paint) {
    final currentX = lerpDouble(startX, endX, animation.value);
    final currentY = lerpDouble(startY, endY, animation.value);
    canvas.drawCircle(Offset(currentX!, currentY!), 2, paint);
  }
}

class Dot {
  final double x;
  final double y;
  final Color color;
  final double angle;
  final double distance;
  final double size;
  final DateTime startTime;
  final Duration explodeTime;

  Dot({
    required this.x,
    required this.y,
    required this.color,
    required this.angle,
    required this.distance,
    required this.size,
    required this.startTime,
    required this.explodeTime,
  });

  double get currentX =>
      x +
      distance *
          cos(angle) *
          DateTime.now().difference(startTime).inMilliseconds /
          1000;

  double get currentY =>
      y +
      distance *
          sin(angle) *
          DateTime.now().difference(startTime).inMilliseconds /
          1000;

  double get opacity {
    // Calculate opacity based on time
    final timeElapsed =
        DateTime.now().difference(startTime).inMilliseconds / 1000;
    const fadeTime = 1.5; // Time for fading effect to complete (in seconds)
    if (timeElapsed < fadeTime) {
      // Fade in effect
      return timeElapsed / fadeTime;
    } else if (timeElapsed > explodeTime.inSeconds - fadeTime) {
      // Fade out effect
      final fadeOutStartTime = explodeTime.inSeconds - timeElapsed;
      return fadeOutStartTime / fadeTime;
    } else {
      return 1.0; // Fully visible
    }
  }
}

class Star {
  final double x;
  final double y;
  final AnimationController opacityController;

  Star({
    required this.x,
    required this.y,
    required this.opacityController,
  });

  void paint(Canvas canvas) {
    final Paint paint = Paint()
      ..color = Colors.white
          .withOpacity(Curves.easeInOut.transform(opacityController.value));
    canvas.drawCircle(Offset(x, y), 1, paint);
  }
}
