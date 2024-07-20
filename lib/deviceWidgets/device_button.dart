import 'package:flutter/material.dart';
import 'package:home_app/commonWidgets/device_icon.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/pages/page_main_logic.dart';

class DeviceButton extends StatelessWidget {
  const DeviceButton(
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
    final stateManager = getIt<MainPageManager>();
    return Row(
        children: [
          DeviceIcon(
            deviceType: 'button',
            deviceState: '0',
            deviceTitle: title,
          ),
          Expanded(child: SizedBox(width: 10)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              minimumSize: Size(55,55),
              maximumSize: Size(55,55),
              padding: const EdgeInsets.all(0),
            ),
            onPressed: () {
              stateManager.callObjectMethod(object, "pressed");
            },
            child: const Icon(Icons.play_arrow_rounded)

          ),
        ],
    );
  }
}
