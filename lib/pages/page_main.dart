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
              final NavigatorState navigator = Navigator.of(context);
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
                  ? RoomsList(rooms: stateManager.pageMainDevicesNotifier.myRooms)
                  : Column(children: [
                stateManager.appView == 'home'
                          ? GroupsList(
                              groups:
                                  stateManager.pageMainDevicesNotifier.myGroups)
                          : const SizedBox(height: 1,),
                      Expanded(
                          child: DevicesList(
                              devices:
                                  stateManager.pageMainDevicesNotifier.myDevices))
                    ]),
            ),
          ),
        );
      },
    );
  }
}




