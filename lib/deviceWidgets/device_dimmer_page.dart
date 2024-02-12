import 'package:flutter/material.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/pages/page_device_logic.dart';
import 'package:home_app/utils/text_updated.dart';

import 'package:flutter_xlider/flutter_xlider.dart';

class DeviceDimmerPage extends StatelessWidget {
  const DeviceDimmerPage(
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
          Text("${properties['level']}%",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: FlutterSlider(
              disabled: properties['status'] != "1",
              axis: Axis.vertical,
              tooltip: FlutterSliderTooltip(rightSuffix: const Text(' %')),
              rtl: true,
              values: [double.parse(properties['level'])],
              max: 100,
              min: 0,
              onDragCompleted: (int handlerIndex, dynamic lowerValue, dynamic upperValue) {
                stateManager.callObjectMethod(object, "setLevel", {"value":lowerValue});
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          /*3*/
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    properties['status'] == "1" ? Colors.yellow : Colors.white),
            onPressed: () {
              stateManager.callObjectMethod(object, "switch");
            },
            child: SizedBox.fromSize(
              size: const Size.fromRadius(50),
              child: const FittedBox(
                child: const Icon(
                  Icons.light_outlined,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextUpdated(updated: properties['updated']),
            ),
          )
        ],
      ),
    );
  }
}
