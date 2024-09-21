import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoomIcon extends StatelessWidget {
  const RoomIcon(
      {super.key,
      required this.roomTitle,
      this.iconSize = 80});

  final String roomTitle;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    String svg_filename = "";
    IconData imgIcon = Icons.perm_device_info_outlined;

    svg_filename = 'room';

    if (RegExp(r"kitchen|кухня|столовая").hasMatch(roomTitle.toLowerCase())) {
      svg_filename = 'kitchen';
    } else if (RegExp(r"livingroom|зал|гостиная").hasMatch(roomTitle.toLowerCase())) {
      svg_filename = 'livingroom';
    } else if (RegExp(r"bedroom|спальня").hasMatch(roomTitle.toLowerCase())) {
      svg_filename = 'bedroom';
    } else if (RegExp(r"children|kid|детская").hasMatch(roomTitle.toLowerCase())) {
      svg_filename = 'kidroom';
    } else if (RegExp(r"office|work|кабинет|рабочая").hasMatch(roomTitle.toLowerCase())) {
      svg_filename = 'office';
    } else if (RegExp(r"bath|shower|ванная|душ").hasMatch(roomTitle.toLowerCase())) {
      svg_filename = 'bathroom';
    } else if (RegExp(r"garage|гараж").hasMatch(roomTitle.toLowerCase())) {
      svg_filename = 'garage';
    } else if (RegExp(r"patio|патио|терраса|тераcса").hasMatch(roomTitle.toLowerCase())) {
      svg_filename = 'patio';
    } else if (RegExp(r"hall|коридор|прихожая").hasMatch(roomTitle.toLowerCase())) {
      svg_filename = 'hall';
    } else if (RegExp(r"outdoor|улица|двор|сад").hasMatch(roomTitle.toLowerCase())) {
      svg_filename = 'outdoor';
    } else if (RegExp(r"toilet|wc|туалет|санузел|сан. узел").hasMatch(roomTitle.toLowerCase())) {
      svg_filename = 'toilet';
    }

    if (svg_filename != "") {
      return SvgPicture.asset(
        'assets/rooms/' + svg_filename + '.svg',
        colorFilter:
            ColorFilter.mode(Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
      );
    } else {
      return Icon(imgIcon,
          size: iconSize, color: Theme.of(context).colorScheme.onPrimary);
    }
  }
}
