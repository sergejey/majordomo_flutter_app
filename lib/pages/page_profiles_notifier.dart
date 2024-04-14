import 'package:flutter/cupertino.dart';
import '../services/service_locator.dart';
import '../services/preferences_service.dart';
import 'package:localization/localization.dart';
import '../models/profile.dart';

class PageProfilesNotifier extends ValueNotifier<String> {
  PageProfilesNotifier() : super('');

  final _preferencesService = getIt<PreferencesService>();
  String currentProfileId = "";
  String currentProfileTitle = "";

  Future<void> initialize() async {
    // get settings
    await _preferencesService.readAllPreferences();
    currentProfileId = _preferencesService.getProfileId();
    currentProfileTitle =
        _preferencesService.getPreference("profile_title") ?? 'profiles_default'.i18n();
    _updatePageProfiles(DateTime.now().toString());
  }

  Future<List<Profile>> getProfiles() async {
    return _preferencesService.getProfiles();
  }

  void addProfile(String profileTitle) async {
    await _preferencesService.addProfile(profileTitle);
    initialize();
  }

  void setProfileTitle(String profileTitle) {
    _preferencesService.setProfileTitle(currentProfileId, profileTitle);
    currentProfileTitle = profileTitle;
    initialize();
  }

  void switchProfile(String profileId) async {
    _preferencesService.setProfileId(profileId);
    initialize();
  }

  void deleteProfile() async {
    await _preferencesService.deleteProfile(currentProfileId);
    initialize();
  }

  String? getPreference(String key) {
    return _preferencesService.getPreference(key);
  }

  Future<void> savePreference(String key, String value) async {
    _preferencesService.savePreference(key, value);
    _updatePageProfiles(DateTime.now().toString());
  }

  void _updatePageProfiles(String newValue) {
    value = newValue;
  }
}
