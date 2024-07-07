import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:home_app/models/history_record.dart';
import 'package:localization/localization.dart';

class ObjectHistory extends StatelessWidget {
  const ObjectHistory({super.key, required this.records, this.valueType = ''});

  final List<HistoryRecord> records;
  final String valueType;

  @override
  Widget build(BuildContext context) {
    List<HistoryRecord> recordsSorted = records;
    recordsSorted.sort((a, b) {
      return b.data_tm.compareTo(a.data_tm);
    });

    return Expanded(
      child: records.length == 0
          ? Center(child: Text('no_records'.i18n()))
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                border: TableBorder.all(width: 1, color: Theme.of(context).primaryColor),
                headingRowHeight: 30,
                headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                dataTextStyle: TextStyle(color: Theme.of(context).primaryColor),
                dataRowMinHeight: 30,
                dataRowMaxHeight: 40,
                columns: <DataColumn>[
                  DataColumn(
                    label: Text('timestamp'.i18n()),
                  ),
                  DataColumn(
                    label: Text('value'.i18n()),
                    numeric: true,
                  )
                ],
                rows: records
                    .map(
                      (item) => DataRow(cells: [
                        DataCell(Text(
                            DateFormat.yMd('locale'.i18n()).add_jm().format(item.data_tm))),
                        DataCell(valueType == 'onoff'
                            ? Text(item.data_value == '1'
                                ? 'is_on'.i18n()
                                : 'is_off'.i18n())
                            : valueType == 'openclose'
                                ? Text(item.data_value == '1'
                                    ? 'is_close'.i18n()
                                    : 'is_open'.i18n())
                                : Text(item.data_value)),
                      ]),
                    )
                    .toList(),
              ),
            ),
    );
  }
}
