import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../commonWidgets/device_icon.dart';

class DeviceGeneric extends StatelessWidget {
  const DeviceGeneric(
      {super.key,
      required this.title,
      required this.type,
      required this.id,
      required this.object,
      required this.properties});

  final String type;
  final String title;
  final String id;
  final String object;
  final Map<String, dynamic> properties;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DeviceIcon(
          deviceType: type??'',
          deviceState: properties['status']??'',
          deviceTitle: title??'',
        ),
        Expanded(child: SizedBox(width: 10)),
        Text(
          'device_type'.i18n() + ": ${properties["type"]??'unknown'}; ",
          style: Theme.of(context).textTheme.bodySmall,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
