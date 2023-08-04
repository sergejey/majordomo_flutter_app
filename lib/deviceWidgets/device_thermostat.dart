import 'package:flutter/material.dart';
import 'package:home_app/utils/text_updated.dart';

class DeviceThermostat extends StatelessWidget {
  const DeviceThermostat(
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
              TextUpdated(updated: properties["updated"] ?? ""),
            ],
          ),
        ),
        /*3*/
        Container(
          decoration: BoxDecoration(
            color: properties["relay_status"] == "1"
                ? Colors.yellow
                : Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              children: [
                Text(
                  properties["value"] + "°C",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                    properties["disabled"] == "1"
                        ? 'off'
                        : properties["status"] == "1"
                            ? 'normal → ${properties["currentTargetValue"]}°C'
                            : 'eco → ${properties["currentTargetValue"]}°C',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
