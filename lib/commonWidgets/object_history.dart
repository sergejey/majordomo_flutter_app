import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:home_app/models/history_record.dart';

class ObjectHistory extends StatelessWidget {
  const ObjectHistory({super.key, required this.records, this.valueType = ''});

  final List<HistoryRecord> records;
  final String valueType;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: records.length == 0
          ? Center(child: const Text('Нет записей'))
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                border: TableBorder.all(width: 1),
                columns: const <DataColumn>[
                  DataColumn(
                    label: const Text('Время'),
                  ),
                  DataColumn(
                    label: Text('Значение'),
                    numeric: true,
                  )
                ],
                rows: records
                    .map(
                      (item) => DataRow(cells: [
                        DataCell(Text(DateFormat.yMd().add_jm().format(item.data_tm))),
                        DataCell(valueType == 'onoff'
                            ? Text(item.data_value == '1'
                                ? 'Включено'
                                : 'Выключено')
                            : Text(item.data_value)),
                      ]),
                    )
                    .toList(),
              ),
            ),
    );
  }
}
