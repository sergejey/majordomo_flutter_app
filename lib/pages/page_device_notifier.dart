import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:home_app/models/simple_device.dart';
import 'package:home_app/services/preferences_service.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/services/data_service.dart';

class PageDeviceNotifier extends ValueNotifier<String> {
  PageDeviceNotifier() : super('');
  final _dataService = getIt<DataService>();
  final _preferencesService = getIt<PreferencesService>();

  String deviceId = '';

  SimpleDevice myDevice = const SimpleDevice(
      id: 'error',
      title: 'Error device',
      object: 'unknown',
      type: 'unknown',
      linkedRoom: 'unknown',
      properties: <String, dynamic>{});

  Future<void> initialize(String initDeviceId) async {
    deviceId = initDeviceId;
    await _preferencesService.readAllPreferences();
    _dataService.setBaseURL(
        _preferencesService.getPreference("serverAddressLocal") ?? "");
    await fetchDevice();
  }

  Future<void> fetchDevice() async {
    myDevice = await _dataService.fetchMyDevice(deviceId);
    refreshDevice();
  }

  Future<void> callMethod(String object, String method, [Map<String , dynamic>? params]) async {
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
