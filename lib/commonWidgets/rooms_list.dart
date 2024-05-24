import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import './empty_devices_list.dart';
import './_room_wrapper.dart';
import '../models/room.dart';

class RoomsList extends StatelessWidget {
  const RoomsList({super.key, required this.rooms});

  final List<Room> rooms;

  @override
  Widget build(BuildContext context) {
    if (rooms.isEmpty) {
      return const EmptyDevicesList();
    } else {
      return ResponsiveGridList(
        horizontalGridSpacing: 8,
        verticalGridSpacing: 8,
        horizontalGridMargin: 4,
        verticalGridMargin: 4,
        minItemWidth: 400,
        minItemsPerRow: 1,
        children: List.generate(
            rooms.length,
                (index) => RoomWrapper(
              title: rooms[index].title,
              id: rooms[index].id,
              object: rooms[index].object,
              properties: rooms[index].properties,
            )), // Options that are getting passed to the ListView.builder() function
      );
    }
  }
}