import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class TextUpdated extends StatelessWidget {
  const TextUpdated({
    super.key,
    required this.updated,
  });

  final String updated;

  @override
  Widget build(BuildContext context) {
    String updatedText = "";
    if (updated!="") {
      int intUpdated = int.parse(updated);
      int timeNow = (DateTime.now().millisecondsSinceEpoch/1000).round();
      int timePassed = timeNow - intUpdated;
      if (timePassed<0) timePassed = 0;
      if (timePassed >= 24 * 60 * 60) {
        int days = (timePassed/(24*60*60)).round();
        updatedText = "${days.toString()}"+"time_d".i18n()+" "+"time_go".i18n();
      } else if (timePassed >= 12 *60 * 60) {
        int hours = (timePassed/(60*60)).round();
        updatedText = "${hours.toString()}"+"time_h".i18n()+" "+"time_go".i18n();
      } else if (timePassed >= 60 * 60) {
        int hours = (timePassed/(60*60)).floor();
        int minutes = ((timePassed - hours * 60 *60)/60).round();
        updatedText = "${hours.toString()}"+"time_h".i18n()+" ${minutes.toString()}"+"time_m".i18n()+" "+"time_go".i18n();
      } else if (timePassed >= 60) {
        int minutes = (timePassed/60).round();
        updatedText = "${minutes.toString()}"+"time_m".i18n()+" "+"time_go".i18n();
      } else if (timePassed < 5) {
        updatedText = "time_Now".i18n();
      } else {
        updatedText = "${timePassed.toString()}"+"time_s".i18n()+" "+"time_go".i18n();
      }
    }
    return Text(
      updatedText,
      style: Theme.of(context).textTheme.bodySmall,
      overflow: TextOverflow.ellipsis,
    );
  }
}
