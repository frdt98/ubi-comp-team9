import 'package:bus_stop_app/components/station_dropdown.dart';
import 'package:bus_stop_app/location_controller.dart';
import 'package:bus_stop_app/speech_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocationController, SpeechController>(
        builder: (context, locationController, speechController, child) {
      if (locationController.inRadius && !(speechController.detected)) {
        speechController.listen();
      }
      final TextTheme textTheme = Theme.of(context).textTheme;

      return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: speechController.detected
                ? Center(
                    child: Text(
                    "You have reached your destination",
                    style: textTheme.headline4,
                    textAlign: TextAlign.center,
                  ))
                : (!speechController.available ||
                        !locationController.serviceEnabled)
                    ? Center(
                        child: TextButton(
                            onPressed: () {
                              if (!locationController.serviceEnabled) {
                                locationController.initLocation();
                              }
                              if (!speechController.available) {
                                speechController.initSpeech();
                              }
                            },
                            child: Text("Initialize application")),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(
                              "Choose your destination:",
                              style: textTheme.headline5!
                                  .copyWith(color: Colors.blueGrey),
                            ),
                            const SizedBox(height: 15),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 100),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: StationDropdown(
                                      onChanged: (value) {
                                        locationController.station = value;
                                        speechController.station = value;
                                      },
                                      value: locationController.station,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
          ),
        )),
      );
    });
  }
}
