import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:weather/Screens/loading_screen.dart';
import 'package:weather/theme.dart';

// @dart=2.9
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      theme: themeData(context),
      darkTheme: darkThemeData(context),
      themeMode: ThemeMode.dark,
      home: const LoadingScreen(),
    );
  }
}
