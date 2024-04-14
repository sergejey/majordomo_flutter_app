import 'package:flutter/cupertino.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/services/preferences_service.dart';
import 'package:localization/localization.dart';

class PageSettingsNotifier extends ValueNotifier<String> {
  PageSettingsNotifier() : super('');

  final _preferencesService = getIt<PreferencesService>();
  String currentProfileTitle = "";
  String currentProfileId = "";

  Future<void> initialize() async {
    // get settings
    await _preferencesService.readAllPreferences();
    currentProfileId = getProfileId();
    currentProfileTitle = getProfileTitle();
    _updatePageSettings(DateTime.now().toString());
  }

  String getProfileTitle() {
    return _preferencesService.getPreference("profile_title") ?? 'profiles_default'.i18n();
  }

  String getProfileId() {
    return _preferencesService.getProfileId() ?? '';
  }

  String? getPreference(String key) {
    return _preferencesService.getPreference(key);
  }

  Future<void> savePreference(String key, String value) async {
    _preferencesService.savePreference(key, value);
    _updatePageSettings(DateTime.now().toString());
  }

  void _updatePageSettings(String newValue) {
    value = newValue;
  }
}
