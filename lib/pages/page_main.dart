import 'dart:async';

import 'package:flutter/services.dart';
import 'package:home_app/commonWidgets/devices_list.dart';
import 'package:home_app/commonWidgets/groups_list.dart';
import 'package:home_app/commonWidgets/main_app_bar.dart';
import 'package:home_app/commonWidgets/rooms_list.dart';

import 'package:flutter/material.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/pages/page_main_logic.dart';

import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:localization/localization.dart';

import '../commonWidgets/bottom_app_bar.dart';

class PageMain extends StatefulWidget {
  const PageMain({super.key, required this.title});

  final String title;

  @override
  State<PageMain> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PageMain> {
  late Timer timer;
  final stateManager = getIt<MainPageManager>();
  var isDialOpen = ValueNotifier<bool>(false);

  @override
  void initState() {
    stateManager.initMainPageState();
    super.initState();
  }

  @override
  void dispose() {
    stateManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateManager = getIt<MainPageManager>();
    return ValueListenableBuilder<String>(
      valueListenable: stateManager.pageMainDevicesNotifier,
      builder: (context, value, child) {
        return FGBGNotifier(
          onEvent: (event) {
            if (event == FGBGType.foreground) {
              stateManager.reload();
            } else if (event == FGBGType.background) {
              stateManager.endPeriodicUpdate();
            }
          },
          child: PopScope(
            canPop: stateManager.canBeClosed(),
            onPopInvoked: (bool didPop) async {
              if (didPop) {
                return;
              }
              final bool? shouldPop = await stateManager.allowToClose();
              if (shouldPop ?? false) {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              }
            },
            child: Scaffold(
              backgroundColor: const Color(0xffe3eeff),
              appBar: MainAppBar(context),
              bottomNavigationBar: bottomAppBar(context),
              body: stateManager.pageMainDevicesNotifier.roomView
                  ? RoomsList(
                      rooms: stateManager.pageMainDevicesNotifier.myRooms)
                  : Column(children: [
                      (stateManager.appView == 'home' &&
                              !stateManager
                                  .pageMainDevicesNotifier.isSetupRequired)
                          ? GroupsList(
                              groups:
                                  stateManager.pageMainDevicesNotifier.myGroups)
                          : const SizedBox(
                              height: 1,
                            ),
                      Expanded(
                          child: stateManager
                                  .pageMainDevicesNotifier.isSetupRequired
                              ? Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: GestureDetector(
                                              onTap: () {
                                                stateManager.openSettings(
                                                    context, "");
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                        Radius.circular(20),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: const Color(
                                                                  0xffb9cbe8)
                                                              .withOpacity(0.6),
                                                          blurRadius: 11,
                                                          offset: Offset(0,
                                                              4), // Shadow position
                                                        ),
                                                      ]),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(
                                                        18.0),
                                                    child: Text(
                                                        'setup_required'.i18n()),
                                                  ))),
                                        ),
                                        Text('setup_or'.i18n()),
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: GestureDetector(
                                              onTap: () {
                                                stateManager.openSettings(
                                                    context, "login");
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                        Radius.circular(20),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: const Color(
                                                                  0xffb9cbe8)
                                                              .withOpacity(0.6),
                                                          blurRadius: 11,
                                                          offset: Offset(0,
                                                              4), // Shadow position
                                                        ),
                                                      ]),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(
                                                        18.0),
                                                    child: Text(
                                                        'setup_login'.i18n()),
                                                  ))),
                                        ),
                                      ]),
                              )
                              : DevicesList(
                                  devices: stateManager
                                      .pageMainDevicesNotifier.myDevices))
                    ]),
            ),
          ),
        );
      },
    );
  }
}
