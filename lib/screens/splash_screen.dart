import 'package:flutter/material.dart';
import 'package:geo_3er_parcial/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    Future.delayed(const Duration(seconds: 2), () async {
      Get.off(() => const HomeScreen(),
          transition: Transition.circularReveal,
          duration: const Duration(seconds: 2));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/splash.png'),
                  fit: BoxFit.cover),
            ),
            child: LottieBuilder.asset('assets/json/earth.json')),
      ),
    );
  }
}
