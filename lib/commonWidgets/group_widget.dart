import 'package:flutter/material.dart';

class GroupWidget extends StatelessWidget {
  const GroupWidget(
      {super.key,
      required this.name,
      required this.title,
      required this.selected,
      required this.devicesTotal});

  final String name;
  final String title;
  final bool selected;
  final int devicesTotal;

  @override
  Widget build(BuildContext context) {
    Icon groupIcon = const Icon(Icons.question_mark, color: Colors.green);
    if (name == 'light') {
      groupIcon = const Icon(Icons.light_outlined, color: Colors.green);
    }
    if (name == 'outlet') {
      groupIcon = const Icon(Icons.power_settings_new, color: Colors.green);
    }
    if (name == 'openable') {
      groupIcon = const Icon(Icons.lock_open_rounded, color: Colors.green);
    }
    if (name == 'sensor') {
      groupIcon = const Icon(Icons.thermostat_outlined, color: Colors.green);
    }
    if (name == 'motion') {
      groupIcon = const Icon(Icons.man, color: Colors.green);
    }
    if (name == 'camera') {
      groupIcon = const Icon(Icons.video_camera_back_outlined, color: Colors.green);
    }
    if (name == 'climate') {
      groupIcon = const Icon(Icons.ac_unit_outlined, color: Colors.green);
    }
    if (name == 'other') {
      groupIcon = const Icon(Icons.question_mark, color: Colors.green);
    }
    return Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? Colors.yellowAccent : Colors.white,
            border: Border.all(
                color: Colors.green,
                width: 1.0,
                style: BorderStyle.solid), //Border.all
            borderRadius: const BorderRadius.all(
              Radius.circular(3),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Row(
              children: [
                groupIcon,
                SizedBox(width: 5),
                Text(title),
                SizedBox(width: 5),
              ],
            )),
          ),
        ));
  }
}
