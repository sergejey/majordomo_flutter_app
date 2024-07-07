import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:home_app/models/history_record.dart';
import 'package:home_app/models/operational_mode.dart';
import 'package:home_app/models/system_state.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/services/data_service.dart';

class PageModesNotifier extends ValueNotifier<String> {
  PageModesNotifier() : super('');
  final _dataService = getIt<DataService>();

  List<OperationalMode> opModes = [];
  List<SystemState> sysStates = [];

  List<List<HistoryRecord>> opModesHistory = List.generate(10, (index) => []);

  Future<void> initialize() async {

    await _dataService.initialize();

    opModes = await _dataService.fetchOperationalModes();
    sysStates = await _dataService.fetchSystemStates();
    for (var i = 0; i < opModes.length; i++) {
      opModesHistory[i] = [];
      await fetchModeHistory(i);
    }
    refreshModes();
  }

  Future<void> fetchModes() async {
    opModes = await _dataService.fetchOperationalModes();
    sysStates = await _dataService.fetchSystemStates();
    refreshModes();
  }

  Future<void> fetchModeHistory(int modeNum) async {
    OperationalMode opMode = opModes[modeNum];
    opModesHistory[modeNum] = await _dataService.getPropertyHistory(opMode.object, 'active');
  }

  Future<void> callMethod(String object, String method, [Map<String , dynamic>? params]) async {
    await _dataService.callDeviceMethod(object, method, params);
    fetchModes();
  }

  refreshModes() {
    _updatePageModes(DateTime.now().toString());
  }

  void _updatePageModes(String newValue) {
    value = newValue;
  }
}
