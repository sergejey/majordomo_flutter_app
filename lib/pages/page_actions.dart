import 'package:flutter/material.dart';
import 'package:home_app/pages/page_actions_logic.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:localization/localization.dart';

class PageActions extends StatefulWidget {
  const PageActions({super.key, required this.deviceId});

  final String deviceId;

  @override
  State<PageActions> createState() => _ActionsPageState();
}

class _ActionsPageState extends State<PageActions> {
  final stateManager = getIt<ActionsPageManager>();

  @override
  void initState() {
    stateManager.initActionsPageState(widget.deviceId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stateManager = getIt<ActionsPageManager>();

    return ValueListenableBuilder<String>(
        valueListenable: stateManager.pageActionsNotifier,
        builder: (context, value, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text('device_automation_rules'.i18n()),
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
                        Text("Coming soon..."),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            stateManager.addLinkClicked();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50), // Set minimum width and height
                          ),
                          child: Text('add_action_link'.i18n()),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }
}
