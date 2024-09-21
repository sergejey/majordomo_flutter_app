import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GroupWidget extends StatelessWidget {
  const GroupWidget(
      {super.key,
      required this.name,
      required this.title,
      required this.selected,
      required this.devicesTotal});

  final String name;
  final String title;
  final bool selected;
  final int devicesTotal;

  @override
  Widget build(BuildContext context) {
    String svg_filename = 'filter_outlet';

    if (name == 'light') {
      svg_filename = 'filter_light';
    }
    if (name == 'outlet') {
      svg_filename = 'filter_outlet';
    }
    if (name == 'openable') {
      svg_filename = 'filter_openable';
    }
    if (name == 'sensor') {
      svg_filename = 'filter_sensors';
    }
    if (name == 'motion') {
      svg_filename = 'filter_motion';
    }
    if (name == 'camera') {
      svg_filename = 'filter_camera';
    }
    if (name == 'climate') {
      svg_filename = 'filter_climate';
    }
    if (name == 'other') {
      svg_filename = 'filter_other';
    }



    return Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: BoxDecoration(
              color: selected
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              )),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Row(
              children: [
                SvgPicture.asset('assets/navigation/' + svg_filename + '.svg',
                    width: 32,
                    height: 32,
                    colorFilter: ColorFilter.mode(
                        selected? Theme.of(context).colorScheme.onTertiary
                        : Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn)),
                SizedBox(width: 5),
                Text(title,
                    style: TextStyle(
                        color: selected
                            ? Theme.of(context).colorScheme.onTertiary
                            : Theme.of(context).colorScheme.onPrimary)),
                SizedBox(width: 5),
              ],
            )),
          ),
        ));
  }
}
