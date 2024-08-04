import 'package:flutter/material.dart';
import 'package:home_app/commonWidgets/schedule_form.dart';
import 'package:home_app/models/device_schedule.dart';
import 'package:home_app/pages/page_schedule_notifier.dart';
import 'package:home_app/utils/confirm_dialog.dart';
import 'package:home_app/utils/logging.dart';
import 'package:localization/localization.dart';

class SchedulePageManager {
  final pageScheduleNotifier = PageScheduleNotifier();

  void initSchedulePageState(String deviceId) {
    pageScheduleNotifier.initialize(deviceId);
  }

  void editPontClicked(DeviceSchedulePoint item, BuildContext context) {
    DeviceSchedulePoint updatedItem = DeviceSchedulePoint(
        id: item.id,
        linkedMethod: item.linkedMethod,
        setTime: item.setTime,
        setDays: item.setDays,
        value: item.value,
        linkedMethodTitle: item.linkedMethodTitle);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 0, 24),
              child: ScheduleForm(
                  item: updatedItem, methods: pageScheduleNotifier.methods),
            ),
            SimpleDialogOption(
              child: Text('dialog_save'.i18n()),
              onPressed: () async {
                if (await pageScheduleNotifier
                        .updateScheduleItem(updatedItem) ??
                    false) {
                  alert(context, 'dialog_saved'.i18n());
                  initSchedulePageState(pageScheduleNotifier.deviceId);
                  Navigator.pop(context, true);
                }
              },
            ),
            SimpleDialogOption(
              child: Text('dialog_cancel'.i18n()),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            SizedBox(height: 20),
            SimpleDialogOption(
              child: Text('dialog_delete'.i18n()),
              onPressed: () async {
                if (await confirm(context)) {
                  if (await pageScheduleNotifier.deleteScheduleItem(item) ??
                      false) {
                    alert(context, 'dialog_saved'.i18n());
                    initSchedulePageState(pageScheduleNotifier.deviceId);
                    Navigator.pop(context, true);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void addPointClicked(BuildContext context) {
    DeviceSchedulePoint item = DeviceSchedulePoint(
        id: 'new',
        linkedMethod: pageScheduleNotifier.methods[0].methodName,
        linkedMethodTitle: pageScheduleNotifier.methods[0].title,
        setTime: '09:00',
        setDays: '0,1,2,3,4,5,6',
        value: '');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 0, 24),
              child: ScheduleForm(
                  item: item, methods: pageScheduleNotifier.methods),
            ),
            SimpleDialogOption(
              child: Text('dialog_save'.i18n()),
              onPressed: () async {
                if (await pageScheduleNotifier.updateScheduleItem(item) ??
                    false) {
                  alert(context, 'dialog_saved'.i18n());
                  initSchedulePageState(pageScheduleNotifier.deviceId);
                  Navigator.pop(context, true);
                }
              },
            ),
            SimpleDialogOption(
              child: Text('dialog_cancel'.i18n()),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }
}
