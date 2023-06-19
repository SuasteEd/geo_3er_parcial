import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/screens.dart';

class AppRoutes {
  static const initialRoute = '/';

  static Map<String, Widget Function(BuildContext)> routes = {
    '/' : (_) => const SplashScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const HomeScreen());
  }
}