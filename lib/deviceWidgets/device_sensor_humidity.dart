import 'package:flutter/material.dart';
import 'package:home_app/commonWidgets/device_icon.dart';
import 'package:home_app/commonWidgets/device_value.dart';
import 'package:home_app/utils/text_updated.dart';

import '../utils/battery_level.dart';

class DeviceSensorHumidity extends StatelessWidget {
  const DeviceSensorHumidity(
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
        Expanded(
          /*1*/
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DeviceIcon(
                deviceType: 'sensor_humidity',
                deviceTitle: title,
              ),
              Expanded(child: SizedBox(width: 10)),
              DeviceValue(value:(properties["value"]??'')+'%')
            ],
          ),
        ),
      ],
    );
  }
}
