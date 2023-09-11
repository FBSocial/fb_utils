import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class FbUtils {
  static const MethodChannel _channel = const MethodChannel('fb_utils');

  ///Method to get MD5 String
  ///- [filePath] : path of local file
  static Future<String?> getMD5WithPath(String filePath) async {
    var map = {
      'file_path': filePath,
    };
    var checksum = await _channel.invokeMethod<String>('getFileMD5', map);
    return checksum;
  }

  ///Method to get MD5 String
  ///- [target] : to md5 target
  static Future<String?> getMD5WithSring(String target) async {
    var map = {
      'target': target,
    };
    var checksum = await _channel.invokeMethod<String>('getStringMD5', map);
    return checksum;
  }

  /// 隐藏键盘 iOS
  static Future<void> hideKeyboard() async {
    if (Platform.isIOS) {
      _channel.invokeMethod<String>('hideKeyboard', null);
    }
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
