import 'package:flutter/material.dart';
import 'package:geo_3er_parcial/controllers/data_controller.dart';
import 'package:geo_3er_parcial/controllers/shared_prefs.dart';
import 'package:geo_3er_parcial/screens/home_screen.dart';
import 'package:geo_3er_parcial/services/api_services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:geolocator/geolocator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _prefs = SharedPrefs();
  //final _controller = Get.put(DataController());
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

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
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
