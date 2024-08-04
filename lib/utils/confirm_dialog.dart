import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

Future<bool> confirm(
    BuildContext context, {
      Widget? title,
      Widget? content,
      Widget? textOK,
      Widget? textCancel,
      bool canPop = false,
      void Function(bool)? onPopInvoked,
    }) async {
  final bool? isConfirm = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => PopScope(
      child: AlertDialog(
        title: title ?? Text('dialog_confirmation'.i18n()),
        content: SingleChildScrollView(
          child: content ?? Text('dialog_are_you_sure'.i18n()),
        ),
        actions: <Widget>[
          TextButton(
            child: textCancel ??
                Text('dialog_cancel'.i18n()),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child:
            textOK ?? Text('dialog_ok'.i18n()),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
      canPop: canPop,
      onPopInvoked: onPopInvoked,
    ),
  );
  return isConfirm ?? false;
}