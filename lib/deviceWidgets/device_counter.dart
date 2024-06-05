import 'package:flutter/material.dart';
import 'package:home_app/commonWidgets/device_icon.dart';
import 'package:home_app/commonWidgets/device_value.dart';
import 'package:home_app/utils/text_updated.dart';

class DeviceCounter extends StatelessWidget {
  const DeviceCounter(
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
          deviceType: 'counter',
          deviceTitle: title,
        ),
        Expanded(child: SizedBox(width: 5)),
        DeviceValue(value: properties["value"])
      ],
    );
  }
}
