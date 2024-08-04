import 'dart:async';
import 'package:flutter/material.dart';
import 'package:home_app/pages/page_configure_device.dart';
import 'package:home_app/pages/page_device_notifier.dart';

class DevicePageManager {
  final pageDeviceNotifier = PageDeviceNotifier();
  bool _fetchInProgress = false;

  final Ticker _ticker = Ticker();
  StreamSubscription<int>? _tickerSubscription;

  void initDevicePageState(String deviceId) {
    pageDeviceNotifier.initialize(deviceId);
    startPeriodicUpdate();
  }

  void dispose() {
    pageDeviceNotifier.dispose();
  }

  void deviceConfigurationClicked(BuildContext context) async {
    endPeriodicUpdate();
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) =>
            PageConfigureDevice(deviceId: pageDeviceNotifier.deviceId),
      ),
    )
        .then((value) {
      startPeriodicUpdate();
    });
  }

  void toggleFavorite() {
    pageDeviceNotifier.toggleFavorite();
  }

  void startPeriodicUpdate() {
    _tickerSubscription = _ticker.tick(ticks: 5).listen(
      (duration) {
        if (!_fetchInProgress) {
          _fetchInProgress = true;
          pageDeviceNotifier.fetchDevice();
          _fetchInProgress = false;
        }
      },
    );
  }

  void endPeriodicUpdate() {
    _tickerSubscription?.cancel();
  }

  void callObjectMethod(String object, String method,
      [Map<String, dynamic>? params]) {
    pageDeviceNotifier.callMethod(object, method, params);
  }
}

class Ticker {
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(
      const Duration(seconds: 5),
      (x) => ticks - x - 1,
    ).takeWhile((element) => true);
  }
}
