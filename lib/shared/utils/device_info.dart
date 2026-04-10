import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'platform_info.dart';

String getBasicOsInfo() {
  if (PlatformInfo.isWeb) return 'Web';
  if (PlatformInfo.isAndroid) return 'Android';
  if (PlatformInfo.isIOS) return 'iOS';
  return 'Unknown OS';
}

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<Map<String, String>> getDeviceInfo() async {
    Map<String, String> deviceInfo = {};
    try {
      if (PlatformInfo.isWeb) {
        final webInfo = await _deviceInfo.webBrowserInfo;
        deviceInfo['deviceName'] = webInfo.browserName.name;
        deviceInfo['osVersion'] = 'Web (${webInfo.platform ?? 'Unknown'})';
      } else if (PlatformInfo.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        deviceInfo['deviceName'] = androidInfo.model;
        deviceInfo['osVersion'] = 'Android ${androidInfo.version.release}';
      } else if (PlatformInfo.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        deviceInfo['deviceName'] = iosInfo.name ?? iosInfo.model ?? 'Unknown';
        deviceInfo['osVersion'] = 'iOS ${iosInfo.systemVersion}';
      }
    } catch (e) {
      debugPrint('Error getting device info: $e');
      deviceInfo['deviceName'] = 'Unknown';
      deviceInfo['osVersion'] = 'Unknown';
    }
    return deviceInfo;
  }
}