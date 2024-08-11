import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:home_app/models/device_links.dart';

import 'package:home_app/services/service_locator.dart';
import 'package:home_app/services/data_service.dart';

class PageActionsNotifier extends ValueNotifier<String> {
  PageActionsNotifier() : super('');
  final _dataService = getIt<DataService>();

  String deviceId = '';

  List<DeviceLink> links = [];
  List<DeviceAvailableLink> availableLinks = [];

  Future<void> initialize(String initDeviceId) async {
    deviceId = initDeviceId;
    await _dataService.initialize();
    fetchLinks();
  }

  Future<bool?> updateLink(DeviceLink item) async {
    return await _dataService.updateLinkItem(deviceId, item);
  }

  Future<bool?> deleteLink(DeviceLink item) async {
    return await _dataService.deleteLinkItem(deviceId, item);
  }

  Future<void> fetchLinks() async {
    var (linksReturned, availableLinksReturned) =
        await _dataService.fetchDeviceLinks(deviceId);

    links = linksReturned;
    availableLinks = availableLinksReturned;

    refreshActions();
  }

  refreshActions() {
    _updateActionsPage(DateTime.now().millisecondsSinceEpoch.toString());
  }

  void _updateActionsPage(String newValue) {
    value = newValue;
  }
}
