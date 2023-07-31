import 'package:flutter/material.dart';
import 'package:home_app/utils/text_updated.dart';

class DeviceSensorTempHum extends StatelessWidget {
  const DeviceSensorTempHum(
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
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            properties["value"] + "°C",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ],
    );
  }
}
