import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_app/models/device_schedule.dart';
import 'package:home_app/utils/logging.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class ScheduleForm extends StatefulWidget {
  const ScheduleForm({super.key, required this.item, required this.methods});

  final DeviceSchedulePoint item;
  final List<DeviceScheduleMethod> methods;

  @override
  State<ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  late DeviceSchedulePoint newItem;
  late bool valueRequired;

  TextEditingController itemValueController =  TextEditingController();

  @override
  void initState() {
    newItem = widget.item;

    itemValueController.text = newItem.value;

    valueRequired = widget.methods
        .where((method) => method.methodName == newItem.linkedMethod)
        .toList()
        .first
        .valueRequired;

    if (!valueRequired) newItem.value = '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> weekDaysSelected = newItem.setDays.split(',');

    List<String> weekDaysTitles = [
      'week_sun_short'.i18n(),
      'week_mon_short'.i18n(),
      'week_tue_short'.i18n(),
      'week_wed_short'.i18n(),
      'week_thu_short'.i18n(),
      'week_fri_short'.i18n(),
      'week_sat_short'.i18n(),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownMenu(
          inputDecorationTheme: InputDecorationTheme(
              isDense: true,
              constraints: BoxConstraints.tight(const Size.fromWidth(250))),
          enableSearch: false,
          initialSelection: newItem.linkedMethod,
          requestFocusOnTap: false,
          label: Text('action'.i18n(), overflow: TextOverflow.ellipsis),
          onSelected: (item) {
            setState(() {
              valueRequired = widget.methods
                  .where((method) => method.methodName == item)
                  .toList()
                  .first
                  .valueRequired;
              if (!valueRequired) newItem.value = '';
              newItem.linkedMethod = item ?? widget.item.linkedMethod;
            });
          },
          dropdownMenuEntries: widget.methods
              .map<DropdownMenuEntry<String>>((DeviceScheduleMethod method) {
            return DropdownMenuEntry(
              value: method.methodName,
              label: method.title,
            );
          }).toList(),
        ),
        SizedBox(height: 10),
        if (valueRequired)
          SizedBox(
            width: 250,
            child: TextField(
              controller: itemValueController,
              decoration: InputDecoration(
                labelText: 'value'.i18n(),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (String newText) {
                setState(() {
                  newItem.value = newText;
                });
              },
              onSubmitted: (String newText) {
                setState(() {
                  newItem.value = newText;
                });
              },
            ),
          ),
        if (valueRequired) SizedBox(height: 10),
        TimePickerSpinnerPopUp(
          mode: CupertinoDatePickerMode.time,
          cancelText: 'dialog_cancel'.i18n(),
          initTime: DateTime.parse(
              DateFormat("yyyy-MM-dd").format(DateTime.now()) +
                  ' ' +
                  newItem.setTime +
                  ':00'),
          onChange: (dateTime) {
            setState(() {
              newItem.setTime = DateFormat("HH:mm").format(dateTime);
            });
          },
        ),
        SizedBox(height: 10),
        Row(
            children: weekDaysTitles
                .asMap()
                .entries
                .map((entry) => GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          List<String> daysSelected =
                              newItem.setDays.split(',').toList();
                          if (daysSelected.contains(entry.key.toString())) {
                            daysSelected.remove(entry.key.toString());
                          } else {
                            daysSelected.add(entry.key.toString());
                          }
                          daysSelected.sort();
                          newItem.setDays = daysSelected.join(',');
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        margin: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                        decoration: BoxDecoration(
                          color: weekDaysSelected.contains(entry.key.toString())
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onPrimary,
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Text(entry.value,style: TextStyle(
                          color: weekDaysSelected.contains(entry.key.toString())
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.primary,
                        ),),
                      ),
                    ))
                .toList()),
      ],
    );
  }
}
