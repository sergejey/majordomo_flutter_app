import 'package:flutter/material.dart';
import 'package:home_app/pages/page_configure_device_logic.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:localization/localization.dart';

class PageConfigureDevice extends StatefulWidget {
  const PageConfigureDevice({super.key, required this.deviceId});

  final String deviceId;

  @override
  State<PageConfigureDevice> createState() => _ConfigureDevicePageState();
}

class _ConfigureDevicePageState extends State<PageConfigureDevice> {
  final stateManager = getIt<ConfigureDevicePageManager>();

  @override
  void initState() {
    stateManager.initConfigureDevicePageState(widget.deviceId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stateManager = getIt<ConfigureDevicePageManager>();

    return ValueListenableBuilder<String>(
        valueListenable: stateManager.pageConfigureDeviceNotifier,
        builder: (context, value, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                    stateManager.pageConfigureDeviceNotifier.myDevice.title),
                actions: [],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xffb9cbe8).withOpacity(0.6),
                          blurRadius: 11,
                          offset: Offset(0, 4), // Shadow position
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            stateManager.deviceEditClicked(context);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity,
                                50), // Set minimum width and height
                          ),
                          child: Text('device_edit_title_room'.i18n()),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            stateManager.deviceScheduleClicked(context);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity,
                                50), // Set minimum width and height
                          ),
                          child: Text('device_schedule'.i18n()+(stateManager.pageConfigureDeviceNotifier.myDevice
                              .scheduleTotal >
                              0
                              ? ' (' +
                              stateManager.pageConfigureDeviceNotifier
                                  .myDevice.scheduleTotal
                                  .toString() +
                              ')'
                              : '' )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            stateManager.deviceAutomationClicked(context);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity,
                                50), // Set minimum width and height
                          ),
                          child: Text('device_automation_rules'.i18n() +
                              (stateManager.pageConfigureDeviceNotifier.myDevice
                                          .linksTotal >
                                      0
                                  ? ' (' +
                                      stateManager.pageConfigureDeviceNotifier
                                          .myDevice.linksTotal
                                          .toString() +
                                      ')'
                                  : '' )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            stateManager.deviceAdvancedConfigClicked();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity,
                                50), // Set minimum width and height
                          ),
                          child: Text('device_advanced_config'.i18n()),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }
}
