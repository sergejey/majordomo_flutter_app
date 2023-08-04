import 'package:home_app/models/simple_device.dart';
import 'package:home_app/models/room.dart';
import 'package:home_app/models/operational_mode.dart';
import 'package:home_app/models/system_state.dart';
import 'package:home_app/models/history_record.dart';

abstract class DataService {
  String _baseURL = "";

  Future<List<Room>> fetchRooms();
  Future<List<OperationalMode>> fetchOperationalModes();
  Future<List<SystemState>> fetchSystemStates();

  Future<List<SimpleDevice>> fetchMyDevices();

  Future<SimpleDevice> fetchMyDevice(String deviceId);

  Future<void> callDeviceMethod(String objectName, String method, [Map<String , dynamic>? params]);

  Future<List<HistoryRecord>> getPropertyHistory(String objectName, String property);

  void setBaseURL(String url) {
    _baseURL = url;
  }

  String getBaseURL() {
    String url = _baseURL;
    if (!url.startsWith('http:')) url = 'http://$url';
    return url;
  }
}
