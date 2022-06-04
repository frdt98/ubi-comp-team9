import 'package:bus_stop_app/location_controller.dart';
import 'package:bus_stop_app/screens/main_screen.dart';
import 'package:bus_stop_app/screens/splash_screen.dart';
import 'package:bus_stop_app/speech_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocationController()),
        ChangeNotifierProvider(create: (context) => SpeechController()),
      ],
      child: MaterialApp(
        color: const Color.fromRGBO(85, 182, 215, 1),
        title: 'Flutter Demo',
        theme: ThemeData(
          backgroundColor: const Color.fromRGBO(85, 182, 215, 100),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
