import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import '../services/service_locator.dart';
import './page_settings_logic.dart';
import 'package:prompt_dialog/prompt_dialog.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({super.key});

  @override
  State<PageSettings> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<PageSettings> {
  final stateManager = getIt<SettingsPageManager>();

  @override
  void initState() {
    stateManager.initSettingsPageState();
    super.initState();
  }

  @override
  void dispose() {
    stateManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateManager = getIt<SettingsPageManager>();
    return ValueListenableBuilder<String>(
        valueListenable: stateManager.pageSettingsNotifier,
        builder: (context, value, child) {
          return Scaffold(
              appBar: AppBar(title: const Text('Settings')),
              body: SettingsList(platform: DevicePlatform.android, sections: [
                SettingsSection(tiles: [
                  SettingsTile(
                    title: const Text('Mode'),
                    leading: const Icon(Icons.find_in_page_outlined),
                    value: Text(
                        stateManager.getAppSetting("serverMode") ??
                            "n/a"),
                    onPressed: (context) async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            title: Text("Select profile"),
                            children: [
                              SimpleDialogOption(
                                child: Text("Auto"),
                                onPressed: () {
                                  stateManager.setAppSetting("serverMode", "auto");
                                  Navigator.pop(context);
                                },
                              ),
                              SimpleDialogOption(
                                child: Text("Local"),
                                onPressed: () {
                                  stateManager.setAppSetting("serverMode", "local");
                                  Navigator.pop(context);
                                },
                              ),
                              SimpleDialogOption(
                                child: Text("Remote"),
                                onPressed: () {
                                  stateManager.setAppSetting("serverMode", "remote");
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
                    title: const Text('Local address'),
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
                    title: const Text('Remote address'),
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
                    title: const Text('Local WiFi SSID'),
                    leading: const Icon(Icons.wifi),
                    value: Text(
                        stateManager.getAppSetting("localWifiSSID") ?? "n/a"),
                    onPressed: (context) async {
                      String oldValue =
                          stateManager.getAppSetting("localWifiSSID") ?? "";

                      String currentWifiSSID = "";

                      if (await Permission.locationWhenInUse
                          .request()
                          .isGranted) {
                        final info = NetworkInfo();
                        currentWifiSSID = await info.getWifiName() ?? "";
                        currentWifiSSID = currentWifiSSID.replaceAll('"', '');
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
                    title: const Text('Reset WiFi SSID'),
                    leading: const Icon(Icons.wifi_protected_setup),
                    onPressed: (context) async {
                      String currentWifiSSID = "";
                      if (await Permission.locationWhenInUse
                          .request()
                          .isGranted) {
                        final info = NetworkInfo();
                        currentWifiSSID = await info.getWifiName() ?? "";
                        currentWifiSSID = currentWifiSSID.replaceAll('"', '');
                        stateManager.setAppSetting(
                            "localWifiSSID", currentWifiSSID);
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Cannot get current WiFi name...');
                      }
                    },
                  ),
                  SettingsTile(
                    title: const Text('Username'),
                    leading: const Icon(Icons.man),
                    value: Text(
                        stateManager.getAppSetting("serverUsername") ?? "n/a"),
                    onPressed: (context) async {
                      String? newValue = await prompt(context,
                          initialValue:
                          stateManager.getAppSetting("serverUsername") ??
                              "");
                      if (newValue != null) {
                        stateManager.setAppSetting(
                            "serverUsername", newValue.toString());
                      }
                    },
                  ),
                  SettingsTile(
                    title: const Text('Password'),
                    leading: const Icon(Icons.password),
                    value: Text(
                        (stateManager.getAppSetting("serverPassword") ?? "") !=
                            ""
                            ? "***"
                            : "n/a"),
                    onPressed: (context) async {
                      String? newValue = await prompt(context,
                          initialValue:
                          stateManager.getAppSetting("serverPassword") ??
                              "");
                      if (newValue != null) {
                        stateManager.setAppSetting(
                            "serverPassword", newValue.toString());
                      }
                    },
                  ),

                ])
              ]));
        });
  }
}
