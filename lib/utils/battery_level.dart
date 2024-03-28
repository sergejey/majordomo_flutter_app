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
    int intLevel = 0;
    try {
      intLevel = double.parse(this.level).round();
    } catch (e) {
      print('Invalid input string: '+this.level);
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0,0,0.0,0),
      child: Tooltip(
        message: this.level + '%',
        child: BasedBatteryIndicator(
          status: BasedBatteryStatus(
            value: intLevel,
            type: intLevel<30?BasedBatteryStatusType.low:BasedBatteryStatusType.normal,
          ),
          curve: Curves.ease,
          duration: const Duration(seconds: 1),
        ),
      ),
    );
  }
}
