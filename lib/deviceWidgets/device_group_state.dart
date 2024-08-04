import 'package:flutter/material.dart';
import 'package:home_app/commonWidgets/device_icon.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/pages/page_main_logic.dart';
import 'package:home_app/utils/confirm_dialog.dart';
import 'package:localization/localization.dart';

class DeviceGroupState extends StatelessWidget {
  const DeviceGroupState(
      {super.key,
      required this.title,
      required this.id,
      required this.object,
      required this.properties,
      this.insideDevice = false});

  final String title;
  final String id;
  final String object;
  final Map<String, dynamic> properties;
  final bool insideDevice;

  @override
  Widget build(BuildContext context) {
    final stateManager = getIt<MainPageManager>();
    return Row(
      children: [
        DeviceIcon(
          deviceType: 'group_state',
          deviceState: '0',
          deviceTitle: title,
        ),
        Expanded(child: SizedBox(width: 10)),
        if (insideDevice) ...[
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                minimumSize: Size(55, 55),
                maximumSize: Size(55, 55),
                padding: const EdgeInsets.all(0),
              ),
              onPressed: () async {
                if (await confirm(context)) {
                  stateManager.callObjectMethod(object, "save");
                }
              },
              child: const Icon(Icons.save_alt_outlined)),
          SizedBox(width: 10)
        ],
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              minimumSize: Size(55, 55),
              maximumSize: Size(55, 55),
              padding: const EdgeInsets.all(0),
            ),
            onPressed: () {
              stateManager.callObjectMethod(object, "restore");
            },
            child: const Icon(Icons.play_arrow_rounded)),
      ],
    );
  }
}
