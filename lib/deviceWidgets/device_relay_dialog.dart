import 'package:flutter/material.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/pages/page_main_logic.dart';

class DeviceRelayDialog extends StatelessWidget {
  const DeviceRelayDialog(
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
    return Column(
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  properties['status'] == "1" ? Colors.yellow : Colors.white),
          onPressed: () {
            final stateManager = getIt<MainPageManager>();
            stateManager.callObjectMethod(object, "switch");
          },
          child: SizedBox.fromSize(
            size: const Size.fromRadius(150),
            child: const FittedBox(
              child: Icon(
                Icons.power_settings_new,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
