import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class EmptyDevicesList extends StatelessWidget {
  const EmptyDevicesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('no_devices'.i18n()),
        ]));
  }
}
