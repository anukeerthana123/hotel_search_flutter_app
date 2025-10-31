// test/features/google_signIn_signUp/data/datasources/auth_local_data_source_test.dart

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart'; // Import Mocktail
import 'package:mytravaly/features/google_signIn_signUp/data/models/device_info_model.dart';
import 'package:mytravaly/features/google_signIn_signUp/data/models/user_model.dart';

import '../../../../../lib/features/google_signIn_signUp/data/datasources/auth_data_source.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockDeviceRegisterModel extends Mock implements DeviceRegisterModel {}

void main() {
  late AuthLocalDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;
  late MockDeviceRegisterModel mockDeviceRegisterModel;

  const tBaseUrl = 'http://testurl.com/api';

  setUpAll(() {
    registerFallbackValue(Uri.parse(tBaseUrl));
    registerFallbackValue(DeviceRegisterModel(
        deviceModel: '',
        deviceFingerprint: '',
        deviceBrand: '',
        deviceId: '',
        deviceName: '',
        deviceManufacturer: '',
        deviceProduct: '',
        deviceSerialNumber: ''));
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockDeviceRegisterModel = MockDeviceRegisterModel();

    // Instantiate the data source (assuming the refactoring mentioned above)
    // For testing signInWithGoogle and login, we can use the original class
    dataSource = AuthLocalDataSourceImpl();
  });

  group('login', () {
    const tEmail = 'test@gmail.com';
    const tPassword = '1234';
    const tUserModel =
        UserModel(id: 'user_001', name: 'Test User', email: tEmail);

    test('should return a UserModel when credentials are valid', () async {
      // Act
      final result = await dataSource.login(tEmail, tPassword);

      // Assert
      expect(result, equals(tUserModel));
    });

    test('should throw an Exception when credentials are invalid', () async {
      // Assert
      expect(
          () => dataSource.login('wrong@gmail.com', tPassword),
          throwsA(isA<Exception>().having((e) => e.toString(), 'message',
              contains('Invalid credentials'))));
      expect(
          () => dataSource.login(tEmail, 'wrong_password'),
          throwsA(isA<Exception>().having((e) => e.toString(), 'message',
              contains('Invalid credentials'))));
    });
  });

  group('signInWithGoogle', () {
    const tUserModel = UserModel(
        id: 'google_123', name: 'Google User', email: 'googleuser@gmail.com');

    test('should return the hardcoded UserModel', () async {
      // Act
      final result = await dataSource.signInWithGoogle();

      // Assert
      expect(result, equals(tUserModel));
    });
  });

  group('registerDevice', () {
    const tAuthToken = 'Bearer xyz123';
    const tVisitorToken = 'vistor_token_abc';
    const tRegisterModelJson = {'device_id': '123', 'platform': 'android'};

    // Re-initialize for the refactored method
    setUp(() {
      dataSource = AuthLocalDataSourceImpl();
      when(() => mockDeviceRegisterModel.toJson())
          .thenReturn(tRegisterModelJson);
    });

    test(
        'should return visitorToken on successful registration (200, status: true)',
        () async {
      // Arrange
      final responseBody = jsonEncode({
        'status': true,
        'message': 'Device registered',
        'data': {'visitorToken': tVisitorToken}
      });
      when(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response(responseBody, 200));

      // Act
      final result =
          await dataSource.registerDevice(mockDeviceRegisterModel, tAuthToken);

      // Assert
      expect(result, tVisitorToken);
      verify(() => mockHttpClient.post(
            Uri.parse(tBaseUrl),
            headers: {
              'Content-Type': 'application/json',
              'authtoken': tAuthToken
            },
            body: jsonEncode(tRegisterModelJson),
          )).called(1);
    });

    test('should throw Exception if statusCode is not 200 or 201 (e.g., 500)',
        () async {
      // Arrange
      when(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response('Server error', 500));

      // Assert
      expect(
          () => dataSource.registerDevice(mockDeviceRegisterModel, tAuthToken),
          throwsA(isA<Exception>().having((e) => e.toString(), 'message',
              contains('Failed to register device'))));
    });

    test('should throw Exception if server returns status: false (200/201)',
        () async {
      // Arrange
      const tMessage = 'Registration failed on server';
      final responseBody =
          jsonEncode({'status': false, 'message': tMessage, 'data': null});
      when(() => mockHttpClient.post(
                any(),
                headers: any(named: 'headers'),
                body: any(named: 'body'),
              ))
          .thenAnswer((_) async =>
              http.Response(responseBody, 201)); // Testing 201 case

      // Assert
      expect(
          () => dataSource.registerDevice(mockDeviceRegisterModel, tAuthToken),
          throwsA(isA<Exception>()
              .having((e) => e.toString(), 'message', contains(tMessage))));
    });
  });
}
