import 'dart:async';

import 'package:bus_stop_app/constants/stations.dart';
import 'package:bus_stop_app/notification_controller.dart';
import 'package:bus_stop_app/screens/main_screen.dart';
import 'package:bus_stop_app/speech_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart' as Geolocation;
import 'package:location/location.dart';

class LocationController extends ChangeNotifier {
  final Location location = Location();
  bool serviceEnabled = false;
  late PermissionStatus _permissionGranted;
  String? _station;
  bool _inRadius = false;
  late StreamSubscription<LocationData> locationSubscription;
  bool _notified = false;
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
      if (distance < 500) {
        // locationSubscription.cancel();
        speechController.listen();
        if (distance < 50 && !_notified) {
          NotificationService().showNotification(
            1,
            "Be aware",
            "This might be your destination!",
          );
          _notified = true;
        }
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
