class DeviceRegisterModel {
  final String deviceModel;
  final String deviceFingerprint;
  final String deviceBrand;
  final String deviceId;
  final String deviceName;
  final String deviceManufacturer;
  final String deviceProduct;
  final String deviceSerialNumber;

  DeviceRegisterModel({
    required this.deviceModel,
    required this.deviceFingerprint,
    required this.deviceBrand,
    required this.deviceId,
    required this.deviceName,
    required this.deviceManufacturer,
    required this.deviceProduct,
    required this.deviceSerialNumber,
  });

  /// ✅ Converts your model into the API-compatible JSON format
  Map<String, dynamic> toJson() {
    return {
      "action": "deviceRegister",
      "deviceRegister": {
        "deviceModel": deviceModel,
        "deviceFingerprint": deviceFingerprint,
        "deviceBrand": deviceBrand,
        "deviceId": deviceId,
        "deviceName": deviceName,
        "deviceManufacturer": deviceManufacturer,
        "deviceProduct": deviceProduct,
        "deviceSerialNumber": deviceSerialNumber,
      },
    };
  }

  /// ✅ Allows you to build the model easily from device info maps
  factory DeviceRegisterModel.fromMap(Map<String, dynamic> map) {
    return DeviceRegisterModel(
      deviceModel: map['deviceModel'] ?? '',
      deviceFingerprint: map['deviceFingerprint'] ?? '',
      deviceBrand: map['deviceBrand'] ?? '',
      deviceId: map['deviceId'] ?? '',
      deviceName: map['deviceName'] ?? '',
      deviceManufacturer: map['deviceManufacturer'] ?? '',
      deviceProduct: map['deviceProduct'] ?? '',
      deviceSerialNumber: map['deviceSerialNumber'] ?? '',
    );
  }
}
