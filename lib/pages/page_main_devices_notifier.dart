import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:home_app/models/operational_mode.dart';
import 'package:home_app/models/simple_device.dart';
import 'package:home_app/models/room.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/services/data_service.dart';

class PageMainDevicesNotifier extends ValueNotifier<String> {
  PageMainDevicesNotifier() : super('');
  final _dataService = getIt<DataService>();

  bool activeFilter = false;
  String roomFilter = '';
  String currentRoomTitle = '';

  List<Room> myRooms = [];

  List<OperationalMode> myOperationalModes = [];
  List<OperationalMode> myOperationalModesFiltered = [];

  List<SimpleDevice> myDevices = [];
  List<SimpleDevice> myDevicesFullList = [];

  void resetRoomFilter() {
    roomFilter = '';
    currentRoomTitle = '';
    activeFilter = false;
    refreshDevices();
  }

  void setRoomFilter(String roomObject, String roomTitle) {
    roomFilter = roomObject;
    currentRoomTitle = roomTitle;
    activeFilter = false;
    refreshDevices();
  }

  void toggleActiveFilter() {
    if (activeFilter) {
      activeFilter = false;
    } else {
      activeFilter = true;
    }
    refreshDevices();
  }

  Future<void> initialize() async {
    await _dataService.initialize();
    await fetchDevices();
    myRooms = await _dataService.fetchRooms();
  }

  Future<void> fetchDevices() async {
    myDevicesFullList = await _dataService.fetchMyDevices();
    myOperationalModes = await _dataService.fetchOperationalModes();
    myOperationalModesFiltered.clear();
    myOperationalModesFiltered.addAll(myOperationalModes);
    myOperationalModesFiltered.retainWhere((OperationalMode opMode) {
      if (['econommode', 'nobodyhomemode', 'nightmode','darknessmode', 'securityarmedmode']
          .contains(opMode.object.toLowerCase())) return true;
      return false;
    });
    refreshDevices();
  }

  refreshDevices() {
    myDevices.clear();
    myDevices.addAll(myDevicesFullList);

    if (roomFilter != '') {
      myDevices.retainWhere((SimpleDevice device) {
        if (device.linkedRoom == roomFilter) {
          return true;
        }
        return false;
      });
    }

    if (activeFilter) {
      myDevices.retainWhere((SimpleDevice device) {
        if (((device.type == "relay" ||
                    device.type == "dimmer" ||
                    device.type == "motion" ||
                    device.type == "vacuum" ||
                    device.type == "sensor_power" ||
                    device.type == "tv") &&
                device.properties["status"] == "1") ||
            ((device.type == "openclose" ||
                device.type == "openable") &&
                device.properties["status"] != "1") ||
            (device.type == "thermostat" &&
                device.properties["relay_status"] == "1")) {
          return true;
        }
        return false;
      });
    }
    //myDevices = myDevicesFullList;
    _updatePageMainDevices(DateTime.now().toString());
  }

  Future<void> callMethod(String object, String method,
      [Map<String, dynamic>? params]) async {
    await _dataService.callDeviceMethod(object, method, params);
    fetchDevices();
  }

  void _updatePageMainDevices(String newValue) {
    value = newValue;
  }
}
