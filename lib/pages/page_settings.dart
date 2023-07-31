import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import '../services/service_locator.dart';
import './page_settings_logic.dart';
import 'package:prompt_dialog/prompt_dialog.dart';

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
                    title: const Text('Server address'),
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
                ])
              ]));
        });
  }
}
