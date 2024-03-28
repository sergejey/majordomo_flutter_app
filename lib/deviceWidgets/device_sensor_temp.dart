import 'package:flutter/material.dart';
import 'package:home_app/utils/text_updated.dart';

import '../utils/battery_level.dart';

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
        Expanded(
          /*1*/
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*1*/
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.bodyLarge,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      properties["value"] + "°C",
                      style: Theme.of(context).textTheme.headlineMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              /*2*/
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextUpdated(updated: properties["updated"] ?? ""),
                  if (properties["batteryOperated"] == '1')
                    BatteryLevel(level: properties["batteryLevel"] ?? "")
                ],
              ),
            ],
          ),
        ),

      ],
    );
  }
}
