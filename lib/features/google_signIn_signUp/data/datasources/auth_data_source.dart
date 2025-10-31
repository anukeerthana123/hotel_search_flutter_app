import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mytravaly/features/google_signIn_signUp/data/models/device_info_model.dart';

import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> signInWithGoogle();
  Future<UserModel> login(String email, String password);
  Future<String> registerDevice(DeviceRegisterModel model, String authToken);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final baseUrl = dotenv.env['BASE_URL'];

  @override
  Future<UserModel> signInWithGoogle() async {
    // Mock delay to simulate network call
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
        id: 'google_123', name: 'Google User', email: 'googleuser@gmail.com');
  }

  @override
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'test@gmail.com' && password == '1234') {
      return UserModel(id: 'user_001', name: 'Test User', email: email);
    } else {
      throw Exception('Invalid credentials');
    }
  }

  @override
  Future<String> registerDevice(
      DeviceRegisterModel model, String authToken) async {
    final response = await http.post(
      Uri.parse(baseUrl!),
      headers: {
        'Content-Type': 'application/json',
        'authtoken': authToken,
      },
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['status'] == true) {
        return jsonData['data']['visitorToken'];
      } else {
        throw Exception(jsonData['message']);
      }
    } else {
      throw Exception('Failed to register device');
    }
  }
}
