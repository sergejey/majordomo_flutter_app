import 'dart:async';
import 'package:flutter/material.dart';
import 'package:home_app/pages/page_main_devices_notifier.dart';
import 'package:home_app/pages/page_settings.dart';
import 'package:home_app/utils/logging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localization/localization.dart';

class MainPageManager {
  final pageMainDevicesNotifier = PageMainDevicesNotifier();
  bool _fetchInProgress = false;
  bool _canBeClosed = false;
  int bottomBarIndex = 0;
  String appView = '';

  Timer? exitTimer;

  final Ticker _ticker = Ticker();

  StreamSubscription<int>? _tickerSubscription;

  void onExitTimerEnd() {
    _canBeClosed = false;
  }

  bool canBeClosed() {
    return _canBeClosed;
  }

  bool allowToClose() {

    if (_canBeClosed) {
      endPeriodicUpdate();
      return true;
    }

    print("Room filter: "+pageMainDevicesNotifier.roomFilter);
    if (pageMainDevicesNotifier.roomFilter!='') {
      pageMainDevicesNotifier.setRoomsView();
      return false;
    }

    Fluttertoast.showToast(
        msg: 'confirm_exit'.i18n());

    exitTimer?.cancel();
    exitTimer = Timer(Duration(seconds: 2), onExitTimerEnd);
    _canBeClosed = true;

    return false;
  }

  void setAppView(String viewName) {
    appView = viewName;
    if (viewName == 'home') {
      pageMainDevicesNotifier.setHomeView();
    } else if (viewName == 'favorites') {
      pageMainDevicesNotifier.setFavoritesView();
    } else if (viewName == 'rooms') {
      pageMainDevicesNotifier.setRoomsView();
    } else if (viewName == 'attention') {
      pageMainDevicesNotifier.setAttentionView();
    }
  }

  void setRoomFilter(roomObject, roomTitle) {
    pageMainDevicesNotifier.setRoomFilter(roomObject, roomTitle);
  }

  void demoSetup() {
    pageMainDevicesNotifier.demoSetup();
    setAppView('home');
    reload();
  }

  void openSettings(context, String startWith) {
    endPeriodicUpdate();
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => PageSettings(startWith: startWith),
      ),
    )
        .then((value) {
      bottomBarIndex = 1;
      setAppView('home');
      reload();
    });
  }

  void setBottomBarIndex(int index, context) {
    bottomBarIndex = index;
    if (index == 0) {
      setAppView('favorites');
    } else if (index == 1) {
      setAppView('home');
    } else if (index == 2) {
      setAppView('rooms');
    } else if (index == 3) {
      setAppView('attention');
    } else if (index == 4) {
      openSettings(context, '');
    }
    pageMainDevicesNotifier.refreshPage();
  }

  void newDevicesClicked(BuildContext context) {
    setBottomBarIndex(1, context);
    pageMainDevicesNotifier.setNewDevicesView();
  }

  void switchProfile(String profileId) {
    pageMainDevicesNotifier.switchProfile(profileId);
  }

  Future<void> initMainPageState() async {
    endPeriodicUpdate();
    await pageMainDevicesNotifier.initialize();
    if (appView == '') {
      if (pageMainDevicesNotifier.getFavorites().length > 0) {
        bottomBarIndex = 0;
        setAppView('favorites');
      } else {
        bottomBarIndex = 1;
        setAppView('home');
      }
    }
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

  void resumePeriodicUpdate() {
    endPeriodicUpdate();
    pageMainDevicesNotifier.fetchDevices();
    startPeriodicUpdate();
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
