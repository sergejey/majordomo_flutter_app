import 'package:flutter/material.dart';
import 'package:home_app/commonWidgets/schedule_item.dart';
import 'package:home_app/pages/page_schedule_logic.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:localization/localization.dart';

class PageSchedule extends StatefulWidget {
  const PageSchedule({super.key, required this.deviceId});

  final String deviceId;

  @override
  State<PageSchedule> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<PageSchedule> {
  final stateManager = getIt<SchedulePageManager>();

  @override
  void initState() {
    stateManager.initSchedulePageState(widget.deviceId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stateManager = getIt<SchedulePageManager>();

    return ValueListenableBuilder<String>(
        valueListenable: stateManager.pageScheduleNotifier,
        builder: (context, value, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text('device_schedule'.i18n()),
                actions: [],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(0, 4), // Shadow position
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: stateManager.pageScheduleNotifier.methods.length == 0
                        ? Center(child: Text('not_available'.i18n()))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  stateManager.addPointClicked(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  minimumSize: Size(double.infinity,
                                      50), // Set minimum width and height
                                ),
                                child: Text('add_schedule_point'.i18n()),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...stateManager
                                          .pageScheduleNotifier.points
                                          .map((item) => ScheduleItem(
                                              item: item,
                                              onTap: () {
                                                stateManager.editPontClicked(
                                                    item, context);
                                              }))
                                          .toList(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ));
        });
  }
}
