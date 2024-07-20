import 'package:flutter/material.dart';
import 'package:home_app/commonWidgets/device_icon.dart';
import 'package:localization/localization.dart';

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
        DeviceIcon(
          deviceType: 'thermostat',
          deviceState: properties["relay_status"],
          deviceTitle: title,
        ),
        Expanded(child: SizedBox(width:10)),
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
            padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
            child: Column(
              children: [
                Text(
                  properties["value"] + "°C",
                ),
                Text(
                    properties["disabled"] == "1"
                        ? 'is_off'.i18n()
                        : properties["status"] == "1"
                            ? '→ ${properties["currentTargetValue"]}°C'
                            : '→ ${properties["currentTargetValue"]}°C',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
