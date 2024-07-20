import 'package:flutter/material.dart';
import 'package:home_app/pages/page_edit_device_notifier.dart';
import 'package:home_app/services/data_service.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:localization/localization.dart';
import 'package:url_launcher/url_launcher.dart';

class EditDevicePageManager {
  final pageEditDeviceNotifier = PageEditDeviceNotifier();
  final _dataService = getIt<DataService>();

  String newDeviceTitle = '';
  String newDeviceLinkedRoom = '';

  void initEditDevicePageState(String deviceId) {
    pageEditDeviceNotifier.initialize(deviceId);
  }

  void saveDeviceData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('dialog_saved'.i18n())),
    );
    _dataService.updateDevice(pageEditDeviceNotifier.myDevice.id,
        {"title": newDeviceTitle, "room": newDeviceLinkedRoom});
    Navigator.of(context).pop();
  }

  Future<void> deviceConfigClicked() async {
    final Uri _url = Uri.parse(pageEditDeviceNotifier.deviceConfigURL);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

}
