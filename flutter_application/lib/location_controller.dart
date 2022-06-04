import 'dart:async';
import 'dart:math';

import 'package:bus_stop_app/constants/stations.dart';
import 'package:bus_stop_app/screens/main_screen.dart';
import 'package:bus_stop_app/speech_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as Geolocation;

class LocationController extends ChangeNotifier {
  final Location location = Location();
  bool serviceEnabled = false;
  late PermissionStatus _permissionGranted;
  String? _station;
  bool _inRadius = false;
  late StreamSubscription<LocationData> locationSubscription;

  bool get inRadius {
    return _inRadius;
  }

  String? get station {
    return _station;
  }

  setStation(String? value, SpeechController speechController) {
    locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) {
      currentLocation.longitude;
      currentLocation.latitude;

      final distance = Geolocation.Geolocator.distanceBetween(
          stationLocations[_station]!["lat"]!,
          stationLocations[_station]!["long"]!,
          currentLocation.latitude!,
          currentLocation.longitude!);
      print(distance);
      if (distance < 2000000) {
        speechController.listen();
      }
    });
    _station = value;

    notifyListeners();
  }

  initLocationAndSpeech(
      SpeechController speechController, BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    serviceEnabled = await location.serviceEnabled();
    await speechController.initSpeech();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    notifyListeners();
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    await location.changeSettings(accuracy: LocationAccuracy.high);

    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (
          BuildContext context,
        ) =>
            const MainScreen(),
      ),
    );
  }
}
