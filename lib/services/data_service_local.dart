import 'dart:async';
import 'dart:convert';

import 'package:home_app/models/chat_message.dart';
import 'package:home_app/models/device_links.dart';
import 'package:home_app/models/device_schedule.dart';
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

  Future<String> deleteURL(String URL, [Map<String, dynamic>? params]) async {
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

    dprint('DELETE to $goURL with ' + params.toString());

    if (basicAuth != '') {
      response = await client.delete(Uri.parse(goURL),
          body: params,
          headers: <String, String>{
            'Authorization': basicAuth
          }).timeout(const Duration(seconds: 10));
    } else {
      response = await client.delete(Uri.parse(goURL),
          body: params,
          headers: <String, String>{}).timeout(const Duration(seconds: 10));
    }

    if (response.statusCode == 200) {
      return response.body;
    } else {
      dprint(
          "Error loading $goURL (code: ${response.statusCode}) ${response.body}");
      return '';
    }
  }

  Future<String> postURL(String URL, [Map<String, dynamic>? params]) async {
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

    dprint('Posting to $goURL');

    if (basicAuth != '') {
      response = await client.post(Uri.parse(goURL),
          body: params,
          headers: <String, String>{
            'Authorization': basicAuth
          }).timeout(const Duration(seconds: 10));
    } else {
      response = await client.post(Uri.parse(goURL),
          body: params,
          headers: <String, String>{}).timeout(const Duration(seconds: 10));
    }

    if (response.statusCode == 200) {
      return response.body;
    } else {
      dprint("Error loading $goURL (code: ${response.statusCode})");
      return '';
    }
  }

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
        'Authorization': basicAuth
      }).timeout(const Duration(seconds: 10));
    } else {
      response = await client.get(Uri.parse(goURL),
          headers: <String, String>{}).timeout(const Duration(seconds: 10));
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
  Future<(List<DeviceLink>, List<DeviceAvailableLink>)> fetchDeviceLinks(
      String deviceId) async {
    List<DeviceLink> linksReturned = [];
    List<DeviceAvailableLink> linksAvailableReturned = [];

    final baseURL = getBaseURL();
    if (baseURL != "") {
      final apiURL = '$baseURL/api.php/devices/$deviceId/links';
      try {
        final response = await getURL(apiURL);
        if (response != '') {
          final parsedLinks =
              jsonDecode(response)["links"].cast<Map<String, dynamic>>();

          linksReturned = parsedLinks
              .map<DeviceLink>((json) => DeviceLink.fromJson(json))
              .toList();

          final parsedAvailableLinks = jsonDecode(response)["available_links"]
              .cast<Map<String, dynamic>>();

          linksAvailableReturned = parsedAvailableLinks
              .map<DeviceAvailableLink>(
                  (json) => DeviceAvailableLink.fromJson(json))
              .toList();

          for (int i = 0; i < linksReturned.length; i++) {
            for (int k = 0; k < linksAvailableReturned.length; k++) {
              if (linksReturned[i].link_type ==
                  linksAvailableReturned[k].name) {
                linksReturned[i].link_type_title =
                    linksAvailableReturned[k].title;
              }
            }
          }
        }
      } catch (e) {
        dprint('General Error: $e');
      }
    }
    return (linksReturned, linksAvailableReturned);
  }

  @override
  Future<(List<DeviceSchedulePoint>, List<DeviceScheduleMethod>)>
      fetchDeviceSchedule(String deviceId) async {
    List<DeviceSchedulePoint> pointsReturned = [];
    List<DeviceScheduleMethod> methodsReturned = [];

    final baseURL = getBaseURL();
    if (baseURL != "") {
      final apiURL = '$baseURL/api.php/devices/$deviceId/schedule';
      try {
        final response = await getURL(apiURL);
        if (response != '') {
          final parsedPoints = jsonDecode(response)["schedule_points"]
              .cast<Map<String, dynamic>>();

          pointsReturned = parsedPoints
              .map<DeviceSchedulePoint>(
                  (json) => DeviceSchedulePoint.fromJson(json))
              .toList();

          final parsedMethods = jsonDecode(response)["schedule_methods"]
              .cast<Map<String, dynamic>>();

          methodsReturned = parsedMethods
              .map<DeviceScheduleMethod>(
                  (json) => DeviceScheduleMethod.fromJson(json))
              .toList();

          for (int i = 0; i < pointsReturned.length; i++) {
            for (int k = 0; k < methodsReturned.length; k++) {
              if (pointsReturned[i].linkedMethod ==
                  methodsReturned[k].methodName) {
                pointsReturned[i].linkedMethodTitle = methodsReturned[k].title;
              }
            }
          }
        }
      } catch (e) {
        dprint('General Error: $e');
      }
    }

    return (pointsReturned, methodsReturned);
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
        roomTitle: '',
        linksTotal: 0,
        scheduleTotal: 0);
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
  Future<bool?> postMessage(String message) async {
    final baseURL = getBaseURL();
    if (baseURL != "") {
      final apiURL = '$baseURL/api.php/messages';
      dprint("Posting messages to $apiURL");
      Map<String, dynamic>? params = {
        'message': message,
      };
      String response = await postURL(apiURL, params);
      dprint("Response: " + response);
      if (response != '') {
        return true;
      }
    }
    return false;
  }

  @override
  Future<(List<ChatMessage>, ChatUser)> fetchMessages() async {
    List<ChatMessage> messagesReturned = [];
    ChatUser userReturned = ChatUser(id: "0", name: "User");

    final baseURL = getBaseURL();
    if (baseURL != "") {
      final apiURL = '$baseURL/api.php/messages';
      dprint("Fetching messages from $apiURL ${DateTime.now().toString()}");
      try {
        final response = await getURL(apiURL);
        if (response != '') {
          final parsedMessages =
              jsonDecode(response)["messages"].cast<Map<String, dynamic>>();

          messagesReturned = parsedMessages
              .map<ChatMessage>((json) => ChatMessage.fromJson(json))
              .toList();

          final parsedUser =
              jsonDecode(response)["user"] as Map<String, dynamic>;
          userReturned = ChatUser.fromJson(parsedUser);
        }
      } catch (e) {
        dprint('General Error: $e');
      }
    }
    return (messagesReturned, userReturned);
  }

  @override
  Future<bool?> updateLinkItem(String deviceId, DeviceLink item) async {
    dprint("Updating link for $deviceId");
    final baseURL = getBaseURL();
    if (baseURL != "") {
      String url = '$baseURL/api.php/devices/$deviceId/links';
      Map<String, dynamic>? params = {
        'link_id': item.id,
        'device1_id': item.device1_id,
        'device2_id': item.device2_id,
        'link_type': item.link_type,
        'link_settings': jsonEncode(item.link_settings),
        'active': item.active ? '1' : '0'
      };
      String response = await postURL(url, params);
      dprint("Response: " + response);
      if (response != '') {
        return true;
      }
    }
    return false;
  }

  Future<bool?> deleteLinkItem(String deviceId, DeviceLink item) async {
    dprint("Deleting link for $deviceId");
    final baseURL = getBaseURL();
    if (baseURL != "") {
      String url = '$baseURL/api.php/devices/$deviceId/links';
      Map<String, dynamic>? params = {
        'link_id': item.id,
      };
      String response = await deleteURL(url, params);
      if (response != '') {
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool?> updateScheduleItem(
      String deviceId, DeviceSchedulePoint item) async {
    dprint("Updating schedule point for $deviceId");
    final baseURL = getBaseURL();

    if (baseURL != "") {
      String url = '$baseURL/api.php/devices/$deviceId/schedule';
      Map<String, dynamic>? params = {
        'point_id': item.id,
        'linked_method': item.linkedMethod,
        'value': item.value,
        'set_time': item.setTime,
        'set_days': item.setDays
      };
      String response = await postURL(url, params);
      if (response != '') {
        return true;
      }
    }
    return false;
  }

  Future<bool?> deleteScheduleItem(
      String deviceId, DeviceSchedulePoint item) async {
    dprint("Deleting schedule point for $deviceId");
    final baseURL = getBaseURL();

    if (baseURL != "") {
      String url = '$baseURL/api.php/devices/$deviceId/schedule';
      Map<String, dynamic>? params = {
        'point_id': item.id,
      };
      String response = await deleteURL(url, params);
      if (response != '') {
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> updateDevice(String deviceId,
      [Map<String, dynamic>? params]) async {
    final baseURL = getBaseURL();
    dprint("Updating device $deviceId");
    if (baseURL != "") {
      String url = '$baseURL/api.php/devices/$deviceId';
      await postURL(url, params);
    }
  }

  @override
  Future<void> callDeviceMethod(String objectName, String method,
      [Map<String, dynamic>? params]) async {
    final baseURL = getBaseURL();
    dprint("Calling $objectName . $method");
    if (baseURL != "") {
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
