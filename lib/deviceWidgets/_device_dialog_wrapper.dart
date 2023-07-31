import 'package:flutter/material.dart';
import './device_relay_dialog.dart';
import './device_sensor_temphum_dialog.dart';

class DeviceDialogWrapper extends StatelessWidget {
  const DeviceDialogWrapper(
      {super.key,
      required this.title,
      required this.id,
      required this.type,
      required this.object,
      required this.properties});

  final String title;
  final String id;
  final String type;
  final String object;
  final Map<String, dynamic> properties;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(builder: (BuildContext context) {
              if (type == 'relay' || type == 'dimmer') {
                return DeviceRelayDialog(
                  title: title,
                  id: id,
                  object: object,
                  properties: properties,
                );
              } else if (type == 'sensor_temphum') {
                return DeviceSensorTempHumDialog(
                  title: title,
                  id: id,
                  object: object,
                  properties: properties,
                );
              } else {
                return const Text('Unknown devices type dialog');
              }
            })));
  }
}
