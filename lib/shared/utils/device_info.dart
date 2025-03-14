import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

String getBasicOsInfo() {
  if (Platform.isAndroid) {
    return 'Android ${Platform.operatingSystemVersion}';
  } else if (Platform.isIOS) {
    return 'iOS ${Platform.operatingSystemVersion}';
  }
  return 'Unknown OS';
}

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<Map<String, String>> getDeviceInfo() async {
    Map<String, String> deviceInfo = {};
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        deviceInfo['deviceName'] = androidInfo.model;
        deviceInfo['osVersion'] = 'Android ${androidInfo.version.release}';
      }
      else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        deviceInfo['deviceName'] = iosInfo.name ?? iosInfo.model ?? 'Unknown';
        deviceInfo['osVersion'] = 'iOS ${iosInfo.systemVersion}';
      }
    } catch (e) {
      print('Error getting device info: $e');
      deviceInfo['deviceName'] = 'Unknown';
      deviceInfo['osVersion'] = 'Unknown';
    }
    return deviceInfo;
  }
}