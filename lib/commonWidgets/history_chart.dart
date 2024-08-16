import 'package:home_app/commonWidgets/object_history.dart';
import 'package:localization/localization.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:home_app/models/history_record.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';
import 'dart:math' as math;

class HistoryChart extends StatefulWidget {
  const HistoryChart(
      {super.key,
      required this.records,
      this.intervalType = '',
      this.chartType = 'line',
      this.historyType = 'onoff'});

  final List<HistoryRecord> records;
  final String chartType;
  final String intervalType;
  final String historyType;

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

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor ??= Theme.of(context).primaryColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: barColor,
          width: width,
          borderRadius: BorderRadius.all(Radius.circular(3)),
          borderSide: const BorderSide(color: Colors.black, width: 1),
          backDrawRodData: BackgroundBarChartRodData(show: false),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<FlSpot> data = [];
    List<BarChartGroupData> barData = [];

    totalValues = widget.records.length;

    if (totalValues > 0) {
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

    if (widget.chartType == 'bar') {
      barData = widget.records
          .asMap()
          .entries
          .map((item) =>
              makeGroupData(item.key, double.parse(item.value.data_value)))
          .toList();
    } else {
      data = widget.records
          .map((item) => FlSpot(
              (item.data_tm.millisecondsSinceEpoch / 1000 / 60),
              double.parse(item.data_value)))
          .toList();
    }

    // https://app.flchart.dev/#/line
    //widget.chartType == 'bar'
    return Expanded(
        child: widget.records.length == 0
            ? Center(child: Text('no_records'.i18n()))
            : Column(children: [
                if (widget.chartType == 'bar')
                  Expanded(
                      child: BarChart(BarChartData(
                          extraLinesData: ExtraLinesData(horizontalLines: [
                            HorizontalLine(
                                y: double.parse(avgValue),
                                label: HorizontalLineLabel(
                                    style: TextStyle(
                                        inherit: true,
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.8),
                                        shadows: [
                                          Shadow(
                                              // bottomLeft
                                              offset: Offset(-1, -1),
                                              color: Colors.white),
                                          Shadow(
                                              // bottomRight
                                              offset: Offset(1, -1),
                                              color: Colors.white),
                                          Shadow(
                                              // topRight
                                              offset: Offset(1, 1),
                                              color: Colors.white),
                                          Shadow(
                                              // topLeft
                                              offset: Offset(-1, 1),
                                              color: Colors.white),
                                        ]),
                                    show: true,
                                    alignment: Alignment.topRight,
                                    labelResolver: (line) =>
                                        "Avg: ${avgValue} / Min: ${minValue} / Max: ${maxValue}"),
                                color: Theme.of(context).primaryColor.withOpacity(0.8),
                                dashArray: [10, 10])
                          ]),
                          barGroups: barData,
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            bottomTitles: getBarBottomTitles(),
                            topTitles: noTitlesWidget(),
                            leftTitles: noTitlesWidget(),
                            rightTitles: noTitlesWidget(),
                          ),
                          barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                  tooltipBorder: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  getTooltipColor: (_) => Colors.white,
                                  getTooltipItem: (
                                    BarChartGroupData group,
                                    int groupIndex,
                                    BarChartRodData rod,
                                    int rodIndex,
                                  ) {
                                    return BarTooltipItem(
                                        rod.toY.toString() + "\n", TextStyle(),
                                        children: [
                                          TextSpan(
                                              text:
                                                  DateFormat('yyyy-MM-dd kk:mm')
                                                      .format(widget
                                                          .records[group.x]
                                                          .data_tm),
                                              style: TextStyle(fontSize: 10))
                                        ]);
                                  },
                                  fitInsideVertically: true,
                                  fitInsideHorizontally: true))))),
                if (widget.chartType == 'line')
                  Expanded(
                      child: LineChart(LineChartData(
                    extraLinesData: ExtraLinesData(horizontalLines: [
                      HorizontalLine(
                          y: double.parse(avgValue),
                          label: HorizontalLineLabel(
                              show: true,
                              alignment: Alignment.topRight,
                              style: TextStyle(
                                  inherit: true,
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.8),
                                  shadows: [
                                    Shadow(
                                        // bottomLeft
                                        offset: Offset(-1, -1),
                                        color: Colors.white),
                                    Shadow(
                                        // bottomRight
                                        offset: Offset(1, -1),
                                        color: Colors.white),
                                    Shadow(
                                        // topRight
                                        offset: Offset(1, 1),
                                        color: Colors.white),
                                    Shadow(
                                        // topLeft
                                        offset: Offset(-1, 1),
                                        color: Colors.white),
                                  ]),
                              labelResolver: (line) =>
                                  "Avg: ${avgValue} / Min: ${minValue} / Max: ${maxValue}"),
                          color: Theme.of(context).primaryColor.withOpacity(0.8),
                          dashArray: [10, 10])
                    ]),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(
                      show: false,
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
                            getTooltipColor: (_) => Colors.white,
                            tooltipBorder: BorderSide(
                                color: Theme.of(context).primaryColor),
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((touchedSpot) {
                                return LineTooltipItem(
                                    touchedSpot.y.toString() + "\n",
                                    TextStyle(),
                                    children: [
                                      TextSpan(
                                          text: DateFormat('yyyy-MM-dd kk:mm')
                                              .format(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      (touchedSpot.x *
                                                              1000 *
                                                              60)
                                                          .toInt())),
                                          style: TextStyle(fontSize: 10))
                                    ]);
                              }).toList();
                            })),
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
                  ))),
                if (widget.chartType == 'history')
                  Expanded(
                      child: ObjectHistory(
                    records: widget.records,
                    valueType: widget.historyType,
                  ))
              ]));
  }

  AxisTitles getBarBottomTitles() {
    const style = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 10,
    );
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 20,
        getTitlesWidget: (value, meta) {
          String text = '';
          HistoryRecord itemRecord = widget.records[value.toInt()];
          text = getDate(itemRecord.data_tm.millisecondsSinceEpoch / 1000 / 60);
          return Text(text, style: style);
        },
      ),
    );
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
    String locale = 'locale'.i18n();

    if (widget.intervalType == 'day') {
      hmFormat = widget.chartType == 'bar'
          ? DateFormat('H', locale)
          : DateFormat('Hm', locale);
    }
    if (widget.intervalType == 'week') {
      hmFormat = widget.chartType == 'bar'
          ? DateFormat('E', locale)
          : DateFormat('dd.MM H:m', locale);
    }
    if (widget.intervalType == 'month') {
      hmFormat = DateFormat('d/M', locale);
    }
    if (widget.intervalType == 'year') {
      hmFormat = DateFormat('MMM', locale);
    }
    return hmFormat.format(
        DateTime.fromMillisecondsSinceEpoch((value * 1000 * 60).toInt()));
  }

  AxisTitles noTitlesWidget() {
    return const AxisTitles(sideTitles: SideTitles());
  }
}
