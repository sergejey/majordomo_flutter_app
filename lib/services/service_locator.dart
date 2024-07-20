import 'package:get_it/get_it.dart';

import 'package:home_app/services/data_service.dart';
import 'package:home_app/services/data_service_local.dart';
import 'package:home_app/services/preferences_service.dart';

import 'package:home_app/pages/page_main_logic.dart';
import 'package:home_app/pages/page_device_logic.dart';
import 'package:home_app/pages/page_edit_device_logic.dart';
import 'package:home_app/pages/page_settings_logic.dart';
import 'package:home_app/pages/page_modes_logic.dart';
import 'package:home_app/pages/page_profiles_logic.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<DataService>(() => DataServiceLocal());
  getIt.registerLazySingleton<PreferencesService>(() => PreferencesService());

  getIt.registerLazySingleton<MainPageManager>(() => MainPageManager());
  getIt.registerLazySingleton<DevicePageManager>(() => DevicePageManager());
  getIt.registerLazySingleton<EditDevicePageManager>(() => EditDevicePageManager());
  getIt.registerLazySingleton<ModesPageManager>(() => ModesPageManager());
  getIt.registerLazySingleton<SettingsPageManager>(() => SettingsPageManager());
  getIt.registerLazySingleton<ProfilesPageManager>(() => ProfilesPageManager());
}
