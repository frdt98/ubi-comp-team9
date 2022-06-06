import 'package:bus_stop_app/location_controller.dart';
import 'package:bus_stop_app/screens/main_screen.dart';
import 'package:bus_stop_app/speech_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      LocationController locationController =
          Provider.of<LocationController>(context, listen: false);
      SpeechController speechController =
          Provider.of<SpeechController>(context, listen: false);
      locationController.initLocationAndSpeech(speechController, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(85, 182, 215, 1),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                textScaleFactor: 1.09,
                text: const TextSpan(
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  children: [
                    TextSpan(
                      text: "d",
                    ),
                    TextSpan(
                        text: "Stop",
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 32.0,
                          color: Color.fromARGB(255, 255, 255, 255),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
