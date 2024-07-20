import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class DeviceGroupStatePage extends StatelessWidget {
  const DeviceGroupStatePage(
      {super.key,
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

    String devicesInvolved = properties['groupObject']??'';
    List<String> devicesToShow = [];
    if (devicesInvolved!='') {
      final List<dynamic> data = json.decode(devicesInvolved);
      data.forEach((item) {
        devicesToShow.add(item['title']);
      });
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Column(children: [
              SizedBox(height: 20),
              Container(
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
                  padding: const EdgeInsets.all(12),
                  child: DataTable(
                    headingRowHeight: 30,
                    headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                    dataTextStyle: TextStyle(color: Theme.of(context).primaryColor),
                    dataRowMinHeight: 30,
                    dataRowMaxHeight: 40,
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text('devices_in_group'.i18n()),
                      )
                    ],
                    rows: devicesToShow
                        .map(
                          (item) => DataRow(cells: [
                        DataCell(Text(item)),
                      ]),
                    )
                        .toList(),
                  ),
                ),
              )
            ],),
          ),
        ],
      ),
    );
  }
}
