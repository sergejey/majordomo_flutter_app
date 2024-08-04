import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:home_app/models/device_schedule.dart';
import 'package:home_app/models/simple_device.dart';

import 'package:home_app/services/service_locator.dart';
import 'package:home_app/services/data_service.dart';

class PageScheduleNotifier extends ValueNotifier<String> {
  PageScheduleNotifier() : super('');
  final _dataService = getIt<DataService>();

  String deviceId = '';
  List<DeviceSchedulePoint> points = [];
  List<DeviceScheduleMethod> methods = [];

  Future<void> initialize(String initDeviceId) async {
    deviceId = initDeviceId;
    await _dataService.initialize();
    fetchSchedule();
  }

  Future<bool?> updateScheduleItem(DeviceSchedulePoint item) async {
    return await _dataService.updateScheduleItem(deviceId, item);
  }

  Future<bool?> deleteScheduleItem(DeviceSchedulePoint item) async {
    return await _dataService.deleteScheduleItem(deviceId, item);
  }

  Future<void> fetchSchedule() async {
    var (pointsReturned, methodsReturned) = await _dataService.fetchDeviceSchedule(deviceId);

    points = pointsReturned;
    methods = methodsReturned;

    refreshSchedule();
  }

  refreshSchedule() {
    _updateSchedulePageDevice(DateTime.now().millisecondsSinceEpoch.toString());
  }

  void _updateSchedulePageDevice(String newValue) {
    value = newValue;
  }
}
