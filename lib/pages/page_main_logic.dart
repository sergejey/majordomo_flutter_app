import 'dart:async';
import 'package:home_app/pages/page_main_devices_notifier.dart';
import 'package:home_app/utils/logging.dart';

class MainPageManager {
  final pageMainDevicesNotifier = PageMainDevicesNotifier();
  bool _fetchInProgress = false;

  final Ticker _ticker = Ticker();
  StreamSubscription<int>? _tickerSubscription;

  void setRoomFilter(String roomObject, String roomTitle) {
    pageMainDevicesNotifier.setRoomFilter(roomObject, roomTitle);
  }

  void resetRoomFilter() {
    pageMainDevicesNotifier.resetRoomFilter();
  }

  void toggleActiveFilter() {
    pageMainDevicesNotifier.toggleActiveFilter();
  }

  void initMainPageState() {
    pageMainDevicesNotifier.initialize();
    startPeriodicUpdate();
  }

  void reload() async {
    dprint("Reloading main page logic");
    endPeriodicUpdate();
    await pageMainDevicesNotifier.initialize();
    startPeriodicUpdate();
  }

  void dispose() {
    pageMainDevicesNotifier.dispose();
  }

  void startPeriodicUpdate() {
    _tickerSubscription = _ticker.tick(ticks: 5).listen(
      (duration) {
        dprint("Periodic tick");
        if (!_fetchInProgress) {
          _fetchInProgress = true;
          pageMainDevicesNotifier.fetchDevices();
          _fetchInProgress = false;
        }
      },
    );
  }

  void endPeriodicUpdate() {
    _tickerSubscription?.cancel();
  }

  void callObjectMethod(String object, String method) {
    pageMainDevicesNotifier.callMethod(object, method);
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
