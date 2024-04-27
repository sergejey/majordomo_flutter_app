import 'package:flutter/material.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/pages/page_device_logic.dart';
import 'package:home_app/utils/text_updated.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class DeviceRGBPage extends StatelessWidget {
  const DeviceRGBPage({super.key,
    required this.title,
    required this.id,
    required this.object,
    required this.properties});

  final String title;
  final String id;
  final String object;
  final Map<String, dynamic> properties;

  @override
  Widget build(BuildContext context) {
    final stateManager = getIt<DevicePageManager>();
    Color currentColor = Color(int.parse('ff'+properties['color']??"", radix: 16));
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('#'+properties['color']),
          SizedBox(
            height: 20,
          ),
          Center(
            child: ColorPicker(
                  pickerColor: currentColor,
                  onColorChanged: (Color color) {
                    String hexColor = colorToHex(color, enableAlpha: false);
                    stateManager.callObjectMethod(object, "setColor",{"color":hexColor});
                  },
                  enableAlpha: false,
              paletteType: PaletteType.hsvWithSaturation,
                displayThumbColor: false,
                  pickerAreaBorderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(2),
                    topRight: Radius.circular(2),
                  ),
              ),

          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                  properties['status'] == "1" ? Colors.yellow : Colors.white),
              onPressed: () {
                stateManager.callObjectMethod(object, "switch");
              },
              child: SizedBox.fromSize(
                size: const Size.fromRadius(150),
                child: FittedBox(
                  child: Icon(
                    Icons.palette_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextUpdated(
                  updated: properties['updated']
              ),
            ),
          )
        ],
      ),
    );
  }
}
