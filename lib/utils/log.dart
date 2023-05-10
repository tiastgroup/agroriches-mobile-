import 'package:flutter/foundation.dart';

///log extension on object
extension Log on Object {
  // ignore: avoid_print
  /// print object to string
  void log() {
    if (kDebugMode) {
      print(toString());
    }
  }
}
