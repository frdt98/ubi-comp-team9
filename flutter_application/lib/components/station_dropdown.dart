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
    return Material(
      color: Colors.white,
      elevation: 8,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: DropdownButton<String>(
          onChanged: (newvalue) {
            onChanged(newvalue);
          },
          value: value,

          // Hide the default underline
          underline: Container(),
          hint: const Center(
              child: Text(
            'Choose your destination',
            style: TextStyle(color: Colors.grey),
          )),
          icon: const Icon(
            Icons.arrow_downward,
            color: Colors.black,
          ),
          isExpanded: true,

          // The list of options
          items: stationNames
              .map((e) => DropdownMenuItem(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        e,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    value: e,
                  ))
              .toList(),

          // Customize the selected item
          selectedItemBuilder: (BuildContext context) => stationNames
              .map((e) => Center(
                    child: Text(
                      e,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
