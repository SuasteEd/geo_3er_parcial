import 'package:flutter/material.dart';
import 'package:geo_3er_parcial/routes/app_routes.dart';
import 'package:geo_3er_parcial/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  // final apiService = ApiService();
  // final dataRepository = DataRepository(apiService);
  //Get.put(dataRepository); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.initialRoute,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      theme: AppTheme.ligthTheme,
    );
  }
}
