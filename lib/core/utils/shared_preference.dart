import 'package:hive_flutter/hive_flutter.dart';

class TokenHelper {
  static const String _visitorTokenKey = 'visitorToken';
  static final Box _box = Hive.box('tokenBox');

  /// Save visitor token locally
  static Future<void> saveVisitorToken(String token) async {
    await _box.put(_visitorTokenKey, token);
    print('✅ Visitor token saved: $token');
  }

  /// Get visitor token (used in API calls)
  static Future<String?> getVisitorToken() async {
    return _box.get(_visitorTokenKey);
  }

  /// Remove visitor token (for logout)
  static Future<void> clearVisitorToken() async {
    await _box.delete(_visitorTokenKey);
    print('🧹 Visitor token cleared');
  }
}
