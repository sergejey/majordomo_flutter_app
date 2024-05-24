import 'package:flutter/material.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/pages/page_device_logic.dart';
import 'package:home_app/utils/text_updated.dart';

class DeviceRelayPage extends StatelessWidget {
  const DeviceRelayPage(
      {super.key,
      required this.title,
      required this.id,
      required this.object,
      required this.properties});

  final String title;
  final String id;
  final String object;
  final Map<String, dynamic> properties;

  @override
  Widget build(BuildContext context) {
    final stateManager = getIt<DevicePageManager>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: SizedBox(
              height: 20,
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextUpdated(
                updated: properties['updated']
              ),
            ),
          )
        ],
      ),
    );
  }
}
