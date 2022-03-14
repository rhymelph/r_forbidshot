import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
export 'forbidshot_widget.dart';

class RForbidshot {
  static MethodChannel? _channel;
  static bool isOpen = false;

  static MethodChannel get channel {
    _channel ??= const MethodChannel('r_forbidshot')
      ..setMethodCallHandler(_handleCallHandler);
    return _channel!;
  }

  static Future<dynamic> startForbidshot() async {
    isOpen = true;
    channel.invokeMethod('forbidshot', {
      'isOpen': true,
    });
    if (Platform.isIOS) {
      _iosCaptureChangeCtl.add(await iosCapturedStatus);
    }
  }

  static Future<dynamic> stopForbidshot() async {
    isOpen = false;
    await channel.invokeMethod('forbidshot', {
      'isOpen': false,
    });
    if (Platform.isIOS) {
      _iosCaptureChangeCtl.add(false);
    }
  }

  static final StreamController<bool> _iosCaptureChangeCtl =
      StreamController.broadcast();

  static Stream<bool> get iosCaptureChangeStream => _iosCaptureChangeCtl.stream;

  static final StreamController<void> _iosScreenShotCtl =
      StreamController.broadcast();

  static Stream<void> get iosScreenShotStream => _iosScreenShotCtl.stream;

  static Future<bool> get iosCapturedStatus async =>
      await channel.invokeMethod('iosShotStatus') as bool;

  static Future _handleCallHandler(MethodCall call) async {
    if (call.method == "iosCapturedStatus") {
      _iosCaptureChangeCtl.add(call.arguments);
    } else if (call.method == 'iosScreenShots') {
      _iosScreenShotCtl.add(null);
    }
    return null;
  }
}
