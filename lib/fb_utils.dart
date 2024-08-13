import 'dart:async';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:convert/convert.dart';
import 'package:flutter/foundation.dart';

class FbUtils {
  static const MethodChannel _channel = const MethodChannel('fb_utils');
  static int SIZE_100M = 100 << 20;

  ///Method to get MD5 String
  ///- [filePath] : path of local file
  static Future<String?> getMD5WithPath(String filePath) async {
    if (Platform.operatingSystem.toLowerCase().contains('ohos')) {
      return compute(getFileHash, filePath);
    } else {
      var map = {'file_path': filePath};
      var checksum = await _channel.invokeMethod<String>('getFileMD5', map);
      return checksum;
    }
  }

  ///Method to get MD5 String
  ///- [target] : to md5 target
  static Future<String?> getMD5WithSring(String target) async {
    if (Platform.operatingSystem.toLowerCase().contains('ohos')) {
      final content = const convert.Utf8Encoder().convert(target);
      const md5 = crypto.md5;
      final digest = md5.convert(content);
      return hex.encode(digest.bytes);
    } else {
      var map = {'target': target};
      var checksum = await _channel.invokeMethod<String>('getStringMD5', map);
      return checksum;
    }
  }

  static Future<String> getFileHash(String filePath) async {
    final file = File(filePath);
    final fileLength = file.lengthSync();
    const md5 = crypto.md5;
    if (fileLength < SIZE_100M) {
      final fileBytes = file.readAsBytesSync().buffer.asUint8List();
      final hash = md5.convert(fileBytes.buffer.asUint8List()).toString();
      return hash;
    }

    final sFile = await file.open();
    try {
      final output = AccumulatorSink<crypto.Digest>();
      final input = md5.startChunkedConversion(output);
      int x = 0;
      while (x < fileLength) {
        final tmpLen = fileLength - x > SIZE_100M ? SIZE_100M : fileLength - x;
        input.add(sFile.readSync(tmpLen));
        x += tmpLen;
      }
      input.close();
      unawaited(sFile.close());

      final hash = output.events.single;
      return hash.toString();
    } finally {
      unawaited(sFile.close());
    }
  }

  /// 隐藏键盘 iOS
  static Future<void> hideKeyboard() async {
    if (Platform.isIOS) _channel.invokeMethod<String>('hideKeyboard', null);
  }

  /*
  读取粘贴板字符串(string)
  1. iOS
  forceRead = true, 直接读取粘贴板
  forceRead = false, 如果粘贴板内容变化，就返回， 否则为nil
  ---------------------------------------------------
  2. Android
  直接使用Clipboard.getData(Clipboard.kTextPlain);返回
   */
  static Future<String?> getPasteboardText({forceRead = true}) async {
    if (Platform.isIOS) {
      return _channel.invokeMethod<String?>(
          'fbGetPasteboardText', {'forceRead': forceRead ? "force" : ''});
    }
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }
}
