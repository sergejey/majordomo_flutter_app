import "dart:async";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localization/localization.dart';
import '../models/profile.dart';

class PreferencesService {

  String _profileId = '';
  String _profileTitle = '';
  final _data = <String,dynamic>{};

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> readAllPreferences() async {
    //
    final SharedPreferences prefs = await _prefs;
    var keys = prefs.getKeys();
    for (var element in keys) {
      _data[element] = prefs.getString(element);
    }
    _profileId = _data["profile_id"] ?? "";
    if (_profileId != "") {
      _profileTitle = prefs.getString("prof_${_profileId}_profile_title")??"";
    } else {
      _profileTitle = prefs.getString("profile_title")??"";
    }
  }

  String getProfileId() {
    return _profileId;
  }

  String getProfileTitle() {
    return _profileTitle;
  }

  void setProfileId(String Id) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("profile_id", Id);
    _data["profile_id"] = Id;
    _profileId = Id;
    if (Id != "") {
      _profileTitle = prefs.getString("prof_${Id}_profile_title")??"";
    } else {
      _profileTitle = prefs.getString("profile_title")??"";
    }
  }

  void setProfileTitle(String Id, String profileTitle) async {
    final SharedPreferences prefs = await _prefs;
    if (Id != "") {
      prefs.setString("prof_${Id}_profile_title", profileTitle);
    } else {
      prefs.setString("profile_title", profileTitle);
    }
    _profileTitle = profileTitle;
  }

  Future<void> addProfile(String profileTitle) async {
    final SharedPreferences prefs = await _prefs;
    String profileList = prefs.getString("list_of_profiles") ?? "";
    List<String> profilesString = profileList.split(";");

    String newId = DateTime.now().millisecondsSinceEpoch.toString();
    profilesString.add(newId);
    prefs.setString("list_of_profiles", profilesString.join(";"));
    setProfileTitle(newId, profileTitle);
    setProfileId(newId);
  }

  Future<List<Profile>> getProfiles() async {
    final SharedPreferences prefs = await _prefs;
    List<Profile> profiles = [];
    profiles.add(Profile(id: '', title: _data["profile_title"] ?? 'profiles_default'.i18n()));
    String profileList = prefs.getString("list_of_profiles") ?? "";
    if (profileList != "") {
      List<String> profilesString = profileList.split(";");
      for (var item in profilesString) {
        if (item == "") continue;
        String profileTitle = _data["prof_${item}_profile_title"] ?? item;
        profiles.add(Profile(id: item, title: profileTitle));
      }
    }
    return profiles;
  }

  Future<void> deleteProfile(String Id) async {
    if (Id != '') {
      final SharedPreferences prefs = await _prefs;
      var keys = prefs.getKeys();
      for (var element in keys) {
        if (element.startsWith("prof_${Id}_")) {
          prefs.remove(element);
        }
      }
      String profileList = prefs.getString("list_of_profiles") ?? "";
      if (profileList != "") {
        List<String> profiles = profileList.split(";");
        for (var item in profiles) {
          if (item == Id) {
            profiles.remove(item);
            break;
          }
        }
        prefs.setString("list_of_profiles", profiles.join(";"));
      }
    }
    setProfileId('');
  }

  bool isAppKey(String key) {
    List<String> appKeys = ['connectAccessToken','language'];
    if (appKeys.contains(key)) return true;
    return false;
  }

  String? getPreference(String key) {
    if (_profileId == '' || isAppKey(key)) {
      return _data[key];
    } else {
      return _data["prof_${_profileId}_${key}"];
    }
  }

  Future<void> savePreference(String key, String value) async {
    final SharedPreferences prefs = await _prefs;
    if (_profileId == '' || isAppKey(key)) {
      prefs.setString(key, value);
      _data[key] = value;
    } else {
      prefs.setString("prof_${_profileId}_${key}", value);
      _data["prof_${_profileId}_${key}"] = value;
    }
  }
}