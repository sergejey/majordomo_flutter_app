import 'package:flutter/material.dart';
import 'package:home_app/pages/page_actions.dart';
import 'package:home_app/pages/page_configure_device_notifier.dart';
import 'package:home_app/pages/page_edit_device.dart';
import 'package:home_app/pages/page_schedule.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfigureDevicePageManager {
  final pageConfigureDeviceNotifier = PageConfigureDeviceNotifier();

  void initConfigureDevicePageState(String deviceId) {
    pageConfigureDeviceNotifier.initialize(deviceId);
  }

  void deviceEditClicked(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) =>
                PageEditDevice(deviceId: pageConfigureDeviceNotifier.deviceId)))
        .then((value) {
      pageConfigureDeviceNotifier.fetchDevice();
    });
  }

  void deviceScheduleClicked(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
        builder: (context) =>
            PageSchedule(deviceId: pageConfigureDeviceNotifier.deviceId)))
        .then((value) {
      pageConfigureDeviceNotifier.fetchDevice();
    });
  }

  void deviceAutomationClicked(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
        builder: (context) =>
            PageActions(deviceId: pageConfigureDeviceNotifier.deviceId)))
        .then((value) {
      pageConfigureDeviceNotifier.fetchDevice();
    });
  }

  Future<void> deviceAdvancedConfigClicked() async {
    final Uri _url = Uri.parse(pageConfigureDeviceNotifier.deviceConfigURL);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
