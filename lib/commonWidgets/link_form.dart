import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:home_app/models/device_links.dart';
import 'package:localization/localization.dart';

class LinkForm extends StatefulWidget {
  const LinkForm({super.key, required this.item, required this.link_data});

  final DeviceLink item;
  final DeviceAvailableLink link_data;

  @override
  State<LinkForm> createState() => _LinkFormState();
}

class _LinkFormState extends State<LinkForm> {
  late DeviceLink newItem;

  late Map<String, TextEditingController> paramTextControllers = {};
  late Map<String, Color> paramPickerColor = {};

  @override
  void initState() {
    newItem = widget.item;
    widget.link_data.params.forEach((DeviceLinkParam param) {
      if (param.type == 'color') {
        String paramColor =
            (newItem.link_settings[param.name] ?? '').toString();
        if (paramColor != '') {
          paramColor = paramColor.replaceAll('#', '');
          Color currentColor = Color(int.parse('ff' + paramColor, radix: 16));
          paramPickerColor[param.name] = currentColor;
        } else {
          paramPickerColor[param.name] = Colors.green;
        }
      }
      if (param.type == 'num' || param.type == 'duration') {
        paramTextControllers[param.name] = TextEditingController();
        paramTextControllers[param.name]?.text =
            (newItem.link_settings[param.name] ?? '').toString();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownMenu(
          width:240,
          inputDecorationTheme: InputDecorationTheme(
              isDense: true,
              constraints: BoxConstraints.tight(const Size.fromWidth(250))),
          enableSearch: false,
          initialSelection: newItem.device2_id,
          requestFocusOnTap: false,
          label: Text('link_target_device'.i18n(),
              overflow: TextOverflow.ellipsis),
          onSelected: (item) {
            setState(() {
              newItem.device2_id = item ?? widget.item.device2_id;
            });
          },
          dropdownMenuEntries: widget.link_data.targetDevices
              .map<DropdownMenuEntry<String>>(
                  (DeviceLinkTargetDevice target_device) {
            return DropdownMenuEntry(
              value: target_device.id,
              label: target_device.title,
            );
          }).toList(),
        ),
        ...widget.link_data.params.map<Widget>((DeviceLinkParam param) {
          if (param.visible_condition == '!=' &&
              newItem.link_settings[param.visible_condition_parameter] ==
                  param.visible_condition_value) {
            return SizedBox(height: 1);
          }
          if ((param.visible_condition == '==' ||
                  param.visible_condition == '=') &&
              newItem.link_settings[param.visible_condition_parameter] !=
                  param.visible_condition_value) {
            return SizedBox(height: 1);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              if (param.type == 'select')
                DropdownMenu(
                  width:240,
                  inputDecorationTheme: InputDecorationTheme(
                      isDense: true,
                      constraints:
                          BoxConstraints.tight(const Size.fromWidth(250))
                  ),
                  enableSearch: false,
                  initialSelection:
                      newItem.link_settings[param.name].toString(),
                  requestFocusOnTap: false,
                  label: Text(param.title, overflow: TextOverflow.ellipsis),
                  onSelected: (item) {
                    setState(() {
                      newItem.link_settings[param.name] = item ?? '';
                    });
                  },
                  dropdownMenuEntries: param.options
                      .map<DropdownMenuEntry<String>>(
                          (DeviceLinkParamOption option) {
                    return DropdownMenuEntry(
                      value: option.value,
                      label: option.title,
                    );
                  }).toList(),
                ),
              if (param.type == 'num' || param.type == 'duration')
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                  child: SizedBox(
                    width: 250,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: paramTextControllers[param.name],
                      decoration: InputDecoration(
                        labelText: param.title,
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (String newText) {
                        setState(() {
                          newItem.link_settings[param.name] = newText;
                        });
                      },
                      onSubmitted: (String newText) {
                        setState(() {
                          newItem.link_settings[param.name] = newText;
                        });
                      },
                    ),
                  ),
                ),
              if (param.type == 'color')
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(param.title),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            enableAlpha: false,
                            paletteType: PaletteType.hsvWithSaturation,
                            displayThumbColor: false,
                            pickerColor:
                                paramPickerColor[param.name] ?? Colors.green,
                            onColorChanged: (Color color) {
                              setState(
                                  () => paramPickerColor[param.name] = color);
                            },
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            child: Text('dialog_ok'.i18n()),
                            onPressed: () {
                              setState(() {
                                String hexColor = colorToHex(
                                    paramPickerColor[param.name] ??
                                        Colors.green,
                                    enableAlpha: false);
                                newItem.link_settings[param.name] =
                                    '#' + hexColor;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(param.title +
                      ': ' +
                      (newItem.link_settings[param.name] ?? 'no'.i18n())
                          .toString()),
                ),
            ],
          );
        }).toList(),
        SizedBox(height: 10),
        Row(
          children: [
            Switch(
              value: newItem.active,
              onChanged: (bool value) {
                setState(() {
                  newItem.active = value;
                });
              },
            ),
            SizedBox(width: 10),
            Text('link_enabled'.i18n()),
          ],
        ),
      ],
    );
  }
}
