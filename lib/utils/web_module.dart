
import 'package:flutter/foundation.dart';

bool isMJDModule() {
  if (kIsWeb) return true;
  if (kIsWeb && kReleaseMode) return true;
  return false;
}