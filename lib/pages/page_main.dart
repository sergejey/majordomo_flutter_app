import 'dart:async';

import 'package:home_app/models/room.dart';
import 'package:home_app/models/simple_device.dart';
import 'package:home_app/models/operational_mode.dart';
import 'package:home_app/models/device_group.dart';

import 'package:home_app/commonWidgets/group_widget.dart';

import 'package:home_app/config.dart';

import 'package:flutter/material.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/pages/page_main_logic.dart';
import 'package:home_app/pages/page_settings.dart';
import 'package:home_app/pages/page_modes.dart';

import 'package:home_app/deviceWidgets/_device_wrapper.dart';
import 'package:home_app/commonWidgets/_room_wrapper.dart';
import 'package:localization/localization.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:flutter_fgbg/flutter_fgbg.dart';

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
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: stateManager.pageMainDevicesNotifier.currentRoomTitle != ''
                  ? Text(stateManager.pageMainDevicesNotifier.currentRoomTitle)
                  : const Text(configAppDefaultTitle),
              actions: <Widget>[
                OperationalModesList(
                    modes: stateManager
                        .pageMainDevicesNotifier.myOperationalModesFiltered),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 0,
                              color: Colors.black12,
                              spreadRadius: 1)
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            stateManager.pageMainDevicesNotifier.roomView
                                ? Colors.yellow
                                : Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.roofing, color: Colors.black),
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
                              blurRadius: 0,
                              color: Colors.black12,
                              spreadRadius: 1)
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            stateManager.pageMainDevicesNotifier.activeFilter
                                ? Colors.yellow
                                : Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.filter_alt_outlined,
                              color: Colors.black),
                          tooltip: 'Active devices',
                          onPressed: () {
                            stateManager.toggleActiveFilter();
                          },
                        ),
                      ),
                    ))
              ],
            ),
            body: stateManager.pageMainDevicesNotifier.roomView
                ? RoomsList(rooms: stateManager.pageMainDevicesNotifier.myRooms)
                : Column(children: [
                    stateManager.pageMainDevicesNotifier.currentRoomTitle == ''
                        ? GroupsList(
                            groups:
                                stateManager.pageMainDevicesNotifier.myGroups)
                        : const SizedBox(),
                    Expanded(
                        child: DevicesList(
                            devices:
                                stateManager.pageMainDevicesNotifier.myDevices))
                  ]),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: SpeedDial(
                icon: Icons.info_outline,
                activeIcon: Icons.info_outline,
                spacing: 3,
                childPadding: const EdgeInsets.all(5),
                spaceBetweenChildren: 4,
                openCloseDial: isDialOpen,
                elevation: 8.0,
                useRotationAnimation: false,
                animationCurve: Curves.elasticInOut,
                isOpenOnStart: false,
                children: [
                  SpeedDialChild(
                    child: const Icon(Icons.settings),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    label: "nav_settings".i18n(),
                    onTap: () {
                      stateManager.endPeriodicUpdate();
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (context) => const PageSettings(),
                        ),
                      )
                          .then((value) {
                        stateManager.reload();
                      });
                    },
                  ),
                ]),
          ),
        );
      },
    );
  }
}

class OperationalModesList extends StatelessWidget {
  const OperationalModesList({super.key, required this.modes});

