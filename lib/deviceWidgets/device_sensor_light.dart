import 'package:flutter/material.dart';
import 'package:home_app/utils/text_updated.dart';

import '../utils/battery_level.dart';

class DeviceSensorLight extends StatelessWidget {
  const DeviceSensorLight(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*2*/
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  TextUpdated(updated: properties["updated"] ?? ""),
                  if (properties["batteryOperated"]=='1')
                    BatteryLevel(level: properties["batteryLevel"] ?? "")
                ],
              ),
            ],
          ),
        ),
        /*3*/
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            properties["value"],
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ],
    );
  }
}
