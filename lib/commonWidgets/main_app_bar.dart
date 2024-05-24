import 'package:flutter/material.dart';
import 'package:home_app/models/profile.dart';
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
      /*
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xffb9cbe8).withOpacity(0.6),
                    blurRadius: 5,
                    offset: Offset(0, 4), // Shadow position
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor:
                stateManager.pageMainDevicesNotifier.roomView
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                child: IconButton(
                  icon: Icon(Icons.roofing, color: stateManager.pageMainDevicesNotifier.roomView?Theme.of(context).colorScheme.onPrimary:Theme.of(context).primaryColor),
                  tooltip: 'Room view',
                  onPressed: () {
                    stateManager.pageMainDevicesNotifier
                        .toggleRoomView();
                  },
                ),
              ),
            )),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xffb9cbe8).withOpacity(0.6),
                    blurRadius: 5,
                    offset: Offset(0, 4), // Shadow position
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor:
                stateManager.pageMainDevicesNotifier.activeFilter
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                child: IconButton(
                  icon: Icon(Icons.filter_alt_outlined, color: stateManager.pageMainDevicesNotifier.activeFilter?Theme.of(context).colorScheme.onPrimary:Theme.of(context).primaryColor),
                  tooltip: 'Active devices',
                  onPressed: () {
                    stateManager.toggleActiveFilter();
                  },
                ),
              ),
            ))
         */
    ],
  );
}
