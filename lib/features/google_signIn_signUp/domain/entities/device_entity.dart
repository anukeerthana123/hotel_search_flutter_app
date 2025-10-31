class DeviceEntity {
  final String deviceModel;
  final String deviceFingerprint;
  final String deviceBrand;
  final String deviceId;
  final String deviceName;
  final String deviceManufacturer;
  final String deviceProduct;
  final String deviceSerialNumber;

  DeviceEntity({
    required this.deviceModel,
    required this.deviceFingerprint,
    required this.deviceBrand,
    required this.deviceId,
    required this.deviceName,
    required this.deviceManufacturer,
    required this.deviceProduct,
    required this.deviceSerialNumber,
  });

  Map<String, dynamic> toJson() => {
        "deviceModel": deviceModel,
        "deviceFingerprint": deviceFingerprint,
        "deviceBrand": deviceBrand,
        "deviceId": deviceId,
        "deviceName": deviceName,
        "deviceManufacturer": deviceManufacturer,
        "deviceProduct": deviceProduct,
        "deviceSerialNumber": deviceSerialNumber,
      };
}
