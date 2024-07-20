import 'package:home_app/models/operational_mode.dart';
import 'package:home_app/models/system_state.dart';
import 'package:home_app/models/history_record.dart';

import 'package:flutter/material.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/commonWidgets/object_history.dart';
import 'package:localization/localization.dart';

import './page_modes_logic.dart';

class PageModes extends StatefulWidget {
  const PageModes({super.key, required this.initialTab});

  final int initialTab;

  @override
  State<PageModes> createState() => _ModesPageState();
}

class _ModesPageState extends State<PageModes> {
  final stateManager = getIt<ModesPageManager>();

  @override
  void initState() {
    stateManager.initModesPageState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stateManager = getIt<ModesPageManager>();
    return ValueListenableBuilder<String>(
        valueListenable: stateManager.pageModesNotifier,
        builder: (context, value, child) {
          return DefaultTabController(
            initialIndex: widget.initialTab <=
                    stateManager.pageModesNotifier.opModes.length
                ? widget.initialTab
                : 0,
            length: stateManager.pageModesNotifier.opModes.length + 1,
            child: Scaffold(
              appBar: AppBar(
                title: Text("nav_work_modes".i18n()),
                bottom: TabBar(
                  isScrollable: true,
                  tabs: List.generate(
                      stateManager.pageModesNotifier.opModes.length, (index) {
                    OperationalMode opMode =
                        stateManager.pageModesNotifier.opModes[index];
                    IconData iconType = Icons.cloud_outlined;
                    if (opMode.object == 'EconomMode') {
                      iconType = Icons.eco;
                    } else if (opMode.object == 'NobodyHomeMode' &&
                        opMode.active) {
                      iconType = Icons.person_off_outlined;
                    } else if (opMode.object == 'NobodyHomeMode') {
                      iconType = Icons.person;
                    } else if (opMode.object == 'SecurityArmedMode') {
                      iconType = Icons.security;
                    } else if (opMode.object == 'GuestsMode') {
                      iconType = Icons.people_outline;
                    } else if (opMode.object == 'DarknessMode' &&
                        opMode.active) {
                      iconType = Icons.nightlight;
                    } else if (opMode.object == 'DarknessMode') {
                      iconType = Icons.sunny;
                    } else if (opMode.object == 'NightMode') {
                      iconType = Icons.bed;
                    }
                    return Tab(
                      icon: Icon(iconType),
                      text: opMode.title,
                    );
                  })
                    ..add(Tab(
                        icon: const Icon(Icons.health_and_safety_outlined),
                        text: 'mode_system'.i18n())),
                ),
              ),
              body: TabBarView(
                children: List.generate(
                    stateManager.pageModesNotifier.opModes.length, (index) {
                  return OpModeView(
                    opMode: stateManager.pageModesNotifier.opModes[index],
                    opModeHistory:
                        stateManager.pageModesNotifier.opModesHistory[index],
                  );
                })
                  ..add(systemStatesView(
                      systemStates: stateManager.pageModesNotifier.sysStates)),
              ),
            ),
          );
        });
  }
}

class systemStatesView extends StatelessWidget {
  const systemStatesView({super.key, required this.systemStates});

  final List<SystemState> systemStates;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(systemStates.length, (index) {
              IconData stateIcon;
              if (systemStates[index].object == 'Security') {
                stateIcon = Icons.security_rounded;
              } else if (systemStates[index].object == 'System') {
                stateIcon = Icons.computer;
              } else if (systemStates[index].object == 'Communication') {
                stateIcon = Icons.wifi;
              } else {
                stateIcon = Icons.question_mark;
              }

              Color stateColor = Colors.grey;
              if (systemStates[index].color == 'red') {
                stateColor = Colors.red;
              } else if (systemStates[index].color == 'yellow') {
                stateColor = Colors.orangeAccent;
              } else if (systemStates[index].color == 'green') {
                stateColor = Colors.green;
              }

              String details = systemStates[index].details;
              if (systemStates[index].details=='' && systemStates[index].color == 'green') {
                details = 'OK';
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: stateColor,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Icon(stateIcon, color: stateColor),
                        )),
                  ),
                  Expanded(child:Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(details),
                  ))
                ],
              );
            })));
  }
}

class OpModeView extends StatelessWidget {
  const OpModeView(
      {super.key, required this.opMode, required this.opModeHistory});

  final OperationalMode opMode;
  final List<HistoryRecord> opModeHistory;

  @override
  Widget build(BuildContext context) {
    final stateManager = getIt<ModesPageManager>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Text("${opMode.title}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          const SizedBox(height: 15),
          Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: opMode.active ? Colors.green : Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: opMode.active
                    ? Text('mode_is_active'.i18n())
                    : Text('mode_is_inactive'.i18n()),
              )),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: !opMode.active
                    ? () {
                        stateManager.callObjectMethod(
                            opMode.object, "activate");
                        stateManager.pageModesNotifier.initialize();
                      }
                    : null,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                ),
                child: Text("mode_activate".i18n(),
                    style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(width: 15),
              ElevatedButton(
                onPressed: opMode.active
                    ? () {
                        stateManager.callObjectMethod(
                            opMode.object, "deactivate");
                        stateManager.pageModesNotifier.initialize();
                      }
                    : null,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                ),
                child: Text("mode_deactivate".i18n(),
                    style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ObjectHistory(
            records: opModeHistory,
            valueType: 'onoff',
          )
        ],
      ),
    );
  }
}
