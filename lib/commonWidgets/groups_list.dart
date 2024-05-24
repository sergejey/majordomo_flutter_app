import 'package:flutter/material.dart';
import '../models/device_group.dart';
import './group_widget.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/pages/page_main_logic.dart';

class GroupsList extends StatelessWidget {
  const GroupsList({super.key, required this.groups});

  final List<DeviceGroup> groups;

  @override
  Widget build(BuildContext context) {
    final stateManager = getIt<MainPageManager>();
    if (groups.isEmpty) {
      return const Text('No groups');
    } else {
      //return Text(groups.length.toString());
      return Container(
          height: 60,
          padding: const EdgeInsets.all(5.0),
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(groups.length, (index) {
                return groups[index].devicesTotal > 0
                    ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    stateManager.pageMainDevicesNotifier
                        .toggleGroupFilter(groups[index].name);
                  },
                  child: GroupWidget(
                    name: groups[index].name,
                    title: groups[index].title,
                    devicesTotal: groups[index].devicesTotal,
                    selected: stateManager
                        .pageMainDevicesNotifier.groupFilter ==
                        groups[index].name,
                  ),
                )
                    : SizedBox();
              })));
    }
  }
}
