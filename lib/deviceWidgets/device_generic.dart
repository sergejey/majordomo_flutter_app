import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../utils/battery_level.dart';
import '../utils/text_updated.dart';

class DeviceGeneric extends StatelessWidget {
  const DeviceGeneric(
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
                  Text(
                    'device_type'.i18n()+": ${properties["type"]}; ",
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  TextUpdated(updated: properties["updated"] ?? ""),
                  if (properties["batteryOperated"]=='1')
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
