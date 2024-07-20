import 'package:flutter/material.dart';
import 'package:home_app/commonWidgets/device_icon.dart';
import 'package:home_app/commonWidgets/device_value.dart';

class DeviceSensorTempHum extends StatelessWidget {
  const DeviceSensorTempHum(
      {super.key,
      required this.title,
      required this.id,
      required this.object,
      required this.properties,
      this.insideDevice = false});

  final String title;
  final String id;
  final String object;
  final Map<String, dynamic> properties;
  final bool insideDevice;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DeviceIcon(
          deviceType: 'sensor_temp',
          deviceTitle: title,
        ),
        Expanded(child: SizedBox(width: 10)),
        DeviceValue(
            value: (properties["value"] ?? '') + '°C',
            valueState:
                ((properties["normalValue"] ?? "1") != "1") ? "1" : "0"),
        if (insideDevice) ...[
          SizedBox(width: 5),
          DeviceValue(value: (properties["valueHumidity"] ?? '') + '%')
        ]
      ],
    );
  }
}
