import 'package:flutter/material.dart';
import 'package:home_app/commonWidgets/history_chart.dart';
import 'package:home_app/commonWidgets/object_history.dart';
import 'package:home_app/models/history_record.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/services/data_service.dart';
import 'package:home_app/utils/logging.dart';
import 'package:localization/localization.dart';

class DeviceChart extends StatefulWidget {
  const DeviceChart({super.key,
    required this.deviceObject,
    required this.deviceProperty,
    this.devicePropertyHour = '',
    this.devicePropertyDay = '',
    this.devicePropertyWeek = '',
    this.devicePropertyMonth = '',
    this.devicePropertyYear = '',
    this.chartType = 'line',
    this.defaultPeriod = 'hour',
    this.periodsEnabled = const ['hour', 'day', 'week', 'month'],
    this.historyType = 'onoff'
  });

  final String deviceObject;
  final String deviceProperty;
  final String devicePropertyHour;
  final String devicePropertyDay;
  final String devicePropertyWeek;
  final String devicePropertyMonth;
  final String devicePropertyYear;
  final String chartType;
  final String defaultPeriod;
  final List<String> periodsEnabled;
  final String historyType;

  @override
  State<DeviceChart> createState() => _DeviceChartState();
}

class _DeviceChartState extends State<DeviceChart> {
  final _dataService = getIt<DataService>();

  List<HistoryRecord> valueHistory = [];
  String chartPeriod = '';
  String chartObject = '';
  String chartProperty = '';
  String chartPropertyHour = '';
  String chartPropertyDay = '';
  String chartPropertyWeek = '';
  String chartPropertyMonth = '';
  String chartPropertyYear = '';
  List<String> chartPeriods = const ['hour', 'day', 'week', 'month'];

  @override
  void didUpdateWidget(DeviceChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deviceObject != widget.deviceObject) {
      selectPeriod(widget.defaultPeriod);
    }
  }

  void selectPeriod(String periodName) {
    setState(() {
      chartPeriods = widget.periodsEnabled;
      chartObject = widget.deviceObject;
      chartProperty = widget.deviceProperty;
      chartPropertyHour = widget.devicePropertyHour != ''
          ? widget.devicePropertyHour
          : chartProperty;
      chartPropertyDay = widget.devicePropertyDay != ''
          ? widget.devicePropertyDay
          : chartProperty;
      chartPropertyWeek = widget.devicePropertyWeek != ''
          ? widget.devicePropertyWeek
          : chartProperty;
      chartPropertyMonth = widget.devicePropertyMonth != ''
          ? widget.devicePropertyMonth
          : chartProperty;
      chartPropertyYear = widget.devicePropertyYear != ''
          ? widget.devicePropertyYear
          : chartProperty;
      chartPeriod = periodName;
      loadChartData();
    });
  }

  void loadChartData() async {
    String historyPeriod;
    String historyProperty;
    if (chartPeriod == 'day') {
      historyPeriod = '1day';
      historyProperty = chartPropertyDay;
    } else if (chartPeriod == 'week') {
      historyPeriod = '1week';
      historyProperty = chartPropertyWeek;
    } else if (chartPeriod == 'month') {
      historyPeriod = '1month';
      historyProperty = chartPropertyMonth;
    } else if (chartPeriod == 'year') {
      historyPeriod = '12month';
      historyProperty = chartPropertyYear;
    } else {
      historyProperty = chartPropertyHour;
      historyPeriod = '1';
    }
    List<HistoryRecord> historyLoaded = await _dataService.getPropertyHistory(
        chartObject, historyProperty, historyPeriod);
    setState(() {
      valueHistory = historyLoaded;
    });
  }

  @override
  void initState() {
    super.initState();
    selectPeriod(widget.defaultPeriod);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          child: Column(
            children: [
              Row(
                children: [
                  if (chartPeriods.contains('hour')) ...[
                    PeriodWidget(
                        title: 'period_hour'.i18n(),
                        value: 'hour',
                        selected: chartPeriod == 'hour',
                        onTap: selectPeriod)
                  ],
                  if (chartPeriods.contains('day')) ...[
                    SizedBox(width: 10),
                    PeriodWidget(
                        title: 'period_day'.i18n(),
                        value: 'day',
                        selected: chartPeriod == 'day',
                        onTap: selectPeriod)
                  ],
                  if (chartPeriods.contains('week')) ...[
                    SizedBox(width: 10),
                    PeriodWidget(
                        title: 'period_week'.i18n(),
                        value: 'week',
                        selected: chartPeriod == 'week',
                        onTap: selectPeriod)
                  ],
                  if (chartPeriods.contains('month')) ...[
                    SizedBox(width: 10),
                    PeriodWidget(
                        title: 'period_month'.i18n(),
                        value: 'month',
                        selected: chartPeriod == 'month',
                        onTap: selectPeriod)
                  ],
                  if (chartPeriods.contains('year')) ...[
                    SizedBox(width: 10),
                    PeriodWidget(
                        title: 'period_year'.i18n(),
                        value: 'year',
                        selected: chartPeriod == 'year',
                        onTap: selectPeriod)
                  ]
                ],
              ),
              SizedBox(height: 10),
              HistoryChart(records: valueHistory, intervalType: chartPeriod, chartType: widget.chartType, historyType: widget.historyType,)
            ],
          ),
        ));
  }
}

class PeriodWidget extends StatelessWidget {
  const PeriodWidget({
    super.key,
    required this.title,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String value;
  final bool selected;
  final onTap;

  @override
  Widget build(BuildContext context) {
    final stateManager = context.widget;
    return GestureDetector(
      onTap: () {
        onTap(value);
      },
      child: Container(
          decoration: BoxDecoration(
              color: selected
                  ? Theme
                  .of(context)
                  .primaryColor
                  : Theme
                  .of(context)
                  .colorScheme
                  .onPrimary,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              )),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title,
                style: TextStyle(
                    color: selected
                        ? Theme
                        .of(context)
                        .colorScheme
                        .onPrimary
                        : Theme
                        .of(context)
                        .primaryColor)),
          )),
    );
  }
}
