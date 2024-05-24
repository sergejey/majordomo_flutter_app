import 'package:flutter/material.dart';
import 'package:home_app/commonWidgets/device_icon.dart';
import 'package:home_app/utils/text_updated.dart';

class DeviceMotion extends StatelessWidget {
  const DeviceMotion(
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
          deviceType: 'motion',
          deviceState: properties['status'],
          deviceTitle: title,
        ),
        SizedBox(width:10),
        Expanded(
          /*1*/
          child: Container(
              decoration: BoxDecoration(
                color:
                    properties["status"] == "1" ? Theme.of(context).primaryColor : Colors.white,
                borderRadius: const BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              child: DefaultTextStyle(
                style: TextStyle(color:properties["status"] == "1" ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).primaryColor),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: TextUpdated(updated: properties["updated"] ?? ""),
                ),
              )),
        ),
      ],
    );
  }
}
