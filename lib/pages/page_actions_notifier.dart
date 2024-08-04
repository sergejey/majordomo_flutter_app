import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:home_app/models/simple_device.dart';

import 'package:home_app/services/service_locator.dart';
import 'package:home_app/services/data_service.dart';

class PageActionsNotifier extends ValueNotifier<String> {
  PageActionsNotifier() : super('');
  final _dataService = getIt<DataService>();

  String deviceId = '';
  String deviceConfigURL = '';

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
    fetchDevice();
  }

  Future<void> fetchDevice() async {
    myDevice = await _dataService.fetchMyDevice(deviceId);
    refreshDevice();
  }

  refreshDevice() {
    _updateActionsPageDevice(myDevice.title);
  }

  void _updateActionsPageDevice(String newValue) {
    value = newValue;
  }
}
