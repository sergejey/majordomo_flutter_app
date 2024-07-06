import 'package:flutter/material.dart';
import 'package:home_app/commonWidgets/history_chart.dart';
import 'package:home_app/commonWidgets/object_history.dart';
import 'package:home_app/models/history_record.dart';
import 'package:home_app/services/service_locator.dart';
import 'package:home_app/services/data_service.dart';
import 'package:home_app/utils/logging.dart';

class DeviceChart extends StatefulWidget {
  const DeviceChart(
      {super.key,
      required this.deviceObject,
      required this.deviceProperty,
      this.chartType = 'line'});

  final String deviceObject;
  final String deviceProperty;
  final String chartType;

  @override
  State<DeviceChart> createState() => _DeviceChartState();
}

class _DeviceChartState extends State<DeviceChart> {
  final _dataService = getIt<DataService>();

  List<HistoryRecord> valueHistory = [];
  String chartPeriod = '';
  String chartObject = '';
  String chartProperty = '';

  @override
  void didUpdateWidget(DeviceChart oldWidget) {

    super.didUpdateWidget(oldWidget);
    if (oldWidget.deviceObject != widget.deviceObject) {
      selectPeriod('hour');
    }
  }

  void selectPeriod(String periodName) {
    setState(() {
      chartObject = widget.deviceObject;
      chartProperty = widget.deviceProperty;
      chartPeriod = periodName;
      loadChartData();
    });
  }

  void loadChartData() async {
    String historyPeriod;
    if (chartPeriod == 'day') {
      historyPeriod = '1day';
    } else if (chartPeriod == 'hour') {
      historyPeriod = '1';
    } else if (chartPeriod == 'week') {
      historyPeriod = '1week';
    } else if (chartPeriod == 'month') {
      historyPeriod = '1month';
    } else {
      historyPeriod = '1month';
    }
    List<HistoryRecord> historyLoaded = await _dataService.getPropertyHistory(
        chartObject, chartProperty, historyPeriod);
    setState(() {
      valueHistory = historyLoaded;
    });
  }

  @override
  void initState() {
    super.initState();
    selectPeriod('hour');
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
              PeriodWidget(
                  title: 'Час',
                  value: 'hour',
                  selected: chartPeriod == 'hour',
                  onTap: selectPeriod),
              SizedBox(width: 10),
              PeriodWidget(
                  title: 'День',
                  value: 'day',
                  selected: chartPeriod == 'day',
                  onTap: selectPeriod),
              SizedBox(width: 10),
              PeriodWidget(
                  title: 'Неделя',
                  value: 'week',
                  selected: chartPeriod == 'week',
                  onTap: selectPeriod),
              SizedBox(width: 10),
              PeriodWidget(
                  title: 'Месяц',
                  value: 'month',
                  selected: chartPeriod == 'month',
                  onTap: selectPeriod)
            ],
          ),
          SizedBox(height: 10),
          HistoryChart(records: valueHistory, intervalType: chartPeriod)
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
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.onPrimary,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              )),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title,
                style: TextStyle(
                    color: selected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).primaryColor)),
          )),
    );
  }
}
