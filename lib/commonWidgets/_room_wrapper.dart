import 'package:flutter/material.dart';
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
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: Colors.blue,
                width: 1.0,
                style: BorderStyle.solid), //Border.all
            borderRadius: const BorderRadius.all(
              Radius.circular(6),
            ),
            /*
            boxShadow: const [
              BoxShadow(blurRadius: 8),
            ],*/
          ),
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
                        ],
                      ),
                    ),

                    if (properties.containsKey("temperature"))
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          child: Text(
                            properties["temperature"] + "°C",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    if (properties.containsKey("motionOn"))
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CircleAvatar(
                            radius: 12,
                            backgroundColor: properties['motionOn'] == "1"
                                ? Colors.yellow
                                : Colors.white,
                            child: const Icon(
                              Icons.man,
                              color: Colors.black,
                              size: 16,
                            )),
                      ),
                    if (properties.containsKey("lightOn"))
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.yellow,
                            child: const Icon(
                              Icons.light_outlined,
                              color: Colors.black,
                              size: 16
                            )),
                      ),
                    if (properties.containsKey("powerOn"))
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.yellow,
                            child: const Icon(
                                Icons.power_settings_new,
                                color: Colors.black,
                                size: 16
                            )),
                      ),
                    if (properties.containsKey("isOpen"))
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.yellow,
                            child: const Icon(
                                Icons.door_back_door_outlined,
                                color: Colors.black,
                                size: 16
                            )),
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
