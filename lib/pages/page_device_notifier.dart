import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:home_app/models/simple_device.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/services/data_service.dart';

class PageDeviceNotifier extends ValueNotifier<String> {
  PageDeviceNotifier() : super('');
  final _dataService = getIt<DataService>();

  String deviceId = '';
  String deviceConfigURL = '';

  SimpleDevice myDevice = SimpleDevice(
      id: 'error',
      title: 'Error device',
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

    await fetchDevice();
  }

  void toggleFavorite() {
    if (myDevice.favorite) {
      myDevice.favorite = false;
      _dataService.removeFromFavorites(myDevice.object);
    } else {
      _dataService.addToFavorites(myDevice.object);
      myDevice.favorite = true;
    }
    refreshDevice();
  }

  Future<void> fetchDevice() async {
    myDevice = await _dataService.fetchMyDevice(deviceId);
    refreshDevice();
  }

  Future<void> callMethod(String object, String method,
      [Map<String, dynamic>? params]) async {
    await _dataService.callDeviceMethod(object, method, params);
    fetchDevice();
  }

  refreshDevice() {
    _updatePageDevice(DateTime.now().toString());
  }

  void _updatePageDevice(String newValue) {
    value = newValue;
  }
}
