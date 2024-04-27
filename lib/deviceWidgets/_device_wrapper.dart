import 'package:flutter/material.dart';

import 'package:home_app/services/service_locator.dart';
import 'package:home_app/pages/page_main_logic.dart';
import 'package:home_app/pages/page_device.dart';

import './device_generic.dart';
import './device_relay.dart';
import './device_dimmer.dart';
import './device_rgb.dart';
import './device_thermostat.dart';
import './device_motion.dart';
import './device_openclose.dart';
import './device_openable.dart';
import './device_sensor_temp.dart';
import './device_sensor_humidity.dart';
import './device_sensor_temphum.dart';
import './device_sensor_general.dart';
import './device_sensor_power.dart';
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
    bool deviceOffline = false;
    if ((properties['alive'] ?? '') == '0' && type!='relay') deviceOffline = true;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Opacity(
          opacity: deviceOffline ? 0.5 : 1,
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
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  final stateManager = getIt<MainPageManager>();
                  stateManager.endPeriodicUpdate();
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => PageDevice(deviceId: id),
                    ),
                  )
                      .then((value) {
                    stateManager.resumePeriodicUpdate();
                  });
                },
                child: Builder(builder: (BuildContext context) {
                  if (type == 'relay' || type == 'vacuum' || type == 'tv') {
                    return DeviceRelay(
                      title: title,
                      id: id,
                      object: object,
                      properties: properties,
                    );
                  } else if (type == 'dimmer') {
                    return DeviceDimmer(
                      title: title,
                      id: id,
                      object: object,
                      properties: properties,
                    );
                  } else if (type == 'rgb') {
                    return DeviceRGB(
                      title: title,
                      id: id,
                      object: object,
                      properties: properties,
                    );
                  } else if (type == 'thermostat') {
                    return DeviceThermostat(
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
                  } else if (type == 'sensor_temp') {
                    return DeviceSensorTemp(
                      title: title,
                      id: id,
                      object: object,
                      properties: properties,
                    );
                  } else if (type == 'sensor_humidity') {
                    return DeviceSensorHumidity(
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
                  } else if (type == 'openable') {
                    return DeviceOpenable(
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
                  } else if (type == 'sensor_power') {
                    return DeviceSensorPower(
                      title: title,
                      id: id,
                      object: object,
                      properties: properties,
                    );
                  } else if (type.startsWith('sensor_')) {
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
      ),
    );
  }
}