  final List<OperationalMode> modes;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(blurRadius: 0, color: Colors.black12, spreadRadius: 1)
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: modes.length == 0
                ? const Icon(Icons.link_off, color: Colors.grey)
                : Wrap(
                    spacing: 0,
                    children: List.generate(modes.length, (index) {
                      Icon modeIcon =
                          const Icon(Icons.question_mark, color: Colors.grey);
                      if (modes[index].object == 'EconomMode') {
                        modeIcon = modes[index].active
                            ? Icon(Icons.eco, color: Colors.green)
                            : Icon(Icons.eco_outlined, color: Colors.grey);
                      } else if (modes[index].object == 'NobodyHomeMode') {
                        modeIcon = modes[index].active
                            ? Icon(Icons.person_off_outlined,
                                color: Colors.green)
                            : Icon(Icons.person, color: Colors.grey);
                      } else if (modes[index].object == 'SecurityArmedMode') {
                        modeIcon = modes[index].active
                            ? Icon(Icons.security, color: Colors.green)
                            : Icon(Icons.security, color: Colors.grey);
                      } else if (modes[index].object == 'GuestsMode') {
                        modeIcon = modes[index].active
                            ? Icon(Icons.people_outline, color: Colors.green)
                            : Icon(Icons.people_outline, color: Colors.grey);
                      } else if (modes[index].object == 'DarknessMode') {
                        modeIcon = modes[index].active
                            ? Icon(Icons.nightlight, color: Colors.green)
                            : Icon(Icons.sunny, color: Colors.grey);
                      } else if (modes[index].object == 'NightMode') {
                        modeIcon = modes[index].active
                            ? Icon(Icons.bed, color: Colors.green)
                            : Icon(Icons.bed, color: Colors.grey);
                      }
                      return GestureDetector(
                          onTap: () {
                            final stateManager = getIt<MainPageManager>();
                            stateManager.endPeriodicUpdate();
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => modes.length == 0
                                    ? PageSettings()
                                    : PageModes(
                                        initialTab: 0,
                                      ),
                              ),
                            )
                                .then((value) {
                              stateManager.reload();
                            });
                          },
                          child: modeIcon);
                    })),
          ),
        ));
  }
}

class GroupsList extends StatelessWidget {
  const GroupsList({super.key, required this.groups});

  final List<DeviceGroup> groups;

  @override
  Widget build(BuildContext context) {
    final stateManager = getIt<MainPageManager>();
    if (groups.isEmpty) {
      return const Text('No groups');
    } else {
      //return Text(groups.length.toString());
      return Container(
          height: 60,
          padding: const EdgeInsets.all(5.0),
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(groups.length, (index) {
                return groups[index].devicesTotal > 0
                    ? GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          stateManager.pageMainDevicesNotifier.toggleGroupFilter(groups[index].name);
                        },
                        child: GroupWidget(
                          name: groups[index].name,
                          title: groups[index].title,
                          devicesTotal: groups[index].devicesTotal,
                          selected: stateManager.pageMainDevicesNotifier.groupFilter==groups[index].name,
                        ),
                      )
                    : SizedBox();
              })));
    }
  }
}

class DevicesList extends StatelessWidget {
  const DevicesList({super.key, required this.devices});

  final List<SimpleDevice> devices;

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return const EmptyDevicesList();
    } else {
      return ResponsiveGridList(
        horizontalGridSpacing: 8,
        verticalGridSpacing: 8,
        horizontalGridMargin: 4,
        verticalGridMargin: 4,
        minItemWidth: 300,
        minItemsPerRow: 2,
        children: List.generate(
            devices.length,
            (index) => DeviceWrapper(
                  title: devices[index].title,
                  id: devices[index].id,
                  object: devices[index].object,
                  type: devices[index].type,
                  properties: devices[index].properties,
                )), // Options that are getting passed to the ListView.builder() function
      );
    }
  }
}

class EmptyDevicesList extends StatelessWidget {
  const EmptyDevicesList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("No devices."),
    ]));
  }
}

class RoomsList extends StatelessWidget {
  const RoomsList({super.key, required this.rooms});

  final List<Room> rooms;

  @override
  Widget build(BuildContext context) {
    if (rooms.isEmpty) {
      return const EmptyDevicesList();
    } else {
      return ResponsiveGridList(
        horizontalGridSpacing: 8,
        verticalGridSpacing: 8,
        horizontalGridMargin: 4,
        verticalGridMargin: 4,
        minItemWidth: 300,
        minItemsPerRow: 2,
        children: List.generate(
            rooms.length,
            (index) => RoomWrapper(
                  title: rooms[index].title,
                  id: rooms[index].id,
                  object: rooms[index].object,
                  properties: rooms[index].properties,
                )), // Options that are getting passed to the ListView.builder() function
      );
    }
  }
}
