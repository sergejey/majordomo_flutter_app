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

  @override
  Future<List<HistoryRecord>> getPropertyHistory(String objectName, String property) async {
    final baseURL = getBaseURL();
    if (baseURL == "") {
      dprint("Base URL is not set");
      return [];
    }

    final apiURL = '$baseURL/api/history/$objectName.$property/1month';
    dprint("Fetching operational modes data from $apiURL ${DateTime.now().toString()}");
    try {
      final response = await client.get(Uri.parse(apiURL));
      if (response.statusCode == 200) {
        final parsed =
        jsonDecode(response.body)["result"].cast<Map<String, dynamic>>();
        return parsed.map<HistoryRecord>((json) => HistoryRecord.fromJson(json)).toList();
      } else {
        dprint("Error loading $apiURL");
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
    final apiURL = '$baseURL/api/objects/SystemStates';
    dprint("Fetching system states data from $apiURL ${DateTime.now().toString()}");
    try {
      final response = await client.get(Uri.parse(apiURL));
      if (response.statusCode == 200) {
        final parsed =
        jsonDecode(response.body)["objects"].cast<Map<String, dynamic>>();
        return parsed.map<SystemState>((json) => SystemState.fromJson(json)).toList();
      } else {
        dprint("Error loading $apiURL");
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
    final apiURL = '$baseURL/api/objects/OperationalModes';
    dprint("Fetching operational modes data from $apiURL ${DateTime.now().toString()}");
    try {
      final response = await client.get(Uri.parse(apiURL));
      if (response.statusCode == 200) {
        final parsed =
        jsonDecode(response.body)["objects"].cast<Map<String, dynamic>>();
        return parsed.map<OperationalMode>((json) => OperationalMode.fromJson(json)).toList();
      } else {
        dprint("Error loading $apiURL");
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
    final apiURL = '$baseURL/api/rooms';
    dprint("Fetching rooms data from $apiURL ${DateTime.now().toString()}");
    try {
      final response = await client.get(Uri.parse(apiURL));
      if (response.statusCode == 200) {
        final parsed =
            jsonDecode(response.body)["rooms"].cast<Map<String, dynamic>>();
        return parsed.map<Room>((json) => Room.fromJson(json)).toList();
      } else {
        dprint("Error loading $apiURL");
      }
    } catch (e) {
      dprint('General Error: $e');
    }
    return [];
  }

  @override
  Future<SimpleDevice> fetchMyDevice(String deviceId) async {
    const emptyDevice = SimpleDevice(
        id: 'error',
        title: 'Error device',
        object: 'unknown',
        type: 'unknown',
        linkedRoom: 'unknown',
        properties: <String, dynamic>{});
    final baseURL = getBaseURL();
    if (baseURL == "") {
      dprint("Base URL is not set");
      return emptyDevice;
    }
    final apiURL = '$baseURL/api/devices/$deviceId';

    dprint("Fetching my devices data from $apiURL ${DateTime.now().toString()}");
    try {
      final response = await client.get(Uri.parse(apiURL));
      if (response.statusCode == 200) {
        final Map<String, dynamic> parsed = jsonDecode(response.body)["device"];
        return SimpleDevice.fromJson(parsed);
      } else {
        dprint("Error loading $apiURL");
      }
    } catch (e) {
      dprint('General Error: $e');
    }
    return emptyDevice;
  }

  @override
  Future<List<SimpleDevice>> fetchMyDevices() async {
    final baseURL = getBaseURL();
    if (baseURL == "") {
      dprint("Base URL is not set");
      return [];
    }
    final apiURL = '$baseURL/api/devices';
    dprint("Fetching my devices data from $apiURL ${DateTime.now().toString()}");
    try {
      final response = await client.get(Uri.parse(apiURL));
      if (response.statusCode == 200) {
        final parsed =
            jsonDecode(response.body)["devices"].cast<Map<String, dynamic>>();
        return parsed
            .map<SimpleDevice>((json) => SimpleDevice.fromJson(json))
            .toList();
      } else {
        dprint("Error loading $apiURL");
      }
    } catch (e) {
      dprint('General Error: $e');
    }
    return [];
  }

  @override
  Future<void> callDeviceMethod(String objectName, String method) async {
    final baseURL = getBaseURL();
    dprint("Calling $objectName . $method");
    if (baseURL == "") {
      dprint("Base URL is not set");
    } else {
      await client.get(Uri.parse('$baseURL/api/method/$objectName.$method'));
      //print("Response: ${response.body}");
    }
  }
}
