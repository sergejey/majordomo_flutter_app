import './page_profiles_notifier.dart';

class ProfilesPageManager {
  final pageProfilesNotifier = PageProfilesNotifier();

  void initProfilesPageState() {
    pageProfilesNotifier.initialize();
  }

  void dispose() {}

  void addProfile(String profileTitle) {
    pageProfilesNotifier.addProfile(profileTitle);
  }

  void setProfileTitle(String profileTitle) {
    pageProfilesNotifier.setProfileTitle(profileTitle);
  }

  void switchProfile(String profileId) {
    pageProfilesNotifier.switchProfile(profileId);
  }

  void deleteProfile() {
    pageProfilesNotifier.deleteProfile();
  }

  void setAppSetting(String key, String value) {
    pageProfilesNotifier.savePreference(key, value);
  }

  String? getAppSetting(String key) {
    String? value = pageProfilesNotifier.getPreference(key);
    return value;
  }
}
