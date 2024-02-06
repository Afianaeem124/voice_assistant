import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:voice_assistant/homeScreen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // late final AnimationController _controller;

  // @override
  // void initState() {
  //   super.initState();

  //   _controller = AnimationController(vsync: this);
  //   Timer(const Duration(seconds: 10), () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false));
  // }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(children: [
        Center(
            child: Lottie.asset(
          "hehe.json",
          fit: BoxFit.fill,
        ))
      ]),
      nextScreen: const HomeScreen(),
      splashIconSize: 400,
      backgroundColor: const Color.fromARGB(255, 142, 198, 243),
    );
  }
}
