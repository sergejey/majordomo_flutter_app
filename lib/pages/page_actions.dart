import 'package:flutter/material.dart';
import 'package:home_app/commonWidgets/link_item.dart';
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
                    child: (stateManager.pageActionsNotifier.availableLinks
                                    .length ==
                                0 &&
                            stateManager.pageActionsNotifier.links.length == 0)
                        ? Center(child: Text('not_available'.i18n()))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (stateManager.pageActionsNotifier
                                      .availableLinks.length >
                                  0)
                                ElevatedButton(
                                  onPressed: () {
                                    stateManager.addLinkClicked(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    minimumSize: Size(double.infinity,
                                        50), // Set minimum width and height
                                  ),
                                  child: Text('add_action_link'.i18n()),
                                ),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...stateManager.pageActionsNotifier.links
                                          .map((item) => LinkItem(
                                              item: item,
                                              onTap: () {
                                                stateManager.editLinkClicked(
                                                    context,
                                                    item,
                                                    item.link_type);
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
