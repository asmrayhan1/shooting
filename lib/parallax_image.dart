import 'package:flutter/material.dart';

class ParallaxImage extends StatefulWidget {
  final String imageUrl;
  final double speed;

  const ParallaxImage({
    Key? key,
    required this.imageUrl,
    this.speed = 50.0, // Speed of the animation
  }) : super(key: key);

  @override
  _ParallaxImageState createState() => _ParallaxImageState();
}

class _ParallaxImageState extends State<ParallaxImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: (100 / widget.speed).round()), // Speed control
    )..repeat();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children: [
            Transform.translate(
              offset: Offset(0, screenHeight * (_animation.value - 1)),
              child: Image.asset(
                widget.imageUrl,
                fit: BoxFit.cover,
                height: screenHeight * 2, // Double the height of the screen
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Transform.translate(
              offset: Offset(0, screenHeight * _animation.value),
              child: Image.asset(
                widget.imageUrl,
                fit: BoxFit.cover,
                height: screenHeight * 2,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ],
        );
      },
    );
  }
}