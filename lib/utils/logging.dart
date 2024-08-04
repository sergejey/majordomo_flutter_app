import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void dprint(String message) {
  if (kDebugMode) {
    print("${DateTime.now().toString()} $message");
  }
}

void alert(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: Duration(seconds: 2),),
  );
}