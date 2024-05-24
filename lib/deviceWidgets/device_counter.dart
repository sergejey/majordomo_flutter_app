import 'package:flutter/material.dart';
import 'package:home_app/commonWidgets/device_icon.dart';
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
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          child: Text(
            properties["value"],
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
