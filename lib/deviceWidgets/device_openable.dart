import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_app/commonWidgets/device_icon.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/pages/page_main_logic.dart';

class DeviceOpenable extends StatelessWidget {
  const DeviceOpenable(
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
            deviceType: 'openable',
            deviceState: properties['status'],
            deviceTitle: title,
          ),
          Expanded(child: SizedBox(width: 10)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: properties['status'] != "1"?Theme.of(context).primaryColor:Theme.of(context).colorScheme.onPrimary,
              minimumSize: Size(55,55),
              maximumSize: Size(55,55),
              padding: const EdgeInsets.all(0),

            ),
            onPressed: () {
              stateManager.callObjectMethod(object, "switch");
            },
            child: SvgPicture.asset(
              properties['status'] != "1"?'assets/devices/lock_open.svg':'assets/devices/lock_closed.svg',
              width: 40,
              height: 40,
              colorFilter:
              ColorFilter.mode(properties['status'] == "1"?Theme.of(context).primaryColor:Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
            ),
          ),
        ],
    );
  }
}
