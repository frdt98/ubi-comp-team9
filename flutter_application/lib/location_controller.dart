import 'package:flutter/widgets.dart';
import 'package:location/location.dart';

class LocationController extends ChangeNotifier {
  final Location location = Location();
  bool serviceEnabled = false;
  late PermissionStatus _permissionGranted;
  String? _station;
  bool _inRadius = false;

  bool get inRadius {
    return _inRadius;
  }

  isInRadius() {
    // TODO check if the current location is in the radius of the Station
    if (_station == '서울대 입구') {
      _inRadius = true;
      notifyListeners();
    }
  }

  String? get station {
    return _station;
  }

  set station(String? value) {
    _station = value;
    notifyListeners();
  }

  initLocation() async {
    serviceEnabled = await location.serviceEnabled();
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

    location.onLocationChanged.listen((LocationData currentLocation) {
      isInRadius();
    });
  }
}
