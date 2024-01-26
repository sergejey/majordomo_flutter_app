import 'package:flutter/material.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/pages/page_main.dart';
import 'package:oauth_webauth/oauth_webauth.dart';

void main() async {
  setupGetIt();
  WidgetsFlutterBinding.ensureInitialized();
  await OAuthWebAuth.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MajorDoMo NG',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PageMain(title: 'MajorDoMo NG'),
    );
  }
}

