import 'package:flutter/material.dart';
import 'package:based_battery_indicator/based_battery_indicator.dart';

class BatteryLevel extends StatelessWidget {
  const BatteryLevel({
    super.key,
    required this.level,
  });

  final String level;

  @override
  Widget build(BuildContext context) {
    int intLevel = int.tryParse(this.level) ?? 0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0,0,0.0,0),
      child: BasedBatteryIndicator(
        status: BasedBatteryStatus(
          value: intLevel,
          type: intLevel<30?BasedBatteryStatusType.low:BasedBatteryStatusType.normal,
        ),
        curve: Curves.ease,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
