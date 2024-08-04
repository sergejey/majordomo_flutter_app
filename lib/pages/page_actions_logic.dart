import 'package:flutter/material.dart';
import 'package:home_app/pages/page_actions_notifier.dart';
import 'package:home_app/pages/page_actions.dart';

class ActionsPageManager {
  final pageActionsNotifier = PageActionsNotifier();

  void initActionsPageState(String deviceId) {
    pageActionsNotifier.initialize(deviceId);
  }

  void addLinkClicked() {

  }

}
