import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class DeviceInfoHelper {
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return {
        "deviceModel": androidInfo.model,
        "deviceFingerprint": androidInfo.fingerprint,
        "deviceBrand": androidInfo.brand,
        "deviceId": androidInfo.id,
        "deviceName": androidInfo.device,
        "deviceManufacturer": androidInfo.manufacturer,
        "deviceProduct": androidInfo.product,
        "deviceSerialNumber": "unknown", // Android 10+ restricts access
      };
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return {
        "deviceModel": iosInfo.utsname.machine,
        "deviceFingerprint": iosInfo.identifierForVendor ?? "unknown",
        "deviceBrand": "Apple",
        "deviceId": iosInfo.identifierForVendor ?? "unknown",
        "deviceName": iosInfo.name,
        "deviceManufacturer": "Apple",
        "deviceProduct": iosInfo.systemName,
        "deviceSerialNumber": "unknown",
      };
    }

    return {};
  }
}
