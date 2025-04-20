import 'dart:async';
import 'package:algorithm/onboard.dart';
import 'package:flutter/material.dart';


class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: const Stack(
          children: [
            Positioned.fill(
              child: Image(
                image: AssetImage("lib/assets/h.png"),
                fit: BoxFit.contain,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome to 👋",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "BlackHat",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "The best of the best team!",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Color.fromARGB(220, 255, 255, 255),
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 66),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
