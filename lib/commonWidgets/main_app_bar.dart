import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_app/pages/page_chat.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/pages/page_main_logic.dart';
import 'package:home_app/config.dart';
import 'package:localization/localization.dart';
import './operation_modes_list.dart';

AppBar MainAppBar(context) {
  final stateManager = getIt<MainPageManager>();
  String appBarTitle = configAppDefaultTitle;
  if (stateManager.pageMainDevicesNotifier.currentRoomTitle != '') {
    appBarTitle = stateManager.pageMainDevicesNotifier.currentRoomTitle;
  } else if (stateManager.pageMainDevicesNotifier.currentProfileTitle != '') {
    appBarTitle = stateManager.pageMainDevicesNotifier.currentProfileTitle;
  }
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.surface,
        statusBarColor: Theme.of(context).colorScheme.surface,
        systemNavigationBarDividerColor: Theme.of(context).colorScheme.surface,
        systemNavigationBarContrastEnforced: true,
        systemStatusBarContrastEnforced: true
    ),
    title: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (stateManager.pageMainDevicesNotifier.currentRoomTitle != '') {
            return null;
          }
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: Text('profiles_select'.i18n()),
                  children: [
                    ...stateManager.pageMainDevicesNotifier.profiles
                        .map((value) {
                      return SimpleDialogOption(
                        child: Text(value.title),
                        onPressed: () {
                          stateManager.pageMainDevicesNotifier
                              .switchProfile(value.id);
                          Navigator.pop(context);
                        },
                      );
                    }),
                  ],
                );
              });
        },
        child: Text(appBarTitle)),
    actions: <Widget>[
      OperationalModesList(
          modes:
              stateManager.pageMainDevicesNotifier.myOperationalModesFiltered),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                  blurRadius: 5,
                  offset: Offset(0, 4), // Shadow position
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () {
                    final stateManager = getIt<MainPageManager>();

                    if (stateManager.pageMainDevicesNotifier.myOperationalModesFiltered.length<=1) return null;

                    stateManager.endPeriodicUpdate();
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => PageChat(),
                      ),
                    )
                        .then((value) {
                      stateManager.reload();
                    });
                  },
                  child: Icon(Icons.message_outlined,
                      color: stateManager.pageMainDevicesNotifier
                                  .myOperationalModesFiltered.length >
                              1
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onPrimary)),
            )),
      ),
    ],
  );
}
