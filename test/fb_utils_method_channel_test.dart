import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fb_utils/fb_utils_method_channel.dart';

void main() {
  MethodChannelFbUtils platform = MethodChannelFbUtils();
  const MethodChannel channel = MethodChannel('fb_utils');

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
    expect(await platform.getPlatformVersion(), '42');
  });
}
