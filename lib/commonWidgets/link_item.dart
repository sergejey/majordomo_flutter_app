import 'package:flutter/material.dart';
import 'package:home_app/models/device_links.dart';

class LinkItem extends StatelessWidget {
  const LinkItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  final DeviceLink item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: item.active ? 1 : 0.5,
      child: Container(
          margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                  blurRadius: 6,
                  offset: Offset(0, 4), // Shadow position
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.link_type_title!='') Text(item.link_type_title, overflow: TextOverflow.ellipsis),
                    Text(item.device1_title + ' ⟶ ' + item.device2_title,
                        overflow: TextOverflow.ellipsis),
                  ],
                )),
          )),
    );
  }
}
