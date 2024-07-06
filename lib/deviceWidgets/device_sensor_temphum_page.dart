import 'package:flutter/material.dart';
import 'package:home_app/commonWidgets/device_chart.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/pages/page_device_logic.dart';
import 'package:home_app/utils/text_updated.dart';
import 'package:localization/localization.dart';

import '../commonWidgets/device_value.dart';

class DeviceSensorTempHumPage extends StatelessWidget {
  const DeviceSensorTempHumPage({super.key,
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
    final stateManager = getIt<DevicePageManager>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('device_temperature'.i18n() + ":"),
              SizedBox(width: 10),
              DeviceValue(value: (properties["value"] ?? '') + '°C'),
              SizedBox(width: 20),
              Text('device_humidity'.i18n() + ":"),
              SizedBox(width: 10),
              DeviceValue(value: (properties["valueHumidity"] ?? '') + '%'),
            ],
          ),
          SizedBox(
            height: 10,
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
