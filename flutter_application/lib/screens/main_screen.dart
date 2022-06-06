import 'package:bus_stop_app/components/station_dropdown.dart';
import 'package:bus_stop_app/location_controller.dart';
import 'package:bus_stop_app/screens/map_screen.dart';
import 'package:bus_stop_app/speech_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocationController, SpeechController>(
        builder: (context, locationController, speechController, child) {
      return Scaffold(
        backgroundColor: const Color.fromRGBO(85, 182, 215, 1),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StationDropdown(
                    onChanged: (value) {
                      locationController.setStation(value, speechController);
                      speechController.station = value;
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (
                            BuildContext context,
                          ) =>
                              const MapScreen(),
                        ),
                      );
                    },
                    value: locationController.station,
                  ),
                ]),
          ),
        ),
      );
    });
  }
}
