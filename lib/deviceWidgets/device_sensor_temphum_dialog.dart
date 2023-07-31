import 'package:flutter/material.dart';

class DeviceSensorTempHumDialog extends StatelessWidget {
  const DeviceSensorTempHumDialog(
      {super.key,
        required this.title,
        required this.id,
        required this.object,
        required this.properties});

  final String title;
  final String id;
  final String object;
  final Map<String, dynamic> properties;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
        onPressed: () {
          // show dialog
          Navigator.pop(context);
        },
        child: Text("$title: ${properties['value'] ?? ""} C"),
      ),
    );
  }
}
