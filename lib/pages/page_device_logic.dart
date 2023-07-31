import 'dart:async';
import 'package:home_app/pages/page_device_notifier.dart';
import 'package:home_app/utils/logging.dart';

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

  void startPeriodicUpdate() {
    _tickerSubscription = _ticker.tick(ticks: 5).listen(
          (duration) {
        dprint("Periodic device tick");
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

  void callObjectMethod(String object, String method) {
    pageDeviceNotifier.callMethod(object, method);
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