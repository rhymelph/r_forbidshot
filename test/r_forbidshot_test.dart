import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:r_forbidshot/r_forbidshot.dart';

void main() {
  const MethodChannel channel = MethodChannel('r_forbidshot');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    // expect(await RForbidshot.platformVersion, '42');
  });
}
