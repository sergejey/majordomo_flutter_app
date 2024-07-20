import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:home_app/models/room.dart';
import 'package:home_app/models/simple_device.dart';

import 'package:home_app/services/service_locator.dart';
import 'package:home_app/services/data_service.dart';

class PageEditDeviceNotifier extends ValueNotifier<String> {
  PageEditDeviceNotifier() : super('');
  final _dataService = getIt<DataService>();

  String deviceId = '';
  String deviceConfigURL = '';

  List<Room> myRooms = [];

  SimpleDevice myDevice = SimpleDevice(
      id: 'error',
      title: 'Loading...',
      object: 'unknown',
      type: 'unknown',
      linkedRoom: 'unknown',
      roomTitle: '',
      favorite: false,
      properties: <String, dynamic>{});

  Future<void> initialize(String initDeviceId) async {
    deviceId = initDeviceId;
    await _dataService.initialize();
    deviceConfigURL =
        "${_dataService.getBaseURL()}/panel/devices/$deviceId.html?tab=settings";
    fetchDevice();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    myRooms = await _dataService.fetchRooms();
    refreshDevice();
  }

  Future<void> fetchDevice() async {
    myDevice = await _dataService.fetchMyDevice(deviceId);
    refreshDevice();
  }

  refreshDevice() {
    _updateEditPageDevice(DateTime.now().toString());
  }

  void _updateEditPageDevice(String newValue) {
    value = newValue;
  }
}
