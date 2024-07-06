import 'package:home_app/utils/logging.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:home_app/models/history_record.dart';
import 'package:localization/localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';
import 'dart:math' as math;

class HistoryChart extends StatefulWidget {
  const HistoryChart(
      {super.key,
      required this.records,
      this.intervalType = '',
      this.chartType = ''});

  final List<HistoryRecord> records;
  final String chartType;
  final String intervalType;

  @override
  State<HistoryChart> createState() => _HistoryChartState();
}

class _HistoryChartState extends State<HistoryChart> {
  String minValue = '';
  String maxValue = '';
  String avgValue = '';
  int totalValues = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<FlSpot> data = [];

    totalValues = widget.records.length;

    if (totalValues>0) {
      avgValue = widget.records
          .map((m) => double.parse(m.data_value))
          .average
          .toStringAsFixed(2);
      minValue = widget.records
          .map((m) => double.parse(m.data_value))
          .min
          .toStringAsFixed(2);
      maxValue = widget.records
          .map((m) => double.parse(m.data_value))
          .max
          .toStringAsFixed(2);
    } else {
      avgValue = '';
      minValue = '';
      maxValue = '';
    }

    data = widget.records
        .map((item) => FlSpot((item.data_tm.millisecondsSinceEpoch / 1000 / 60),
            double.parse(item.data_value)))
        .toList();

    // https://app.flchart.dev/#/line
    return Expanded(
        child: widget.records.length == 0
            ? Center(child: Text('no_records'.i18n()))
            : LineChart(LineChartData(
                gridData: FlGridData(show: true),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: const BorderSide(color: Colors.transparent),
                    left: const BorderSide(color: Colors.transparent),
                    right: const BorderSide(color: Colors.transparent),
                    top: const BorderSide(color: Colors.transparent),
                  ),
                ),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    getTooltipColor: returnTooltipColor,
                )
                ),
                titlesData: FlTitlesData(
                  bottomTitles: getBottomTitles(),
                  topTitles: noTitlesWidget(),
                  leftTitles: noTitlesWidget(),
                  rightTitles: noTitlesWidget(),
                ),
                lineBarsData: [
                  LineChartBarData(
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      spots: data),
                ],
              )));
  }

  Color returnTooltipColor(LineBarSpot spot) {
    return Colors.white;
  }

  AxisTitles getBottomTitles() {
    const style = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 10,
    );
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: (value, meta) {
          String text = '';
          if (value != meta.min && value != meta.max) {
            text = getDate(value);
          }
          return Transform.rotate(
              angle: -math.pi / 4, child: Text(text, style: style));
        },
      ),
    );
  }

  AxisTitles getLeftTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 20,
        getTitlesWidget: (value, meta) {
          String text = '';
          if (value.toStringAsFixed(2) == minValue) {
            text = minValue;
          } else if (value.toStringAsFixed(2) == maxValue) {
            text = maxValue;
          }
          return Text(text);
        },
      ),
    );
  }

  String getDate(double value) {
    DateFormat hmFormat = DateFormat('Hm');
    if (widget.intervalType == 'week') {
      hmFormat = DateFormat('dd.MM H:m');
    }
    if (widget.intervalType == 'month') {
      hmFormat = DateFormat('yMd');
    }

    return hmFormat.format(
        DateTime.fromMillisecondsSinceEpoch((value * 1000 * 60).toInt()));
  }

  AxisTitles noTitlesWidget() {
    return const AxisTitles(sideTitles: SideTitles());
  }
}
