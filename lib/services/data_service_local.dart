import 'dart:async';
import 'dart:convert';

import 'package:home_app/utils/logging.dart';

import 'data_service.dart';
import 'package:home_app/models/history_record.dart';
import 'package:home_app/models/simple_device.dart';
import 'package:home_app/models/room.dart';
import 'package:home_app/models/operational_mode.dart';
import 'package:home_app/models/system_state.dart';
import 'package:http/http.dart' as http;

class DataServiceLocal extends DataService {
  static http.Client client = http.Client();

  Future<String> getURL(String URL) async {
    String goURL = URL;

    String basicAuth = '';
    String userName = getUsername();
    String password = getPassword();

    if (userName != '' && password != '') {
      String credentials = "$userName:$password";
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String encoded = stringToBase64.encode(credentials);
      basicAuth = 'Basic ' + encoded;
    }
    final http.Response response;

    if (goURL.contains('http://connect.smartliving.ru')) {
      goURL = goURL.replaceFirst('http://', 'https://');
    }

    dprint('Fetching $goURL');

    if (basicAuth != '') {
      response = await client.get(Uri.parse(goURL), headers: <String, String>{
        'Authorization': basicAuth,
        'Connection': 'Keep-Alive'
      }).timeout(const Duration(seconds: 10));
    } else {
      response = await client.get(Uri.parse(goURL), headers: <String, String>{
        'Connection': 'Keep-Alive'
      }).timeout(const Duration(seconds: 10));
    }

    if (response.statusCode == 200) {
      return response.body;
    } else {
      dprint("Error loading $goURL (code: ${response.statusCode})");
      return '';
    }
  }

  @override
  Future<List<HistoryRecord>> getPropertyHistory(
      String objectName, String property,
      [String? period]) async {
    final baseURL = getBaseURL();

    if (period == null) period = '1month';

    if (baseURL == "") {
      dprint("Base URL is not set");
      return [];
    }

    final apiURL = '$baseURL/api.php/history/$objectName.$property/$period';
    try {
      final response = await getURL(apiURL);
      if (response != '') {
        final parsed =
            jsonDecode(response)["result"].cast<Map<String, dynamic>>();
        return parsed
            .map<HistoryRecord>((json) => HistoryRecord.fromJson(json))
            .toList();
      }
    } catch (e) {
      dprint('General Error: $e');
    }
    return [];
  }

  @override
  Future<List<SystemState>> fetchSystemStates() async {
    final baseURL = getBaseURL();
    if (baseURL == "") {
      dprint("Base URL is not set");
      return [];
    }
    final apiURL = '$baseURL/api.php/objects/SystemStates';
    try {
      final response = await getURL(apiURL);
      if (response != '') {
        final parsed =
            jsonDecode(response)["objects"].cast<Map<String, dynamic>>();
        return parsed
            .map<SystemState>((json) => SystemState.fromJson(json))
            .toList();
      }
    } catch (e) {
      dprint('General Error: $e');
    }
    return [];
  }

  @override
  Future<List<OperationalMode>> fetchOperationalModes() async {
    final baseURL = getBaseURL();
    if (baseURL == "") {
      dprint("Base URL is not set");
      return [];
    }
    final apiURL = '$baseURL/api.php/objects/OperationalModes';
    try {
      final response = await getURL(apiURL);
      if (response != '') {
        final parsed =
            jsonDecode(response)["objects"].cast<Map<String, dynamic>>();
        return parsed
            .map<OperationalMode>((json) => OperationalMode.fromJson(json))
            .toList();
      }
    } catch (e) {
      dprint('General Error: $e');
    }
    return [];
  }

  @override
  Future<List<Room>> fetchRooms() async {
    final baseURL = getBaseURL();
    if (baseURL == "") {
      dprint("Base URL is not set");
      return [];
    }
    final apiURL = '$baseURL/api.php/rooms';
    dprint("Fetching rooms data from $apiURL ${DateTime.now().toString()}");
    try {
      final response = await getURL(apiURL);
      if (response != '') {
        final parsed =
            jsonDecode(response)["rooms"].cast<Map<String, dynamic>>();
        return parsed.map<Room>((json) => Room.fromJson(json)).toList();
      }
    } catch (e) {
      dprint('General Error: $e');
    }
    return [];
  }

  @override
  Future<SimpleDevice> fetchMyDevice(String deviceId) async {
    List<String> _favorites = getFavorites();
    SimpleDevice emptyDevice = SimpleDevice(
        id: 'error',
        title: 'Error device',
        object: 'unknown',
        type: 'unknown',
        linkedRoom: 'unknown',
        favorite: false,
        properties: <String, dynamic>{},
        roomTitle: '');
    final baseURL = getBaseURL();
    if (baseURL == "") {
      dprint("Base URL is not set");
      return emptyDevice;
    }
    final apiURL = '$baseURL/api.php/devices/$deviceId';

    dprint(
        "Fetching my devices data from $apiURL ${DateTime.now().toString()}");
    try {
      final response = await getURL(apiURL);
      if (response != '') {
        final Map<String, dynamic> parsed = jsonDecode(response)["device"];
        emptyDevice = SimpleDevice.fromJson(parsed);
        if (_favorites.contains(emptyDevice.object)) {
          emptyDevice.favorite = true;
        }
        return emptyDevice;
      }
    } catch (e) {
      dprint('General Error: $e');
    }
    return emptyDevice;
  }

  @override
  Future<List<SimpleDevice>> fetchMyDevices() async {
    List<String> _favorites = getFavorites();
    final baseURL = getBaseURL();
    if (baseURL == "") {
      dprint("Base URL is not set");
      return [];
    }
    final apiURL = '$baseURL/api.php/devices';
    dprint(
        "Fetching my devices data from $apiURL ${DateTime.now().toString()}");
    try {
      final response = await getURL(apiURL);
      if (response != '') {
        final parsed =
            jsonDecode(response)["devices"].cast<Map<String, dynamic>>();
        List<SimpleDevice> devicesReturned = parsed
            .map<SimpleDevice>((json) => SimpleDevice.fromJson(json))
            .toList();
        for (int i = 0; i < devicesReturned.length; i++) {
          if (_favorites.contains(devicesReturned[i].object))
            devicesReturned[i].favorite = true;
        }
        return devicesReturned;
      }
    } catch (e) {
      dprint('General Error: $e');
    }
    return [];
  }

  @override
  Future<void> callDeviceMethod(String objectName, String method,
      [Map<String, dynamic>? params]) async {
    final baseURL = getBaseURL();
    dprint("Calling $objectName . $method");
    if (baseURL == "") {
      dprint("Base URL is not set");
    } else {
      String url = '$baseURL/api.php/method/$objectName.$method';
      if (params != null) {
        url += '?';
        params.forEach((key, value) {
          url += '$key=$value&';
        });
      }
      await getURL(url);
    }
  }
}
