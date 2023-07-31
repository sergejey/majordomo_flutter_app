import 'package:flutter/material.dart';

import 'package:home_app/services/service_locator.dart';
import 'package:home_app/pages/page_main_logic.dart';
import 'package:home_app/pages/page_device.dart';
import 'package:home_app/config.dart';

import './device_generic.dart';
import './device_relay.dart';
import './device_motion.dart';
import './device_openclose.dart';
import './device_sensor_temphum.dart';
import './device_sensor_general.dart';
import './device_sensor_light.dart';

class DeviceWrapper extends StatelessWidget {
  const DeviceWrapper(
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: const Color(0x8F000000),
                width: 1.0,
                style: BorderStyle.solid), //Border.all
            borderRadius: const BorderRadius.all(
              Radius.circular(6),
            ),
            /*
            boxShadow: const [
              BoxShadow(blurRadius: 8),
            ],*/
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (configDevicesWithPages.contains(type)) {
                  final stateManager = getIt<MainPageManager>();
                  stateManager.endPeriodicUpdate();
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => PageDevice(deviceId: id),
                    ),
                  )
                      .then((value) {
                    stateManager.reload();
                  });
                }
              },
              child: Builder(builder: (BuildContext context) {
                if (type == 'relay' ||
                    type == 'dimmer' ||
                    type == 'vacuum' ||
                    type == 'tv') {
                  return DeviceRelay(
                    title: title,
                    id: id,
                    object: object,
                    properties: properties,
                  );
                } else if (type == 'sensor_temphum') {
                  return DeviceSensorTempHum(
                    title: title,
                    id: id,
                    object: object,
                    properties: properties,
                  );
                } else if (type == 'motion') {
                  return DeviceMotion(
                    title: title,
                    id: id,
                    object: object,
                    properties: properties,
                  );
                } else if (type == 'openclose') {
                  return DeviceOpenClose(
                    title: title,
                    id: id,
                    object: object,
                    properties: properties,
                  );
                } else if (type == 'sensor_light') {
                  return DeviceSensorLight(
                    title: title,
                    id: id,
                    object: object,
                    properties: properties,
                  );
                } else if (type == 'sensor_general') {
                  return DeviceSensorGeneral(
                    title: title,
                    id: id,
                    object: object,
                    properties: properties,
                  );
                } else {
                  return DeviceGeneric(
                    title: title,
                    id: id,
                    object: object,
                    properties: properties,
                  );
                }
              }),
            ),
          ),
        ),
      ),
    );
  }
}
