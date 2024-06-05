import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:settings_ui/settings_ui.dart';
import '../main.dart';
import '../services/service_locator.dart';
import './page_settings_logic.dart';
import './page_profiles.dart';
import 'package:prompt_dialog/prompt_dialog.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({super.key});

  @override
  State<PageSettings> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<PageSettings> {
  final stateManager = getIt<SettingsPageManager>();

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    stateManager.initSettingsPageState();
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void dispose() {
    stateManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final stateManager = getIt<SettingsPageManager>();
    return ValueListenableBuilder<String>(
        valueListenable: stateManager.pageSettingsNotifier,
        builder: (context, value, child) {
          String connectAccessToken =
              stateManager.getAppSetting("connectAccessToken") ?? "";

          return Scaffold(
              appBar:
                  AppBar(title: Text("nav_settings".i18n([locale.toString()]))),
              body: SettingsList(
                  platform: DevicePlatform.android,
                  lightTheme: SettingsThemeData(
                      dividerColor: Theme.of(context).colorScheme.onPrimary,
                      tileDescriptionTextColor: Theme.of(context).primaryColor,
                      leadingIconsColor: Theme.of(context).primaryColor,
                      settingsListBackground:  Theme.of(context).colorScheme.onPrimary,
                      settingsSectionBackground:  Theme.of(context).colorScheme.onPrimary,
                      settingsTileTextColor: Theme.of(context).primaryColor,
                      tileHighlightColor: Theme.of(context).primaryColor,
                      titleTextColor: Theme.of(context).primaryColor,
                      trailingTextColor:  Theme.of(context).colorScheme.onPrimary,),
                  sections: [
                    SettingsSection(tiles: [
                      SettingsTile.navigation(
                        title: Text('profiles'.i18n()),
                        value: Text(stateManager
                            .pageSettingsNotifier.currentProfileTitle),
                        leading: const Icon(Icons.house_rounded),
                        onPressed: (context) {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => const PageProfiles(),
                            ),
                          )
                              .then((value) {
                            stateManager.initSettingsPageState();
                          });
                        },
                      ),
                      SettingsTile(
                          title: Text("connect".i18n()),
                          leading: const Icon(Icons.verified_user),
                          value: connectAccessToken == ''
                              ? Text("not-authorized".i18n())
                              : Text('authorized'.i18n()),
                          onPressed: (context) async {
                            if (connectAccessToken == '') {
                              stateManager.loginV2(context);
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SimpleDialog(
                                    title: Text("connect".i18n()),
                                    children: [
                                      SimpleDialogOption(
                                        child: Text("Re-login"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          stateManager.loginV2(context);
                                        },
                                      ),
                                      SimpleDialogOption(
                                        child: Text("Logoff"),
                                        onPressed: () {
                                          stateManager.setAppSetting(
                                              "connectAccessToken", "");
                                          Navigator.pop(context);
                                        },
                                      ),
                                      SimpleDialogOption(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }),
                      SettingsTile(
                        title: Text('mode'.i18n()),
                        leading: const Icon(Icons.find_in_page_outlined),
                        value: Text(
                            stateManager.getAppSetting("serverMode")?.i18n() ??
                                "auto"),
                        onPressed: (context) async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                title: Text("select-profile".i18n()),
                                children: [
                                  SimpleDialogOption(
                                    child: Text("auto".i18n()),
                                    onPressed: () {
                                      stateManager.setAppSetting(
                                          "serverMode", "auto");
                                      Navigator.pop(context);
                                    },
                                  ),
                                  SimpleDialogOption(
                                    child: Text("local".i18n()),
                                    onPressed: () {
                                      stateManager.setAppSetting(
                                          "serverMode", "local");
                                      Navigator.pop(context);
                                    },
                                  ),
                                  SimpleDialogOption(
                                    child: Text("remote".i18n()),
                                    onPressed: () {
                                      stateManager.setAppSetting(
                                          "serverMode", "remote");
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      SettingsTile(
                        title: Text('local-address'.i18n()),
                        leading: const Icon(Icons.wifi),
                        value: Text(
                            stateManager.getAppSetting("serverAddressLocal") ??
                                "n/a"),
                        onPressed: (context) async {
                          String? newValue = await prompt(context,
                              initialValue: stateManager
                                      .getAppSetting("serverAddressLocal") ??
                                  "");
                          if (newValue != null) {
                            stateManager.setAppSetting(
                                "serverAddressLocal", newValue.toString());
                          }
                        },
                      ),
                      SettingsTile(
                        title: Text('remote-address'.i18n()),
                        leading: const Icon(Icons.network_cell),
                        value: Text(
                            stateManager.getAppSetting("serverAddressRemote") ??
                                "n/a"),
                        onPressed: (context) async {
                          String? newValue = await prompt(context,
                              initialValue: stateManager
                                      .getAppSetting("serverAddressRemote") ??
                                  "");
                          if (newValue != null) {
                            stateManager.setAppSetting(
                                "serverAddressRemote", newValue.toString());
                          }
                        },
                      ),
                      SettingsTile(
                        title: Text('local-wifi-ssid'.i18n()),
                        leading: const Icon(Icons.wifi),
                        value: Text(
                            stateManager.getAppSetting("localWifiSSID") ??
                                "n/a"),
                        onPressed: (context) async {
                          String oldValue =
                              stateManager.getAppSetting("localWifiSSID") ?? "";

                          String currentWifiSSID = "";

                          if (await Permission.locationWhenInUse
                              .request()
                              .isGranted) {
                            final info = NetworkInfo();
                            currentWifiSSID = await info.getWifiName() ?? "";
                            currentWifiSSID =
                                currentWifiSSID.replaceAll('"', '');
                          }

                          if (oldValue == "" && currentWifiSSID != "") {
                            oldValue = currentWifiSSID;
                          }

                          String? newValue =
                              await prompt(context, initialValue: oldValue);
                          if (newValue != null) {
                            stateManager.setAppSetting(
                                "localWifiSSID", newValue.toString());
                          }
                        },
                      ),
                      SettingsTile(
                        title: Text('reset-wifi-ssid'.i18n()),
                        leading: const Icon(Icons.wifi_protected_setup),
                        onPressed: (context) async {
                          String currentWifiSSID = "";
                          if (await Permission.locationWhenInUse
                              .request()
                              .isGranted) {
                            final info = NetworkInfo();
                            currentWifiSSID = await info.getWifiName() ?? "";
                            currentWifiSSID =
                                currentWifiSSID.replaceAll('"', '');
                            stateManager.setAppSetting(
                                "localWifiSSID", currentWifiSSID);
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Cannot get current WiFi name...');
                          }
                        },
                      ),
                      SettingsTile(
                        title: Text('username'.i18n()),
                        leading: const Icon(Icons.man),
                        value: Text(
                            stateManager.getAppSetting("serverUsername") ??
                                "n/a"),
                        onPressed: (context) async {
                          String? newValue = await prompt(context,
                              initialValue: stateManager
                                      .getAppSetting("serverUsername") ??
                                  "");
                          if (newValue != null) {
                            stateManager.setAppSetting(
                                "serverUsername", newValue.toString());
                          }
                        },
                      ),
                      SettingsTile(
                        title: Text('password'.i18n()),
                        leading: const Icon(Icons.password),
                        value: Text(
                            (stateManager.getAppSetting("serverPassword") ??
                                        "") !=
                                    ""
                                ? "***"
                                : "n/a"),
                        onPressed: (context) async {
                          String? newValue = await prompt(context,
                              initialValue: stateManager
                                      .getAppSetting("serverPassword") ??
                                  "");
                          if (newValue != null) {
                            stateManager.setAppSetting(
                                "serverPassword", newValue.toString());
                          }
                        },
                      ),
                      SettingsTile(
                        title: Text('language'.i18n()),
                        leading: const Icon(Icons.language),
                        value: Text(
                            stateManager.getAppSetting("language")?.i18n() ??
                                "Русский"),
                        onPressed: (context) async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                title: Text("select-language".i18n()),
                                children: [
                                  SimpleDialogOption(
                                    child: Text("english".i18n()),
                                    onPressed: () {
                                      stateManager.setAppSetting(
                                          "language", "english");
                                      final myApp =
                                          context.findAncestorStateOfType<
                                              MyAppState>()!;
                                      myApp.changeLocale(Locale('en', 'US'));
                                      Navigator.pop(context);
                                    },
                                  ),
                                  SimpleDialogOption(
                                    child: Text("russian".i18n()),
                                    onPressed: () {
                                      stateManager.setAppSetting(
                                          "language", "russian");
                                      final myApp =
                                          context.findAncestorStateOfType<
                                              MyAppState>()!;
                                      myApp.changeLocale(Locale('ru', 'RU'));
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      SettingsTile(
                          title: Text('about_app'.i18n()),
                          leading: const Icon(Icons.info_outline),
                          value: Text('app_version'.i18n() +
                              ' ' +
                              _packageInfo.version +
                              ' ' +
                              'app_build'.i18n() +
                              ' ' +
                              _packageInfo.buildNumber)),
                    ]),
                  ]));
        });
  }


}
