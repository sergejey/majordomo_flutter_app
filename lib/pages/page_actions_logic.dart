import 'package:flutter/material.dart';
import 'package:home_app/commonWidgets/link_form.dart';
import 'package:home_app/models/device_links.dart';
import 'package:home_app/pages/page_actions_notifier.dart';
import 'package:home_app/utils/confirm_dialog.dart';
import 'package:home_app/utils/logging.dart';
import 'package:localization/localization.dart';

class ActionsPageManager {
  final pageActionsNotifier = PageActionsNotifier();

  void initActionsPageState(String deviceId) {
    pageActionsNotifier.initialize(deviceId);
  }

  void addLinkClicked(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('link_type'.i18n()),
            children: [
              ...pageActionsNotifier.availableLinks.map((value) {
                return SimpleDialogOption(
                  child: Text(value.title),
                  onPressed: () {

                    Navigator.pop(context, true);

                    DeviceLink item = DeviceLink(
                        id: 'new',
                        device1_id: pageActionsNotifier.deviceId,
                        device2_id: '0',
                        device1_title: '',
                        device2_title: '',
                        link_type: value.name,
                        link_type_title: value.title,
                        link_settings: {},
                        comment: '',
                        active: true);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: Text(item.link_type_title),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(24, 24, 0, 24),
                              child: LinkForm(
                                item: item,
                                link_data: value,
                              ),
                            ),
                            SimpleDialogOption(
                              child: Text('dialog_save'.i18n()),
                              onPressed: () async {
                                if (await pageActionsNotifier
                                        .updateLink(item) ??
                                    false) {
                                  alert(context, 'dialog_saved'.i18n());
                                  initActionsPageState(
                                      pageActionsNotifier.deviceId);
                                  Navigator.pop(context, true);
                                } else {
                                  alert(context, 'general_error'.i18n(), color: Colors.redAccent);
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
                  },
                );
              }).toList(),
              SizedBox(height: 10),
              SimpleDialogOption(
                child: Text('dialog_cancel'.i18n()),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void editLinkClicked(
      BuildContext context, DeviceLink item, String link_type) {
    if (item.device1_id != pageActionsNotifier.deviceId) {
      alert(context, 'goto_master_device'.i18n());
      return;
    }

    DeviceLink updatedItem = DeviceLink(
        id: item.id,
        device1_id: item.device1_id,
        device2_id: item.device2_id,
        device1_title: item.device1_title,
        device2_title: item.device2_title,
        link_type: item.link_type,
        link_type_title: item.link_type_title,
        link_settings: {...item.link_settings},
        comment: item.comment,
        active: item.active);

    dprint("Link settings: "+item.link_settings.toString());

    DeviceAvailableLink linkData = DeviceAvailableLink(
        name: '', title: '', description: '', targetDevices: [], params: []);

    for (int i = 0; i < pageActionsNotifier.availableLinks.length; i++) {
      if (pageActionsNotifier.availableLinks[i].name == item.link_type) {
        linkData = pageActionsNotifier.availableLinks[i];
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(updatedItem.link_type_title),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 0, 24),
              child: LinkForm(item: updatedItem, link_data: linkData),
            ),
            SimpleDialogOption(
              child: Text('dialog_save'.i18n()),
              onPressed: () async {
                if (await pageActionsNotifier.updateLink(updatedItem) ??
                    false) {
                  alert(context, 'dialog_saved'.i18n());
                  initActionsPageState(pageActionsNotifier.deviceId);
                  Navigator.pop(context, true);
                } else {
                  alert(context, 'general_error'.i18n(), color: Colors.redAccent);
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
                  if (await pageActionsNotifier.deleteLink(item) ?? false) {
                    alert(context, 'dialog_saved'.i18n());
                    initActionsPageState(pageActionsNotifier.deviceId);
                    Navigator.pop(context, true);
                  } else {
                    alert(context, 'general_error'.i18n(), color: Colors.redAccent);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
