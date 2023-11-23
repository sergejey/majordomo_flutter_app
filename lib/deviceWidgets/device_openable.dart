import 'package:flutter/material.dart';
import 'package:home_app/utils/text_updated.dart';
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
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextUpdated(updated: properties["updated"] ?? ""),
              ],
            ),
          ),
          /*3*/
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
              properties['status'] != "1" ? Colors.yellow : Colors.white,
              minimumSize: Size(45,45),
              maximumSize: Size(45,45),
              padding: const EdgeInsets.all(0),

            ),
            onPressed: () {
              stateManager.callObjectMethod(object, "switch");
            },
            child: Icon(
              properties['status'] != "1"? Icons.lock_open_outlined: Icons.lock_outline,
              color: Colors.black,
            ),
          ),
        ],
    );
  }
}
