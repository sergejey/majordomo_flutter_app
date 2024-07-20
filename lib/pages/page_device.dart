import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_app/deviceWidgets/_device_wrapper.dart';
import 'package:home_app/deviceWidgets/device_counter_page.dart';
import 'package:home_app/deviceWidgets/device_sensor_temphum_page.dart';
import 'package:home_app/deviceWidgets/device_sensor_temp_page.dart';
import 'package:home_app/deviceWidgets/device_sensor_light_page.dart';
import 'package:home_app/deviceWidgets/device_sensor_general_page.dart';
import 'package:home_app/deviceWidgets/device_sensor_humidity_page.dart';
import 'package:home_app/models/simple_device.dart';
import 'package:home_app/deviceWidgets/device_relay_page.dart';
import 'package:home_app/deviceWidgets/device_dimmer_page.dart';
import 'package:home_app/deviceWidgets/device_rgb_page.dart';
import 'package:home_app/deviceWidgets/device_thermostat_page.dart';
import 'package:home_app/deviceWidgets/device_sensor_power_page.dart';
import 'package:home_app/deviceWidgets/device_sensor_percentage_page.dart';
import 'package:home_app/deviceWidgets/device_sensor_pressure_page.dart';
import 'package:home_app/deviceWidgets/device_motion_page.dart';
import 'package:home_app/deviceWidgets/device_openable_page.dart';
import 'package:home_app/deviceWidgets/device_openclose_page.dart';
import 'package:home_app/deviceWidgets/device_button_page.dart';
import 'package:home_app/deviceWidgets/device_group_state_page.dart';

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
  void deactivate() {
    stateManager.endPeriodicUpdate();
    super.deactivate();
  }

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
                        backgroundColor:
                            stateManager.pageDeviceNotifier.myDevice.favorite
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).colorScheme.onPrimary,
                        child: IconButton(
                          icon: SvgPicture.asset(
                              'assets/navigation/nav_favorite.svg',
                              colorFilter: ColorFilter.mode(
                                  stateManager
                                          .pageDeviceNotifier.myDevice.favorite
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).primaryColor,
                                  BlendMode.srcIn)),
                          tooltip: 'Favorite',
                          onPressed: () {
                            stateManager.toggleFavorite();
                          },
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        child: IconButton(
                          icon: SvgPicture.asset(
                              'assets/navigation/nav_settings.svg',
                              colorFilter: ColorFilter.mode(
                                  Theme.of(context).primaryColor,
                                  BlendMode.srcIn)),
                          tooltip: 'Config',
                          onPressed: () {
                            stateManager.deviceConfigClicked();
                          },
                        ),
                      ))
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: stateManager.pageDeviceNotifier.myDevice.id == ''
                    ? Text('')
                    : Column(
                        children: [
                          DeviceWrapper(
                            insideDevice: true,
                            id: stateManager.pageDeviceNotifier.myDevice.id,
                            type: stateManager.pageDeviceNotifier.myDevice.type,
                            title:
                                stateManager.pageDeviceNotifier.myDevice.title,
                            object:
                                stateManager.pageDeviceNotifier.myDevice.object,
                            properties: stateManager
                                .pageDeviceNotifier.myDevice.properties,
                            roomTitle: stateManager
                                .pageDeviceNotifier.myDevice.roomTitle,
                          ),
                          SizedBox(height: 10),
                          Expanded(
                              child: Builder(builder: (BuildContext context) {
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
                            } else if (device.type == 'rgb') {
                              return DeviceRGBPage(
                                id: device.id,
                                title: device.title,
                                object: device.object,
                                properties: device.properties,
                              );
                            } else if (device.type == 'openable') {
                              return DeviceOpenablePage(
                                id: device.id,
                                title: device.title,
                                object: device.object,
                                properties: device.properties,
                              );
                            } else if (device.type == 'openclose') {
                              return DeviceOpenClosePage(
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
                            } else if (device.type == 'sensor_light') {
                              return DeviceSensorLightPage(
                                id: device.id,
                                title: device.title,
                                object: device.object,
                                properties: device.properties,
                              );
                            } else if (device.type == 'sensor_general') {
                              return DeviceSensorGeneralPage(
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
                            } else if (device.type == 'sensor_temp') {
                              return DeviceSensorTempPage(
                                id: device.id,
                                title: device.title,
                                object: device.object,
                                properties: device.properties,
                              );
                            } else if (device.type == 'sensor_percentage') {
                              return DeviceSensorPercentagePage(
                                id: device.id,
                                title: device.title,
                                object: device.object,
                                properties: device.properties,
                              );
                            } else if (device.type == 'sensor_pressure') {
                              return DeviceSensorPressurePage(
                                id: device.id,
                                title: device.title,
                                object: device.object,
                                properties: device.properties,
                              );
                            } else if (device.type == 'counter') {
                              return DeviceCounterPage(
                                id: device.id,
                                title: device.title,
                                object: device.object,
                                properties: device.properties,
                              );
                            } else if (device.type == 'sensor_humidity') {
                              return DeviceSensorHumidityPage(
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
                            } else if (device.type == 'button') {
                              return DeviceButtonPage(
                                id: device.id,
                                title: device.title,
                                object: device.object,
                                properties: device.properties,
                              );
                            } else if (device.type == 'group_state') {
                              return DeviceGroupStatePage(
                                id: device.id,
                                title: device.title,
                                object: device.object,
                                properties: device.properties,
                              );
                            } else {
                              return SizedBox(height: 5);
                            }
                          })),
                        ],
                      ),
              ));
        });
  }
}
