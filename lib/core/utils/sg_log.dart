import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:stack_trace/stack_trace.dart' ;

class SGLog {
  static void info(String tag, String message) {
    _log(tag, 'INFO', message, '\x1B[97m');
  }

  static void warning(String tag, String message) {
    _log(tag, 'WARNING', message, '\x1B[93m');
  }

  static void error(String tag, String message, [dynamic error, StackTrace? stackTrace]) {
    _log(tag, 'ERROR', message, '\x1B[91m', error: error, stackTrace: stackTrace);
  }

  static void debug(String tag, String message) {
    _log(tag, 'DEBUG', message, '\x1B[92m');
  }

  static void _log(String tag, String level, String message, String color, {dynamic error, StackTrace? stackTrace}) {
    if (!_shouldLog()) return;

    final trace = stackTrace ?? StackTrace.current;
    final frames = Trace.from(trace).frames;
    final callerFrame = frames.firstWhere(
      (frame) => !frame.uri.toString().contains('log.dart'),
      orElse: () => frames.first,
    );
    final location = '${callerFrame.uri.toString().split('/').last}:${callerFrame.line}';

    final logMessage = '[$level]=>[$tag] ($location): $message';
    final coloredMessage = '$color$logMessage\x1B[0m';

    if (error != null) {
      log(coloredMessage, error: error, stackTrace: stackTrace);
    } else {
      log(coloredMessage);
    }
  }

  static bool _shouldLog() {
    return kDebugMode;
  }
}
