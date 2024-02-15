import 'package:flutter/material.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/pages/page_device_logic.dart';
import 'package:home_app/utils/text_updated.dart';
import 'package:localization/localization.dart';

class DeviceThermostatPage extends StatelessWidget {
  const DeviceThermostatPage(
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
          Text('device_current_temperature'.i18n()+":"),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: properties["relay_status"] == "1"
                  ? Colors.yellow
                  : Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("${properties['value']} °C",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('device_target_temperature'.i18n()+":"),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: properties['disabled'] == '1'
                        ? null
                        : () {
                            stateManager.callObjectMethod(object, "tempUp");
                          },
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(40),
                      child: const FittedBox(
                        child: Icon(Icons.arrow_upward, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text("${properties['currentTargetValue']} °C",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 55)),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: properties['disabled'] == '1'
                        ? null
                        : () {
                            stateManager.callObjectMethod(object, "tempDown");
                          },
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(40),
                      child: const FittedBox(
                        child: Icon(Icons.arrow_downward, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
          SizedBox(
            height: 20,
          ),
          Text('device_mode'.i18n()+":"),
          SizedBox(
            height: 10,
          ),
          /*3*/
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  stateManager.callObjectMethod(object, "disable");
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      properties['disabled'] == '1'
                          ? Colors.yellow
                          : Colors.white),
                ),
                child:
                    Text('is_off'.i18n(), style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(width: 15),
              ElevatedButton(
                onPressed: () {
                  stateManager.callObjectMethod(object, "enable");
                  stateManager.callObjectMethod(object, "turnOn");
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      (properties['disabled'] != '1' &&
                              properties['status'] == '1')
                          ? Colors.yellow
                          : Colors.white),
                ),
                child:
                    Text("device_mode_normal".i18n(), style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(width: 15),
              ElevatedButton(
                onPressed: () {
                  stateManager.callObjectMethod(object, "enable");
                  stateManager.callObjectMethod(object, "turnOff");
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      (properties['disabled'] != '1' &&
                              properties['status'] != '1')
                          ? Colors.yellow
                          : Colors.white),
                ),
                child: Text("device_mode_eco".i18n(), style: TextStyle(color: Colors.black)),
              ),
            ],
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
