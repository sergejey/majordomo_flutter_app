import 'package:flutter/material.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/pages/page_device_logic.dart';
import 'package:home_app/utils/text_updated.dart';
import 'package:localization/localization.dart';

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
    final stateManager = getIt<DevicePageManager>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('device_temperature'.i18n()+":"),
                  SizedBox(
                    height: 10,
                  ),
                  Text("${properties['value']} °C",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 55)),
                ],
              ),
            ],
          )),
          SizedBox(
            height: 20,
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
