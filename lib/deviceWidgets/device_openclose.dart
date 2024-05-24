import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_app/commonWidgets/device_icon.dart';

class DeviceOpenClose extends StatelessWidget {
  const DeviceOpenClose(
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
    return Row(
      children: [
        DeviceIcon(
          deviceType: 'openclose',
          deviceState: properties['status'],
          deviceTitle: title,
        ),
        Expanded(child: SizedBox(width: 10)),
        /*3*/
        SvgPicture.asset(
          properties['status'] != "1"?'assets/devices/lock_open.svg':'assets/devices/lock_closed.svg',
          width: 40,
          height: 40,
          colorFilter:
          ColorFilter.mode(Theme.of(context).primaryColor.withOpacity(properties['status'] != "1"?1:0.3), BlendMode.srcIn),
        ),
      ],
    );
  }
}
