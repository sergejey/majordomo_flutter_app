import 'package:flutter/material.dart';
import 'package:oauth_webauth/oauth_webauth.dart';
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
          String connectAccessToken =
              stateManager.getAppSetting("connectAccessToken") ?? "";
          return Scaffold(
              appBar: AppBar(title: const Text('Settings')),
              body: SettingsList(platform: DevicePlatform.android, sections: [
                SettingsSection(tiles: [
                  SettingsTile(
                      title: const Text('CONNECT'),
                      leading: const Icon(Icons.verified_user),
                      value: connectAccessToken == ''
                          ? const Text('Not authorized')
                          : const Text('Authorized'),
                      onPressed: (context) async {
                        if (connectAccessToken=='') {
                          loginV2();
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                title: Text("CONNECT"),
                                children: [
                                  SimpleDialogOption(
                                    child: Text("Re-login"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      loginV2();
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
                    title: const Text('Mode'),
                    leading: const Icon(Icons.find_in_page_outlined),
                    value:
                        Text(stateManager.getAppSetting("serverMode") ?? "n/a"),
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
                                  stateManager.setAppSetting(
                                      "serverMode", "auto");
                                  Navigator.pop(context);
                                },
                              ),
                              SimpleDialogOption(
                                child: Text("Local"),
                                onPressed: () {
                                  stateManager.setAppSetting(
                                      "serverMode", "local");
                                  Navigator.pop(context);
                                },
                              ),
                              SimpleDialogOption(
                                child: Text("Remote"),
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

  void loginV2() {
    OAuthWebScreen.start(
      context: context,
      configuration: OAuthConfiguration(
          authorizationEndpointUrl:
              'https://connect.smartliving.ru/oauth2/authorize.php',
          tokenEndpointUrl: 'https://connect.smartliving.ru/oauth2/token.php',
          clientSecret: 'FlutterAppSecret',
          clientId: 'MajorDoMoFlutterApp',
          redirectUrl: 'https://connect.smartliving.ru/',
          scopes: ['basic'],
          promptValues: const ['login'],
          loginHint: 'johndoe@mail.com',
          onCertificateValidate: (certificate) {
            ///This is recommended
            /// Do certificate validations here
            /// If false is returned then a CertificateException() will be thrown
            return true;
          },
          refreshBtnVisible: false,
          clearCacheBtnVisible: false,
          onSuccessAuth: (credentials) {
            //print("Access token received: ");
            //print(credentials.accessToken);
            stateManager.setAppSetting(
                "connectAccessToken", credentials.accessToken);

            if ((stateManager.getAppSetting("serverAddressRemote") ?? "") == "") {
              stateManager.setAppSetting("serverAddressRemote",'connect.smartliving.ru');
            }
            if ((stateManager.getAppSetting("serverMode") ?? "") == "") {
              stateManager.setAppSetting("serverMode",'auto');
            }
          },
          onError: (error) {
            print("oAuth error: ");
            print(error);
          },
          onCancel: () {
            print("oAuth cancelled.");
          }),
    );
  }
}
