import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:home_app/models/operational_mode.dart';
import 'package:home_app/models/simple_device.dart';
import 'package:home_app/models/room.dart';
import 'package:home_app/models/device_group.dart';
import 'package:home_app/models/profile.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/services/preferences_service.dart';
import 'package:home_app/services/data_service.dart';
import 'package:localization/localization.dart';

class PageMainDevicesNotifier extends ValueNotifier<String> {
  PageMainDevicesNotifier() : super('');
  final _dataService = getIt<DataService>();

  bool isSetupRequired = false;

  int newDevicesAvailable = 0;

  bool activeFilter = false;
  bool roomView = false;
  bool favoritesView = false;
  bool newDevicesView = false;

  String roomFilter = '';
  String groupFilter = '';
  String currentRoomTitle = '';
  String currentDataMode = '';

  String currentProfileTitle = "";
  String currentProfileId = "";
  List<Profile> profiles = [];
  final _preferencesService = getIt<PreferencesService>();

  List<Room> myRooms = [];
  List<DeviceGroup> myGroups = [
    DeviceGroup(name: 'light', title: 'group_light'.i18n(), devicesTotal: 0),
    DeviceGroup(name: 'outlet', title: 'group_outlet'.i18n(), devicesTotal: 0),
    DeviceGroup(
        name: 'openable', title: 'group_openable'.i18n(), devicesTotal: 0),
    DeviceGroup(name: 'sensor', title: 'group_sensor'.i18n(), devicesTotal: 0),
    DeviceGroup(name: 'motion', title: 'group_motion'.i18n(), devicesTotal: 0),
    DeviceGroup(name: 'camera', title: 'group_camera'.i18n(), devicesTotal: 0),
    DeviceGroup(
        name: 'climate', title: 'group_climate'.i18n(), devicesTotal: 0),
    DeviceGroup(name: 'other', title: 'group_other'.i18n(), devicesTotal: 0),
  ];

  List<OperationalMode> myOperationalModes = [];
  List<OperationalMode> myOperationalModesFiltered = [];

  List<SimpleDevice> myDevices = [];
  List<SimpleDevice> myDevicesFullList = [];
  List<SimpleDevice> myDevicesBackupList = [];

  void setRoomFilter(String roomObject, String roomTitle) {
    resetAllFilters();
    roomFilter = roomObject;
    currentRoomTitle = roomTitle;
    refreshDevices();
  }

  void resetAllFilters() {
    groupFilter = '';
    roomFilter = '';
    currentRoomTitle = '';
    roomView = false;
    activeFilter = false;
    favoritesView = false;
    newDevicesView = false;
  }

  Future<void> initialize() async {
    myDevices.clear();
    myDevicesFullList.clear();
    myDevicesBackupList.clear();
    myOperationalModes.clear();
    myOperationalModesFiltered.clear();
    updateGroupsDataByDevices();
    _updatePageMainDevices(DateTime.now().toString() + '_clear');

    await _preferencesService.readAllPreferences();

    isSetupRequired = _preferencesService.isSetupRequired();

    profiles = await _preferencesService.getProfiles();
    currentProfileId = _preferencesService.getProfileId();
    currentProfileTitle = _preferencesService.getProfileTitle();
    await _dataService.initialize();
    myRooms = await _dataService.fetchRooms();
    currentDataMode = _dataService.currentMode;
    await fetchDevices();
  }

  void demoSetup() {
    _preferencesService.savePreference(
        'serverAddressLocal', 'https://demo.mjdm.ru');
  }

  Future<void> switchProfile(String profileId) async {
    _preferencesService.setProfileId(profileId);
    initialize();
  }

  bool checkDeviceAgainstFilter(SimpleDevice device, filter_name) {
    if (filter_name == 'light' &&
        ((device.type == 'relay' && device.properties['loadType'] == 'light') ||
            device.type == 'dimmer' ||
            device.type == 'rgb')) {
      return true;
    } else if (filter_name == 'outlet' &&
        (device.type == 'relay' ||
            device.type == 'tv' ||
            device.type == 'vacuum') &&
        device.properties['loadType'] != 'light') {
      return true;
    } else if (filter_name == 'openable' &&
        (device.type == 'openable' || device.type == 'openclose')) {
      return true;
    } else if (filter_name == 'motion' && device.type == 'motion') {
      return true;
    } else if (filter_name == 'camera' && device.type == 'camera') {
      return true;
    } else if (filter_name == 'climate' &&
        (device.type == 'thermostat' || device.type == 'ac')) {
      return true;
    } else if (filter_name == 'sensor' &&
        (device.type.contains('sensor') ||
            device.type == 'leak' ||
            device.type == 'smoke')) {
      return true;
    } else if (filter_name == 'other') {
      if (!(device.type.contains('sensor') ||
          ([
            'relay',
            'rgb',
            'dimmer',
            'openable',
            'openclose',
            'motion',
            'camera',
            'thermostat',
            'ac',
            'leak',
            'smoke',
            'tv',
            'vacuum'
          ]).contains(device.type))) {
        return true;
      }
    }
    return false;
  }

