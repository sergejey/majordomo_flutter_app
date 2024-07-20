import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
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

  Future<void> deviceConfigClicked() async {
    final Uri _url = Uri.parse(pageDeviceNotifier.deviceConfigURL);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
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
