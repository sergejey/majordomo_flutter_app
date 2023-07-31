import 'package:home_app/models/simple_device.dart';
import 'package:home_app/deviceWidgets/device_relay_page.dart';

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
              title:Text(stateManager.pageDeviceNotifier.myDevice.title),
            ),
            body: Builder(builder: (BuildContext context) {
              final SimpleDevice device = stateManager.pageDeviceNotifier.myDevice;
              if (device.type=='relay' || device.type=='dimmer') {
                return DeviceRelayPage(
                  id: device.id,
                  title: device.title,
                  object: device.object,
                  properties: device.properties,
                );
              } else {
                return const Text('Unknown device');
              }
            })
          );
        });
  }
}
