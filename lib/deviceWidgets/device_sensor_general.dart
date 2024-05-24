import 'package:flutter/material.dart';
import 'package:home_app/commonWidgets/device_icon.dart';
import 'package:home_app/utils/text_updated.dart';

class DeviceSensorGeneral extends StatelessWidget {
  const DeviceSensorGeneral(
      {super.key,
      required this.title,
      required this.id,
      required this.object,
      required this.type,
      required this.properties});

  final String title;
  final String id;
  final String object;
  final String type;
  final Map<String, dynamic> properties;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DeviceIcon(
          deviceType: type,
          deviceTitle: title,
        ),
        Expanded(
          /*1*/
            child: SizedBox(width: 10)),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Text(
            properties["value"]??'' + " " + properties["unit"]??'',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ],
    );
  }
}
