import 'dart:async';

import 'package:home_app/pages/page_modes_notifier.dart';
import 'package:home_app/utils/logging.dart';

class ModesPageManager {
  final pageModesNotifier = PageModesNotifier();
  bool _fetchInProgress = false;

  final Ticker _ticker = Ticker();
  StreamSubscription<int>? _tickerSubscription;

  void initModesPageState() {
    pageModesNotifier.initialize();
    startPeriodicUpdate();
  }

  void dispose() {
    pageModesNotifier.dispose();
  }

  void startPeriodicUpdate() {
    _tickerSubscription = _ticker.tick(ticks: 5).listen(
          (duration) {
        dprint("Periodic modes tick");
        if (!_fetchInProgress) {
          _fetchInProgress = true;
          pageModesNotifier.fetchModes();
          _fetchInProgress = false;
        }
      },
    );
  }

  void endPeriodicUpdate() {
    _tickerSubscription?.cancel();
  }

  void callObjectMethod(String object, String method) {
    pageModesNotifier.callMethod(object, method);
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