  void updateGroupsDataByDevices() {
    int totalGroups = myGroups.length;
    for (int i = 0; i < totalGroups; i++) {
      List<SimpleDevice> groupDevices =
          myDevicesFullList.where((SimpleDevice device) {
        return checkDeviceAgainstFilter(device, myGroups[i].name);
      }).toList();
      myGroups[i].devicesTotal = groupDevices.length;
    }
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
      bool foundLightOn = false;
      bool foundPowerOn = false;
      bool foundMotionOn = false;
      bool foundMotionUpdated = false;
      bool foundTemperature = false;
      bool foundOpen = false;
      for (int iD = 0; iD < totalDevices; iD++) {
        roomDevices[iD].roomTitle = myRooms[i].title;
        if (((roomDevices[iD].type == 'relay' &&
                    roomDevices[iD].properties['loadType'] == 'light') ||
                roomDevices[iD].type == 'dimmer') &&
            roomDevices[iD].properties['status'] == '1') {
          myRooms[i].properties['lightOn'] = '1';
          foundLightOn = true;
        }
        if (roomDevices[iD].type == 'relay' &&
            roomDevices[iD].properties['loadType'] != 'light' &&
            roomDevices[iD].properties['status'] == '1') {
          myRooms[i].properties['powerOn'] = '1';
          foundPowerOn = true;
        }
        if (roomDevices[iD].type == 'motion' &&
            roomDevices[iD].properties['status'] == '1') {
          myRooms[i].properties['motionOn'] = '1';
          foundMotionOn = true;
        }
        if (roomDevices[iD].type == 'motion') {
          myRooms[i].properties['motionUpdated'] =
              roomDevices[iD].properties['updated'];
          foundMotionUpdated = true;
        }
        if (roomDevices[iD].type == 'sensor_temp') {
          myRooms[i].properties['temperature'] =
              roomDevices[iD].properties['value'];
          foundTemperature = true;
        }
        if (roomDevices[iD].type == 'sensor_temphum') {
          myRooms[i].properties['temperature'] =
              roomDevices[iD].properties['value'];
          foundTemperature = true;
        }
        if ((roomDevices[iD].type == 'openable' ||
                roomDevices[iD].type == 'openclose') &&
            roomDevices[iD].properties['status'] != '1') {
          myRooms[i].properties['isOpen'] = '1';
          foundOpen = true;
        }
      }
      if (!foundLightOn) myRooms[i].properties.remove('lightOn');
      if (!foundPowerOn) myRooms[i].properties.remove('powerOn');
      if (!foundMotionOn) myRooms[i].properties.remove('motionOn');
      if (!foundMotionUpdated) myRooms[i].properties.remove('motionUpdated');
      if (!foundTemperature) myRooms[i].properties.remove('temperature');
      if (!foundOpen) myRooms[i].properties.remove('isOpen');
    }
  }

  Future<void> fetchDevices() async {
    currentDataMode = _dataService.currentMode;
    myDevicesFullList = await _dataService.fetchMyDevices();
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
    if (currentDataMode == 'local') {
      myOperationalModesFiltered.insert(
          0,
          OperationalMode(
              id: '0',
              title: 'Connection',
              object: 'connectionLocal',
              active: (myDevicesFullList.length > 0),
              properties: {}));
    } else {
      myOperationalModesFiltered.insert(
          0,
          OperationalMode(
              id: '0',
              title: 'Connection',
              object: 'connectionRemote',
              active: (myDevicesFullList.length > 0),
              properties: {}));
    }
    if (myDevicesFullList.length > 0) {
      myDevicesBackupList = myDevicesFullList;
    } else {
      myDevicesFullList = myDevicesBackupList;
    }

    newDevicesAvailable = 0;
    myDevicesFullList.forEach((device) {
      if (device.linkedRoom == '') newDevicesAvailable++;
    });

    updateRoomsDataByDevices();
    updateGroupsDataByDevices();
    refreshDevices();
  }

  List<String> getFavorites() {
    return _dataService.getFavorites();
  }

  refreshDevices() {
    myDevices.clear();
    myDevices.addAll(myDevicesFullList);

    if (favoritesView) {
      myDevices.retainWhere((SimpleDevice device) {
        return device.favorite;
      });
    }

    if (newDevicesAvailable==0 && newDevicesView) {
      newDevicesView = false;
    }
    if (newDevicesView) {
      myDevices.retainWhere((SimpleDevice device) {
        return device.roomTitle == '';
      });
    }

    if (groupFilter != '') {
      myDevices.retainWhere((SimpleDevice device) {
        return checkDeviceAgainstFilter(device, groupFilter);
      });
    }

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
                    device.type == "leak" ||
                    device.type == "smoke" ||
                    device.type == "tv") &&
                device.properties["status"] == "1") ||
            ((device.type == "openclose" || device.type == "openable") &&
                device.properties["status"] != "1") ||
            (device.type == "thermostat" &&
                device.properties["relay_status"] == "1") ||
            ((device.properties["normalValue"] ?? "1") != "1")) {
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

  void toggleGroupFilter(String group_name) {
    if (groupFilter == group_name) {
      groupFilter = '';
    } else {
      groupFilter = group_name;
    }
    refreshDevices();
  }

  void setHomeView() {
    resetAllFilters();
    refreshDevices();
  }

  void setAttentionView() {
    resetAllFilters();
    activeFilter = true;
    refreshDevices();
  }

  void setFavoritesView() {
    resetAllFilters();
    favoritesView = true;
    refreshDevices();
  }

  void setNewDevicesView() {
    resetAllFilters();
    newDevicesView = true;
    refreshDevices();
  }

  void setRoomsView() {
    resetAllFilters();
    roomView = true;
    refreshDevices();
  }

  void refreshPage() {
    _updatePageMainDevices('');
  }

  void _updatePageMainDevices(String newValue) {
    value = newValue;
  }
}
