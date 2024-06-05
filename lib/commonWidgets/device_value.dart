import 'package:flutter/material.dart';

class DeviceValue extends StatelessWidget {
  const DeviceValue({super.key,
    required this.value,
    this.valueState = ""
  });

  final String value;
  final String valueState;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
      decoration: BoxDecoration(
        border: Border.all(color: Theme
            .of(context)
            .primaryColor),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Text(
        value,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
