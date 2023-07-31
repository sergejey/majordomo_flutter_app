import "dart:async";
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {

  final _data = <String,dynamic>{};

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> readAllPreferences() async {
    //
    final SharedPreferences prefs = await _prefs;
    var keys = prefs.getKeys();
    for (var element in keys) {
      _data[element] = prefs.getString(element);
    }
  }

  String? getPreference(String key) {
    return _data[key];
  }

  Future<void> savePreference(String key, String value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(key, value);
    //print("Setting of $key saved.");
    _data[key] = value;
  }
}