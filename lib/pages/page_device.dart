import 'package:home_app/deviceWidgets/device_sensor_temphum_page.dart';
import 'package:home_app/models/simple_device.dart';
import 'package:home_app/deviceWidgets/device_relay_page.dart';
import 'package:home_app/deviceWidgets/device_dimmer_page.dart';
import 'package:home_app/deviceWidgets/device_thermostat_page.dart';
import 'package:home_app/deviceWidgets/device_sensor_power_page.dart';
import 'package:home_app/deviceWidgets/device_motion_page.dart';

import 'package:flutter/material.dart';
import 'package:home_app/services/service_locator.dart';

import './page_device_logic.dart';

class PageDevice extends StatefulWidget {
  const PageDevice({super.key, required this.deviceId});

  final String deviceId;

  @override
  State<PageDevice> createState() => _DevicePageState();
}

class _DevicePageState extends State<PageDevice> {
  final stateManager = getIt<DevicePageManager>();

  @override
  void initState() {
    stateManager.initDevicePageState(widget.deviceId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stateManager = getIt<DevicePageManager>();
    return ValueListenableBuilder<String>(
        valueListenable: stateManager.pageDeviceNotifier,
        builder: (context, value, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text(stateManager.pageDeviceNotifier.myDevice.title),
                actions: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue,
                        child: IconButton(
                          icon: Icon(Icons.settings, color: Colors.white),
                          tooltip: 'Config',
                          onPressed: () {
                            stateManager.deviceConfigClicked();
                          },
                        ),
                      ))
                ],
              ),
              body: Builder(builder: (BuildContext context) {
                final SimpleDevice device =
                    stateManager.pageDeviceNotifier.myDevice;
                if (device.type == 'relay') {
                  return DeviceRelayPage(
                    id: device.id,
                    title: device.title,
                    object: device.object,
                    properties: device.properties,
                  );
                } else if (device.type == 'dimmer') {
                  return DeviceDimmerPage(
                    id: device.id,
                    title: device.title,
                    object: device.object,
                    properties: device.properties,
                  );
                } else if (device.type == 'thermostat') {
                  return DeviceThermostatPage(
                    id: device.id,
                    title: device.title,
                    object: device.object,
                    properties: device.properties,
                  );
                } else if (device.type == 'sensor_power') {
                  return DeviceSensorPowerPage(
                    id: device.id,
                    title: device.title,
                    object: device.object,
                    properties: device.properties,
                  );
                } else if (device.type == 'sensor_temphum') {
                  return DeviceSensorTempHumPage(
                    id: device.id,
                    title: device.title,
                    object: device.object,
                    properties: device.properties,
                  );
                } else if (device.type == 'motion') {
                  return DeviceMotionPage(
                    id: device.id,
                    title: device.title,
                    object: device.object,
                    properties: device.properties,
                  );
                } else {
                  return const Center(
                      child:
                          Text('Sorry, device is not fully supported yet...'));
                }
              }));
        });
  }
}
