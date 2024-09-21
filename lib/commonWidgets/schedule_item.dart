import 'package:flutter/material.dart';
import 'package:home_app/models/device_schedule.dart';
import 'package:localization/localization.dart';

class ScheduleItem extends StatelessWidget {
  const ScheduleItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  final DeviceSchedulePoint item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    String weekSchedule = '';

    List<String> weekDaysTitles = [
      'week_sun'.i18n(),
      'week_mon'.i18n(),
      'week_tue'.i18n(),
      'week_wed'.i18n(),
      'week_thu'.i18n(),
      'week_fri'.i18n(),
      'week_sat'.i18n(),
    ];

    List<String> weekDays = item.setDays.split(',').map((item) {
      return weekDaysTitles[int.parse(item)];
    }).toList();

    if (weekDays.length == 7) {
      weekSchedule = 'week_daily'.i18n();
    } else {
      weekSchedule = weekDays.join(', ');
    }

    return Container(
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
                  Text(item.setTime + ' ' + weekSchedule,
                      overflow: TextOverflow.ellipsis),
                  Text(

                          item.linkedMethodTitle,
                      overflow: TextOverflow.ellipsis),
                  if (item.value!='') Text(item.value)
                ],
              )),
        ));
  }
}
