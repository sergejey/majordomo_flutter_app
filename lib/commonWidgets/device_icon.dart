import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeviceIcon extends StatelessWidget {
  const DeviceIcon(
      {super.key,
      required this.deviceType,
      this.deviceSubType = "",
      this.deviceTitle = "",
      this.deviceState = "",
      this.iconSize = 45});

  final String deviceType;
  final String deviceSubType;
  final String deviceTitle;
  final String deviceState;
  final double iconSize;

  @override
  Widget build(BuildContext context) {

    String svg_filename = "device";
    IconData imgIcon = Icons.perm_device_info_outlined;

    if (['rgb', 'dimmer'].contains(this.deviceType)) {
      svg_filename = 'light';
    } else if (this.deviceType == 'relay' && this.deviceSubType == 'light') {
      svg_filename = 'light';
    } else if (this.deviceType == 'relay' && this.deviceSubType == 'vent') {
      svg_filename = 'fan';
    } else if (this.deviceType == 'relay' && this.deviceSubType == 'heating') {
      svg_filename = this.deviceState == '1' ? 'ac_on' : 'ac_off';
    } else if (this.deviceType == 'relay' && this.deviceSubType == 'curtains') {
      svg_filename = this.deviceState == '1' ? 'curtains_closed' : 'curtains_open';
    } else if (this.deviceType == 'motion') {
      svg_filename = 'motion';
    } else if (this.deviceType == 'openable' ||
        this.deviceType == 'openclose') {
      svg_filename = 'door_open';
    } else if (this.deviceType == 'sensor_temp') {
      svg_filename = 'temperature';
    } else if (this.deviceType == 'sensor_humidity') {
      svg_filename = 'sensor_humidity';
    } else if (this.deviceType == 'sensor_co2') {
      svg_filename = 'sensor_air';
    } else if (this.deviceType == 'relay') {
      svg_filename = 'outlet';
    } else if (this.deviceType == 'camera') {
      svg_filename = 'camera';
    } else if (this.deviceType == 'counter') {
      svg_filename = 'counter';
    } else if (this.deviceType == 'ac') {
      svg_filename = this.deviceState == '1' ? 'ac_on' : 'ac_off';
    } else if (this.deviceType == 'thermostat' && this.deviceSubType == 'cooling') {
      svg_filename = 'thermostat_cooling';
    } else if (this.deviceType == 'thermostat') {
      svg_filename = this.deviceState == '1' ? 'thermostat_on' : 'thermostat_off';
    } else if (this.deviceType == 'sensor_light') {
      svg_filename = 'sensor_light';
    } else if (this.deviceType == 'sensor_power') {
      svg_filename = 'sensor_power';
    } else if (this.deviceType == 'leak') {
      svg_filename = 'leak';
    } else if (this.deviceType == 'smoke') {
      svg_filename = 'sensor_smoke';
    } else if (RegExp(r"^sensor").hasMatch(this.deviceType)) {
      svg_filename = 'sensor';
    }

    if (svg_filename == 'door_open' &&
    RegExp(r"^curtain|штор").hasMatch(deviceTitle.toLowerCase())) {
      svg_filename = this.deviceState == '1' ? 'curtains_closed' : 'curtains_open';
    }

    if (svg_filename == 'door_open' &&
        RegExp(r"^окн|window").hasMatch(deviceTitle.toLowerCase())) {
      svg_filename = this.deviceState == '1' ? 'window_closed' : 'window_open';
    }

    if (svg_filename == 'door_open' && this.deviceState == '1') {
      svg_filename = 'door_closed';
    }

    if (svg_filename == 'outlet' &&
        RegExp(r"^tv|телевизор").hasMatch(deviceTitle.toLowerCase())) {
      svg_filename = 'tv';
    }

    if (svg_filename == 'outlet' &&
        RegExp(r"^ventill|fan|вентиля|вытяж").hasMatch(deviceTitle.toLowerCase())) {
      svg_filename = 'fan';
    }

    if (svg_filename == 'sensor' &&
        RegExp(r"^air|воздух|co2").hasMatch(deviceTitle.toLowerCase())) {
      svg_filename = 'sensor_air';
    }

    if (svg_filename == 'light' && deviceState != '1') {
      svg_filename = 'light_off';
    }

    if (svg_filename != "") {
      return SvgPicture.asset(
        'assets/devices/' + svg_filename + '.svg',
        width: iconSize,
        height: iconSize,
        colorFilter:
            ColorFilter.mode(Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
      );
    } else {
      return Icon(imgIcon,
          size: iconSize, color: Theme.of(context).colorScheme.onPrimary);
    }
  }
}
