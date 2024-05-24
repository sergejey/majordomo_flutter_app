import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import './empty_devices_list.dart';
import '../deviceWidgets/_device_wrapper.dart';
import '../models/simple_device.dart';

class DevicesList extends StatelessWidget {
  const DevicesList({super.key, required this.devices});

  final List<SimpleDevice> devices;

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return const EmptyDevicesList();
    } else {
      return ResponsiveGridList(
        horizontalGridSpacing: 8,
        verticalGridSpacing: 8,
        horizontalGridMargin: 8,
        verticalGridMargin: 8,
        minItemWidth: 170,
        minItemsPerRow: 2,
        children: List.generate(
            devices.length,
                (index) => DeviceWrapper(
              title: devices[index].title,
              id: devices[index].id,
              object: devices[index].object,
              type: devices[index].type,
              properties: devices[index].properties,
              roomTitle: devices[index].roomTitle,
            )), // Options that are getting passed to the ListView.builder() function
      );
    }
  }
}
