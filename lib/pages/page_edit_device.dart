import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_app/models/room.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:localization/localization.dart';
import './page_edit_device_logic.dart';

class PageEditDevice extends StatefulWidget {
  const PageEditDevice({super.key, required this.deviceId});

  final String deviceId;

  @override
  State<PageEditDevice> createState() => _EditDevicePageState();
}

class _EditDevicePageState extends State<PageEditDevice> {
  final stateManager = getIt<EditDevicePageManager>();

  @override
  void initState() {
    stateManager.initEditDevicePageState(widget.deviceId);
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final stateManager = getIt<EditDevicePageManager>();

    return ValueListenableBuilder<String>(
        valueListenable: stateManager.pageEditDeviceNotifier,
        builder: (context, value, child) {
          final myDeviceTitleController = TextEditingController(
              text: stateManager.pageEditDeviceNotifier.myDevice.title);

          return Scaffold(
              appBar: AppBar(
                title: Text('device_edit_title_room'.i18n()),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xffb9cbe8).withOpacity(0.6),
                          blurRadius: 11,
                          offset: Offset(0, 4), // Shadow position
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: myDeviceTitleController,
                            decoration: InputDecoration(
                              labelText: 'device_title'.i18n(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'please_enter_text'.i18n();
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          DropdownButtonFormField(
                              value: stateManager
                                  .pageEditDeviceNotifier.myDevice.linkedRoom,
                              decoration: InputDecoration(
                                labelText: 'device_room'.i18n(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'please_make_selection'.i18n();
                                }
                                return null;
                              },
                              items: stateManager.pageEditDeviceNotifier.myRooms
                                  .map<DropdownMenuItem<String>>((Room item) {
                                return DropdownMenuItem(
                                  value: item.object,
                                  child: Text(item.title),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                stateManager.newDeviceLinkedRoom =
                                    newValue ?? '';
                              }),
                          SizedBox(height: 40),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    stateManager.newDeviceTitle =
                                        myDeviceTitleController.text;
                                    stateManager.saveDeviceData(context);
                                  }
                                },
                                child: Text('dialog_save'.i18n()),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('dialog_cancel'.i18n()),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        });
  }
}
