import 'package:flutter/material.dart';
import 'package:home_app/commonWidgets/device_icon.dart';
import 'package:home_app/commonWidgets/device_value.dart';

class DeviceSensorTemp extends StatelessWidget {
  const DeviceSensorTemp(
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
    return Row(
      children: [
        DeviceIcon(
          deviceType: 'sensor_temp',
          deviceTitle: title,
        ),
        Expanded(
            /*1*/
            child: SizedBox(width: 10)),
        DeviceValue(
            value: (properties["value"] ?? '') + '°C',
            valueState: ((properties["normalValue"] ?? "1") != "1") ? "1" : "0")
      ],
    );
  }
}
