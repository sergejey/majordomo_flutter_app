import 'package:flutter/material.dart';
import 'package:home_app/commonWidgets/device_chart.dart';
import 'package:home_app/utils/text_updated.dart';

class DeviceSensorTempPage extends StatelessWidget {
  const DeviceSensorTempPage(
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: DeviceChart(deviceObject: object, deviceProperty: 'value')
          ),
          SizedBox(
            height: 10,
          ),
          /*3*/
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextUpdated(updated: properties['updated']),
            ),
          )
        ],
      ),
    );
  }
}
