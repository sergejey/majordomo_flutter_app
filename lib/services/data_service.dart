import 'dart:async';

import 'package:home_app/models/simple_device.dart';
import 'package:home_app/models/room.dart';
import 'package:home_app/models/operational_mode.dart';
import 'package:home_app/models/system_state.dart';
import 'package:home_app/models/history_record.dart';

import 'package:home_app/services/preferences_service.dart';
import 'package:home_app/services/service_locator.dart';

import 'package:network_info_plus/network_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/logging.dart';

abstract class DataService {
  String serverMode = 'auto';
  String currentWifiSSID = "";

  String _baseURL = "";
  String _username = "";
  String _password = "";
  String connectAccessToken = "";
  bool _checkInProgress = false;

  final WiFiTicker _ticker = WiFiTicker();
  StreamSubscription<int>? _tickerSubscription;

  final _preferencesService = getIt<PreferencesService>();

  Future<List<Room>> fetchRooms();

  Future<List<OperationalMode>> fetchOperationalModes();

  Future<List<SystemState>> fetchSystemStates();

  Future<List<SimpleDevice>> fetchMyDevices();

  Future<SimpleDevice> fetchMyDevice(String deviceId);

  Future<void> callDeviceMethod(String objectName, String method,
      [Map<String, dynamic>? params]);

  Future<List<HistoryRecord>> getPropertyHistory(
      String objectName, String property);

  Future<void> initialize() async {
    dprint("DataService initialize");
    endPeriodicUpdate();
    await _preferencesService.readAllPreferences();

    String prefMode = _preferencesService.getPreference("serverMode") ?? "";
    if (prefMode != '') {
      serverMode = prefMode;
    } else {
      serverMode = "auto";
    }

    String localURL =
        _preferencesService.getPreference("serverAddressLocal") ?? '';
    String remoteURL =
        _preferencesService.getPreference("serverAddressRemote") ?? localURL;

    if (localURL == '' && remoteURL != '') {
      localURL = remoteURL;
    }

    String loadURL = localURL;

    if (serverMode == 'auto') {
      currentWifiSSID = "";
      bool wifiFound = await checkWifiChange();
      //if (!wifiFound) {
      //  loadURL = localURL;
      //}
      startPeriodicUpdate();
    } else {
      if (serverMode == 'remote') {
        loadURL = remoteURL;
      } else if (serverMode == 'local') {
        loadURL = localURL;
      }
      if (loadURL == localURL) {
        dprint('Loading local URL');
      } else {
        dprint('Loading remote URL');
      }
      setBaseURL(loadURL);
    }
  }

  void setUsernamePassword(String username, String password) {
    _username = username;
    _password = password;
  }

  String getUsername() {
    return _username;
  }

  String getPassword() {
    return _password;
  }

  void setBaseURL(String url) {
    dprint("Setting baseURL to $url");
    String serverUsername =
        _preferencesService.getPreference("serverUsername") ?? "";
    String serverPassword =
        _preferencesService.getPreference("serverPassword") ?? "";

    connectAccessToken =
        _preferencesService.getPreference("connectAccessToken") ?? "";

    if (url == 'connect.smartliving.ru' && connectAccessToken != '') {
      serverUsername = 'access_token';
      serverPassword = connectAccessToken;
    }
    setUsernamePassword(serverUsername, serverPassword);

    _baseURL = url;
  }

  String getBaseURL() {
    String url = _baseURL;
    if (url == '') return url;
    if (url == 'connect.smartliving.ru')
      return 'https://connect.smartliving.ru';
    if (!url.startsWith('http:')) url = 'http://$url';
    return url;
  }

  Future<bool> checkWifiChange() async {
    bool urlFound = false;

    if (serverMode == "auto") {
      String localURL =
          _preferencesService.getPreference("serverAddressLocal") ?? "";
      String remoteURL =
          _preferencesService.getPreference("serverAddressRemote") ?? localURL;

      ConnectivityResult _connectionStatus = ConnectivityResult.none;
      final Connectivity _connectivity = Connectivity();
      _connectionStatus = await _connectivity.checkConnectivity();

      if (_connectionStatus != ConnectivityResult.wifi) {
        dprint('(auto) No WiFi. Loading remote URL');
        setBaseURL(remoteURL);
      } else {
        String localWifiSSID =
            _preferencesService.getPreference("localWifiSSID") ?? "";

        String loadURL = localURL;
        if (localWifiSSID != "" &&
            await Permission.locationWhenInUse.request().isGranted) {
          final info = NetworkInfo();

          String newWifiSSID = await info.getWifiName() ?? "";
          newWifiSSID = newWifiSSID.replaceAll('"', '');

          if (newWifiSSID != currentWifiSSID) {
            currentWifiSSID = newWifiSSID;
            if (localWifiSSID != currentWifiSSID) {
              loadURL = remoteURL;
            }
            if (loadURL == localURL) {
              dprint('(auto) Loading local URL');
            } else {
              dprint('(auto) Loading remote URL');
            }
            urlFound = true;
            setBaseURL(loadURL);
          }
        }
      }
    }

    return urlFound;
  }

  void startPeriodicUpdate() {
    _tickerSubscription = _ticker.tick(ticks: 15).listen(
      (duration) async {
        if (!_checkInProgress) {
          _checkInProgress = true;
          bool urlFound = await checkWifiChange();
          _checkInProgress = false;
        }
      },
    );
  }

  void endPeriodicUpdate() {
    _tickerSubscription?.cancel();
  }
}

class WiFiTicker {
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(
      const Duration(seconds: 5),
      (x) => ticks - x - 1,
    ).takeWhile((element) => true);
  }
}
