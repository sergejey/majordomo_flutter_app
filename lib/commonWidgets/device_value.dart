import 'package:flutter/material.dart';

class DeviceValue extends StatelessWidget {
  const DeviceValue({super.key, required this.value, this.valueState = ""});

  final String value;
  final String valueState;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
      decoration: BoxDecoration(
        color:
            valueState == "1" ? Theme.of(context).colorScheme.tertiary : Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
            color: valueState == "1"
                ? Theme.of(context).colorScheme.onTertiary
                : Theme.of(context).colorScheme.onPrimary),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
