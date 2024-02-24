import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:oauth_webauth/oauth_webauth.dart';
import 'package:settings_ui/settings_ui.dart';
import '../main.dart';
import '../services/service_locator.dart';
import './page_settings_logic.dart';
import 'package:prompt_dialog/prompt_dialog.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
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
              body: SettingsList(platform: DevicePlatform.android, sections: [
                SettingsSection(tiles: [
                  SettingsTile(
                      title: Text("connect".i18n()),
                      leading: const Icon(Icons.verified_user),
                      value: connectAccessToken == ''
                          ? Text("not-authorized".i18n())
                          : Text('authorized'.i18n()),
                      onPressed: (context) async {
                        if (connectAccessToken == '') {
                          loginV2();
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
                    title: Text('mode'.i18n()),
                    leading: const Icon(Icons.find_in_page_outlined),
                    value:
                        Text(stateManager.getAppSetting("serverMode")?.i18n()?? "auto"),
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
                    title: Text('reset-wifi-ssid'.i18n()),
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
                    title: Text('username'.i18n()),
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
                    title: Text('password'.i18n()),
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
                  SettingsTile(
                    title: Text('language'.i18n()),
                    leading: const Icon(Icons.language),
                    value: Text(
                        stateManager.getAppSetting("language")?.i18n() ?? "Русский"),
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
                                  final myApp = context
                                      .findAncestorStateOfType<MyAppState>()!;
                                  myApp.changeLocale(Locale('en', 'US'));
                                  Navigator.pop(context);
                                },
                              ),
                              SimpleDialogOption(
                                child: Text("russian".i18n()),
                                onPressed: () {
                                  stateManager.setAppSetting(
                                      "language", "russian");
                                  final myApp = context
                                      .findAncestorStateOfType<MyAppState>()!;
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
                    value: Text('app_version'.i18n()+' '+_packageInfo.version+' '+'app_build'.i18n()+' '+_packageInfo.buildNumber)
                  ),
                ]),
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
          onSuccessAuth: (credentials) async {
            stateManager.setAppSetting(
                "connectAccessToken", credentials.accessToken);
            if ((stateManager.getAppSetting("serverAddressRemote") ?? "") ==
                "") {
              stateManager.setAppSetting(
                  "serverAddressRemote", 'connect.smartliving.ru');
            }
            if ((stateManager.getAppSetting("serverMode") ?? "") == "") {
              stateManager.setAppSetting("serverMode", 'auto');
            }
            //Send firebase token to server if available
            FirebaseMessaging _fcm = FirebaseMessaging.instance;
            String token = await _fcm.getToken() ?? '';
            if (token != '') {
              String goURL =
                  'https://connect.smartliving.ru/register_push.php?token=' +
                      token;
              String userName = 'access_token';
              String password = credentials.accessToken;
              String basicCredentials = "$userName:$password";
              Codec<String, String> stringToBase64 = utf8.fuse(base64);
              String encoded = stringToBase64.encode(basicCredentials);
              String basicAuth = 'Basic ' + encoded;
              final http.Response response;
              final http.Client client = http.Client();
              response = await client.get(Uri.parse(goURL),
                  headers: <String, String>{
                    'Authorization': basicAuth
                  }).timeout(const Duration(seconds: 10));
              print("Token authorization response: " + response.body);
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
