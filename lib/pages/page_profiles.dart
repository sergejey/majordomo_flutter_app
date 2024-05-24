import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:localization/localization.dart';
import '../models/profile.dart';
import '../services/service_locator.dart';
import './page_profiles_logic.dart';
import 'package:prompt_dialog/prompt_dialog.dart';

class PageProfiles extends StatefulWidget {
  const PageProfiles({super.key});

  @override
  State<PageProfiles> createState() => _ProfilesPageState();
}

class _ProfilesPageState extends State<PageProfiles> {
  final stateManager = getIt<ProfilesPageManager>();

  @override
  void initState() {
    stateManager.initProfilesPageState();
    super.initState();
  }

  @override
  void dispose() {
    stateManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateManager = getIt<ProfilesPageManager>();
    return ValueListenableBuilder<String>(
        valueListenable: stateManager.pageProfilesNotifier,
        builder: (context, value, child) {
          return Scaffold(
              appBar: AppBar(title: Text('profiles'.i18n())),
              body: SettingsList(platform: DevicePlatform.android,
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
                  SettingsTile(
                    title: Text('profiles_current'.i18n()),
                    leading: const Icon(Icons.house_rounded),
                    value: Text(
                        stateManager.pageProfilesNotifier.currentProfileTitle),
                    onPressed: (context) async {
                      List<Profile> profiles =
                      await stateManager.pageProfilesNotifier.getProfiles();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            title: Text('profiles_select'.i18n()),
                            children: [
                              ...profiles.map((value) {
                                return SimpleDialogOption(
                                  child: Text(value.title),
                                  onPressed: () {
                                    stateManager.switchProfile(value.id);
                                    Navigator.pop(context);
                                  },
                                );
                              }),
                            ],
                          );
                        },
                      );
                      stateManager.initProfilesPageState();
                    },
                  ),
                  SettingsTile(
                    title: Text('profiles_change_title'.i18n()),
                    leading: const Icon(Icons.edit),
                    value: Text(
                        "${stateManager.pageProfilesNotifier.currentProfileTitle}"),
                    onPressed: (context) async {
                      String? newValue = await prompt(context,
                          initialValue: stateManager
                              .pageProfilesNotifier.currentProfileTitle) ??
                          "";
                      if (newValue != "") {
                        stateManager.setProfileTitle(newValue);
                      }
                    },
                  ),
                  SettingsTile(
                    title: Text('profiles_add'.i18n()),
                    leading: const Icon(Icons.add),
                    onPressed: (context) async {
                      String? newValue = await prompt(context) ?? "";
                      if (newValue != "") {
                        stateManager.addProfile(newValue);
                      }
                    },
                  ),
                  SettingsTile(
                    title: Text('profiles_delete'.i18n()),
                    leading: const Icon(Icons.remove),
                    enabled: stateManager.pageProfilesNotifier.currentProfileId!="",
                    onPressed: (context) async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('dialog_confirmation'.i18n()),
                              content: Text('dialog_are_you_sure'.i18n()),
                              actions: [
                                TextButton(
                                  child: Text('dialog_ok'.i18n()),
                                  onPressed: () {
                                    stateManager.deleteProfile();
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text('dialog_cancel'.i18n()),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          });
                    },
                  ),
                ])
              ]));
        });
  }
}
