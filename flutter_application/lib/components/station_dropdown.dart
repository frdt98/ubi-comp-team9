import 'package:flutter/cupertino.dart';
import 'package:bus_stop_app/constants/stations.dart';
import 'package:flutter/material.dart';

class StationDropdown extends StatelessWidget {
  const StationDropdown({Key? key, this.value, required this.onChanged})
      : super(key: key);
  final String? value;
  final Function onChanged;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      iconSize: 0,
      elevation: 16,
      hint: const Text("Station name"),
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        onChanged(newValue);
      },
      items: stationNames.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
