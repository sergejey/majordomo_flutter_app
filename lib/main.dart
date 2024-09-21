import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:home_app/pages/page_main.dart';
import 'package:home_app/services/push_notifications.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/services/preferences_service.dart';
import 'package:localization/localization.dart';
import 'package:oauth_webauth/oauth_webauth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:home_app/utils/theme.dart';

void main() async {
  setupGetIt();
  WidgetsFlutterBinding.ensureInitialized();
  await OAuthWebAuth.instance.init();
  await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  Locale? _locale;
  ThemeMode? _selectedThemeMode;
  final PushNotificationService _notificationService = PushNotificationService();

  Future<void> loadSettings() async {
    final _preferencesService = getIt<PreferencesService>();
    await _preferencesService.readAllPreferences();
    String localeSetting = _preferencesService.getPreference('language')??''; // russian, english
    if (localeSetting!='') {
      if (localeSetting == 'russian') {
        changeLocale(const Locale('ru', 'RU'));
      }
      if (localeSetting == 'english') {
        changeLocale(const Locale('en', 'US'));
      }
    }
    String themeSetting = _preferencesService.getPreference('theme')??''; // dark, light, auto
    if (themeSetting!='') {
      if (themeSetting == 'theme_dark') {
        changeThemeMode(ThemeMode.dark);
      }
      if (themeSetting == 'theme_light') {
        changeThemeMode(ThemeMode.light);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  changeThemeMode(ThemeMode newThemeMode) {
    setState(() {
      _selectedThemeMode = newThemeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['assets/lang'];
    _notificationService.initialize();
    return MaterialApp(
      title: 'MajorDoMo NG',
      locale: _locale,
      localeResolutionCallback: (locale, supportedLocales) {
        if (supportedLocales.contains(locale)) {
          return locale;
        }
        if (locale?.languageCode == 'ru') {
          return const Locale('ru', 'RU');
        }
        return const Locale('en', 'US');
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocalJsonLocalization.delegate,
      ],
      supportedLocales: const [
        Locale('ru', 'Ru'),
        Locale('en', 'US'),
      ],
      debugShowCheckedModeBanner: false,
      theme: lightAppTheme,
      darkTheme: darkAppTheme,
      themeMode: _selectedThemeMode??ThemeMode.system,
      home: const PageMain(title: 'MajorDoMo NG'),
    );
  }
}
