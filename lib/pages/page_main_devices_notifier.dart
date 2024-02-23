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
  bool roomView = false;

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
    roomView = false;
    refreshDevices();
  }

  void setRoomFilter(String roomObject, String roomTitle) {
    roomFilter = roomObject;
    currentRoomTitle = roomTitle;
    activeFilter = false;
    roomView = false;
    refreshDevices();
  }

  void toggleActiveFilter() {
    if (activeFilter) {
      activeFilter = false;
    } else {
      activeFilter = true;
    }
    roomView = false;
    refreshDevices();
  }

  Future<void> initialize() async {
    await _dataService.initialize();
    myRooms = await _dataService.fetchRooms();
    await fetchDevices();
  }

  void updateRoomsDataByDevices() {
    int totalRooms = myRooms.length;
    for (int i = 0; i < totalRooms; i++) {
      String roomObject = myRooms[i].object;
      List<SimpleDevice> roomDevices =
          myDevicesFullList.where((SimpleDevice device) {
        if (device.linkedRoom == roomObject) {
          return true;
        }
        return false;
      }).toList();
      int totalDevices = roomDevices.length;
      for (int iD = 0; iD < totalDevices; iD++) {
        if (((roomDevices[iD].type == 'relay' &&
                    roomDevices[iD].properties['loadType'] == 'light') ||
                roomDevices[iD].type == 'dimmer') &&
            roomDevices[iD].properties['status'] == '1') {
          myRooms[i].properties['lightOn'] = '1';
        }
        if (roomDevices[iD].type == 'motion' &&
            roomDevices[iD].properties['status'] == '1') {
          myRooms[i].properties['motionOn'] = '1';
        }
        if (roomDevices[iD].type == 'motion') {
          myRooms[i].properties['motionUpdated'] = roomDevices[iD].properties['updated'];
        }
        if (roomDevices[iD].type == 'sensor_temphum') {
          myRooms[i].properties['temperature'] = roomDevices[iD].properties['value'];
        }
      }
    }
  }

  Future<void> fetchDevices() async {
    myDevicesFullList = await _dataService.fetchMyDevices();
    updateRoomsDataByDevices();
    myOperationalModes = await _dataService.fetchOperationalModes();
    myOperationalModesFiltered.clear();
    myOperationalModesFiltered.addAll(myOperationalModes);
    myOperationalModesFiltered.retainWhere((OperationalMode opMode) {
      if ([
        'econommode',
        'nobodyhomemode',
        'nightmode',
        'darknessmode',
        'securityarmedmode'
      ].contains(opMode.object.toLowerCase())) return true;
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
            ((device.type == "openclose" || device.type == "openable") &&
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

  void toggleRoomView() {
    if (roomView) {
      resetRoomFilter();
    } else {
      roomView = true;
      activeFilter = false;
    }
    _updatePageMainDevices(DateTime.now().toString());
  }

  void _updatePageMainDevices(String newValue) {
    value = newValue;
  }
}
