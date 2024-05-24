import 'package:flutter/material.dart';
import 'package:home_app/commonWidgets/device_icon.dart';
import 'package:home_app/commonWidgets/room_icon.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/pages/page_main_logic.dart';

class RoomWrapper extends StatelessWidget {
  const RoomWrapper(
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          height: 102,
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
            padding: const EdgeInsets.all(12),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                stateManager.setRoomFilter(object, title);
              },
              child: Builder(builder: (BuildContext context) {
                return Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: const Color(0xffb9cbe8).withOpacity(0.6)),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: RoomIcon(roomTitle: title)),
                    SizedBox(width: 25),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    title,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              if (properties.containsKey("temperature"))
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(12, 5, 12, 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              Theme.of(context).primaryColor),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Text(
                                      properties["temperature"] + "°C",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: SizedBox(
                                  width: 5,
                                )),
                                if (properties.containsKey("motionOn"))
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: DeviceIcon(
                                      deviceType: 'motion',
                                      iconSize: 32,
                                    ),
                                  ),
                                if (properties.containsKey("lightOn"))
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: DeviceIcon(
                                      deviceType: 'relay',
                                      deviceSubType: 'light',
                                      deviceState: '1',
                                      iconSize: 32,
                                    ),
                                  ),
                                if (properties.containsKey("powerOn"))
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: DeviceIcon(
                                      deviceType: 'relay',
                                      iconSize: 32,
                                    ),
                                  ),
                                if (properties.containsKey("isOpen"))
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: DeviceIcon(
                                      deviceType: 'openable',
                                      iconSize: 32,
                                    ),
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
