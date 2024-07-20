import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_app/pages/page_settings_notifier.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'dart:convert';
import 'package:oauth_webauth/oauth_webauth.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

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

  void loginV2(BuildContext context) {
    OAuthWebScreen.start(
      context: context,
      configuration: OAuthConfiguration(
          authorizationEndpointUrl:
              'https://connect.smartliving.ru/oauth2/authorize.php',
          tokenEndpointUrl: 'https://connect.smartliving.ru/oauth2/token.php',
          clientSecret: 'FlutterAppSecret',
          clientId: 'MajorDoMoFlutterApp',
          redirectUrl: 'https://majordroidng.app/',
          scopes: ['basic'],
          promptValues: const ['login'],
          loginHint: 'johndoe@mail.com',
          onCertificateValidate: (certificate) {
            return true;
          },
          refreshBtnVisible: false,
          clearCacheBtnVisible: false,
          onSuccessAuth: (credentials) async {
            setAppSetting("connectAccessToken", credentials.accessToken);
            if ((getAppSetting("serverAddressRemote") ?? "") == "") {
              setAppSetting("serverAddressRemote", 'connect.smartliving.ru');
            }
            if ((getAppSetting("serverMode") ?? "") == "") {
              setAppSetting("serverMode", 'auto');
            }
            //Send firebase token to server if available
            FirebaseMessaging _fcm = FirebaseMessaging.instance;
            String token = await _fcm.getToken() ?? '';
            if (token != '') {
              String deviceName = 'MJD';
              final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

              if (defaultTargetPlatform == TargetPlatform.android) {
                AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                deviceName += ' '+androidInfo.brand + ' ' + androidInfo.model;
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
                deviceName+= ' ' + iosInfo.name;
              }

              String goURL =
                  'https://connect.smartliving.ru/register_push.php?token=' +
                      token +
                      '&terminal=' +
                      Uri.encodeComponent(deviceName.trim());

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

              var platform = Theme.of(context).platform;
              if (platform == TargetPlatform.iOS) {
                FirebaseMessaging messaging = FirebaseMessaging.instance;
                NotificationSettings settings =
                    await messaging.requestPermission(
                  alert: true,
                  announcement: false,
                  badge: true,
                  carPlay: false,
                  criticalAlert: false,
                  provisional: false,
                  sound: true,
                );
                if (settings.authorizationStatus ==
                    AuthorizationStatus.authorized) {
                  print('User granted permission');
                } else if (settings.authorizationStatus ==
                    AuthorizationStatus.provisional) {
                  print('User granted provisional permission');
                } else {
                  print('User declined or has not accepted permission');
                }
              }

              if (response.statusCode == 200) {
                final parsed =
                    jsonDecode(response.body) as Map<String, dynamic>;
                if (parsed.containsKey("serverAddressRemote") &&
                    (getAppSetting("serverAddressRemote") ?? "") == "") {
                  setAppSetting(
                      "serverAddressRemote", parsed["serverAddressRemote"]);
                }
                if (parsed.containsKey("serverAddressLocal") &&
                    (getAppSetting("serverAddressLocal") ?? "") == "") {
                  setAppSetting(
                      "serverAddressLocal", parsed["serverAddressLocal"]);
                  if ((getAppSetting("localWifiSSID") ?? "") == "") {
                    String currentWifiSSID = "";
                    if (await Permission.locationWhenInUse
                        .request()
                        .isGranted) {
                      final info = NetworkInfo();
                      currentWifiSSID = await info.getWifiName() ?? "";
                      currentWifiSSID = currentWifiSSID.replaceAll('"', '');
                      if (currentWifiSSID != "") {
                        setAppSetting("localWifiSSID", currentWifiSSID);
                      }
                    }
                  }
                }
              }
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
