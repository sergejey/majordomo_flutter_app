import 'package:home_app/pages/page_settings_notifier.dart';

class SettingsPageManager {
  final pageSettingsNotifier = PageSettingsNotifier();

  void initSettingsPageState() {
    pageSettingsNotifier.initialize();
  }

  void dispose() {}

  void setAppSetting(String key, String value) {
    pageSettingsNotifier.savePreference(key, value);
  }

  String? getAppSetting(String key) {
    String? value = pageSettingsNotifier.getPreference(key);
    return value;
  }
}
