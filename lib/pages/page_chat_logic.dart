import 'dart:async';

import 'package:home_app/pages/page_chat_notifier.dart';

class ChatPageManager {
  final pageChatNotifier = PageChatNotifier();

  bool _fetchInProgress = false;

  final Ticker _ticker = Ticker();
  StreamSubscription<int>? _tickerSubscription;

  void initChatPageState() {
    pageChatNotifier.initialize();
    startPeriodicUpdate();
  }

  void startPeriodicUpdate() {
    _tickerSubscription = _ticker.tick(ticks: 5).listen(
          (duration) {
        if (!_fetchInProgress) {
          _fetchInProgress = true;
          pageChatNotifier.fetchMessages();
          _fetchInProgress = false;
        }
      },
    );
  }

  void endPeriodicUpdate() {
    _tickerSubscription?.cancel();
  }

  void dispose() {
    endPeriodicUpdate();
    pageChatNotifier.dispose();
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