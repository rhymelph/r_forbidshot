import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:r_forbidshot/r_forbidshot.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  void onChanged(bool value) {
    if (value == true) {
      RForbidshot.startForbidshot();
      setState(() {});
    } else {
      RForbidshot.stopForbidshot();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ForbidshotWidget(
      onScreenShot: () {
        showCupertinoDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
                  title: const Text('请不要截屏'),
                  content: const Text('为了您的财产安全，请不要截屏分享'),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text('知道了'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      },
      captureWidget: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          alignment: Alignment.center,
          child: const Text(
            '',
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child:
              CupertinoSwitch(value: RForbidshot.isOpen, onChanged: onChanged),
        ),
      ),
    );
  }
}
