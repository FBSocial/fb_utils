import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fb_utils_method_channel.dart';

abstract class FbUtilsPlatform extends PlatformInterface {
  /// Constructs a FbUtilsPlatform.
  FbUtilsPlatform() : super(token: _token);

  static final Object _token = Object();

  static FbUtilsPlatform _instance = MethodChannelFbUtils();

  /// The default instance of [FbUtilsPlatform] to use.
  ///
  /// Defaults to [MethodChannelFbUtils].
  static FbUtilsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FbUtilsPlatform] when
  /// they register themselves.
  static set instance(FbUtilsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
