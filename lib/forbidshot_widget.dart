import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:r_forbidshot/r_forbidshot.dart';

/// IOS 监听录屏 和 截图
///
/// [captureWidget] 录屏时展示的Widget
/// [onCapture] 录屏时的回调
/// [onScreenShot] 截图时的回调
class ForbidshotWidget extends StatefulWidget {
  final Widget child;
  final Widget? captureWidget;
  final VoidCallback? onScreenShot;
  final ValueChanged<bool>? onCapture;

  const ForbidshotWidget(
      {Key? key,
      required this.child,
      this.captureWidget,
      this.onScreenShot,
      this.onCapture})
      : super(key: key);

  @override
  _ForbidshotWidgetState createState() => _ForbidshotWidgetState();
}

class _ForbidshotWidgetState extends State<ForbidshotWidget> {
  StreamSubscription<bool>? subCapture;
  StreamSubscription<void>? subScreenShot;
  OverlayEntry? entry;

  @override
  void initState() {
    super.initState();
    subCapture = RForbidshot.iosCaptureChangeStream.listen(_handleCapture);
    subScreenShot = RForbidshot.iosScreenShotStream.listen(_handleScreenShot);
    if (Platform.isIOS) {
      RForbidshot.iosCapturedStatus.then(_handleCapture);
    }
  }

  @override
  void dispose() {
    super.dispose();
    subCapture?.cancel();
    subScreenShot?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _handleCapture(event) {
    widget.onCapture?.call(event);
    if (widget.captureWidget != null) {
      if (event == true) {
        entry?.remove();
        entry = null;
        entry = OverlayEntry(
            builder: (BuildContext context) => Material(
                  color: Colors.transparent,
                  type: MaterialType.transparency,
                  child: widget.captureWidget,
                ));
        Overlay.of(context)!.insert(entry!);
      } else {
        entry?.remove();
        entry = null;
      }
    }
  }

  void _handleScreenShot(_) {
    widget.onScreenShot?.call();
  }
}
