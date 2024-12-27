import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _GameScreenState();
}

class _GameScreenState extends State<Start> with SingleTickerProviderStateMixin {
  Shooter shooter = Shooter(currentPosition: Offset(0, 0), isGoingRight: true);
  Bullet fakeBullet = Bullet(currentPosition: Offset(0, 0));
  Missile? missile;
  Bullet? realBullet;
  int size = 0;
  late Size screenSize;

  bool isConflicted = false;
  Offset? position;
  late AnimationController _controller;

  late Timer missileTimer;
  late Timer bulletTimer;
  late Timer gameUpdateTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((t) {
      screenSize = MediaQuery.of(context).size;
      size = MediaQuery.of(context).size.width.toInt();
      setState(() {});
      print("Size = ${size}");
    });

    _controller = AnimationController(vsync: this, duration: Duration(microseconds: 800));

    // Start the game logic
    check();
    initiateJet();
    initiateMissile();
    initiateBulletFire();
  }

  // Clean up the timers and other resources when objects are null
  @override
  void dispose() {
    // Cancel all active timers to prevent memory leaks
    missileTimer.cancel();
    bulletTimer.cancel();
    gameUpdateTimer.cancel();

    // Dispose of the animation controller
    _controller.dispose();

    super.dispose();
  }

  // Periodic checks
  void check() {
    gameUpdateTimer = Timer.periodic(Duration(milliseconds: 30), (t) => updateCurrentScreen());
  }

  // Jet movement and periodic updates
  void initiateJet() {
    Timer.periodic(Duration(milliseconds: 50), (t) => updateJetLocation());
  }

  // Bullet firing and periodic updates
  void initiateBulletFire() {
    realBullet = Bullet(currentPosition: Offset(fakeBullet.currentPosition.dx, fakeBullet.currentPosition.dy));
    bulletTimer = Timer.periodic(Duration(milliseconds: 30), (t) => updateBulletLocation());
  }

  // Missile initiation and movement updates
  void initiateMissile() {
    var random = Random();
    double randomInt = random.nextInt(400).toDouble();
    missile = Missile(currentPosition: Offset(randomInt, 0));
    missileTimer = Timer.periodic(Duration(milliseconds: 30), (t) => updateMissileTarget());
  }

  // Update and reset game entities when conflict occurs
  void update() {
    setState(() {
      position = null;
    });
  }

  // Logic for checking when the missile and bullet collide
  void updateCurrentScreen() {
    if (missile != null && realBullet != null) {
      double dX = (missile!.currentPosition.dx - realBullet!.currentPosition.dx);
      double dY = (missile!.currentPosition.dy - realBullet!.currentPosition.dy);

      dX *= dX;
      dY *= dY;
      double distance = sqrt(dX + dY);

      if (distance <= 40 && realBullet!.currentPosition.dy > 15) {
        position = Offset(missile!.currentPosition.dx, missile!.currentPosition.dy);
        missile = null;
        realBullet = null;

        // Reset the game state after a delay
        Timer.periodic(Duration(milliseconds: 800), (t) => update());
      }
    }
    setState(() {});
  }

  // Missile movement and target updates
  void updateMissileTarget() {
    if (missile != null) {
      double y = missile!.currentPosition.dy + 15;
      missile!.currentPosition = Offset(missile!.currentPosition.dx, y);

      if (y + 15 > screenSize.height) {
        double dX = (missile!.currentPosition.dx - shooter.currentPosition.dx);
        if (dX.abs() <= 15) {
          isConflicted = true;
        } else {
          missile = null; // Cleanup missile when off-screen or no longer needed
        }
      }
    } else {
      var random = Random();
      double randomInt = random.nextInt(400).toDouble();
      missile = Missile(currentPosition: Offset(randomInt, shooter.currentPosition.dy));
    }
    setState(() {});
  }

  // Bullet movement and cleanup
  void updateBulletLocation() {
    if (realBullet != null) {
      double y = realBullet!.currentPosition.dy - 15;
      realBullet!.currentPosition = Offset(realBullet!.currentPosition.dx, y);

      if (y < -5) {
        realBullet = null; // Bullet goes off-screen, cleanup
      }
    } else {
      realBullet = Bullet(currentPosition: Offset(fakeBullet.currentPosition.dx, fakeBullet.currentPosition.dy));
    }
    setState(() {});
  }

  // Jet movement
  void updateJetLocation() {
    if (shooter.isGoingRight) {
      double x = shooter.currentPosition.dx + 10;
      if (x < (screenSize.width - 70)) {
        shooter.currentPosition = Offset(x, shooter.currentPosition.dy);
      } else {
        shooter.isGoingRight = false;
      }
    } else {
      double x = shooter.currentPosition.dx - 10;
      if (x > 0) {
        shooter.currentPosition = Offset(x, shooter.currentPosition.dy);
      } else {
        shooter.isGoingRight = true;
      }
    }

    fakeBullet.currentPosition =
        Offset(shooter.currentPosition.dx + 32.5, shooter.currentPosition.dy + screenSize.height * .9);

    setState(() {});
  }

  // Handle position reset after blast animation
  void nullPosition() {
    WidgetsBinding.instance.addPostFrameCallback((t) {
      setState(() {
        position = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: isConflicted
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Game Over",
            style: TextStyle(color: Colors.red, fontSize: 35, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: h / 15,
                width: w / 2,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(
                  child: Text(
                    "Exit",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),
                  ),
                ),
              ),
            ),
          ),
        ],
      )
          : Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.1,
              widthFactor: 1.0,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  child: Stack(
                    children: [
                      Positioned(
                        left: shooter.currentPosition.dx,
                        top: shooter.currentPosition.dy,
                        child: Column(
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                            ),
                            Icon(
                              Icons.airplanemode_active,
                              size: 70,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: fakeBullet.currentPosition.dx,
            top: fakeBullet.currentPosition.dy,
            child: Column(
              children: [
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              ],
            ),
          ),
          if (realBullet != null)
            Positioned(
              left: realBullet!.currentPosition.dx,
              top: realBullet!.currentPosition.dy,
              child: Column(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  ),
                ],
              ),
            ),
          if (missile != null)
            Positioned(
              left: missile!.currentPosition.dx,
              top: missile!.currentPosition.dy,
              child: Icon(
                Icons.rocket_launch_rounded,
                color: Colors.red,
                size: 25,
              ),
            ),
          if (position != null)
            Positioned(
              left: position!.dx,
              top: position!.dy,
              child: Lottie.asset(
                'assets/Lottie/blast.json',
                height: 50,
                width: 50,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();

                  // Call cleanup after animation is finished
                  //Timer(Duration(milliseconds: 500), nullPosition);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class Shooter {
  Offset currentPosition;
  bool isGoingRight;

  Shooter({required this.currentPosition, required this.isGoingRight});
}

class Bullet {
  Offset currentPosition;

  Bullet({required this.currentPosition});
}

class Missile {
  Offset currentPosition;

  Missile({required this.currentPosition});
}
