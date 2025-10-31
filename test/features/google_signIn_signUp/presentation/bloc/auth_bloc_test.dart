import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mytravaly/features/google_signIn_signUp/data/models/device_info_model.dart';
import 'package:mytravaly/features/google_signIn_signUp/domain/entities/user_entity.dart';
import 'package:mytravaly/features/google_signIn_signUp/domain/usecases/auth_usecase.dart';
import 'package:mytravaly/features/google_signIn_signUp/presentation/bloc/auth_bloc.dart';
import 'package:mytravaly/features/google_signIn_signUp/presentation/bloc/auth_event.dart';
import 'package:mytravaly/features/google_signIn_signUp/presentation/bloc/auth_state.dart';

// ---- Mock class for usecase ----
class MockAuthUseCase extends Mock implements AuthUseCase {}

void main() {
  // ✅ Sample device model with all required fields
  DeviceRegisterModel deviceModel = DeviceRegisterModel(
    deviceModel: 'Pixel 7',
    deviceFingerprint: 'fp123',
    deviceBrand: 'Google',
    deviceId: 'device-id-001',
    deviceName: 'Pixel Phone',
    deviceManufacturer: 'Google Inc.',
    deviceProduct: 'pixel7pro',
    deviceSerialNumber: 'SN123456789',
  );
  setUpAll(() {
    registerFallbackValue(deviceModel);
  });

  late MockAuthUseCase mockUseCase;
  late AuthBloc authBloc;

  // ✅ Create a fake UserEntity (since AuthUseCase returns it)
  const fakeUser = UserEntity(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
  );

  const fakeToken = 'fake_token_123';

  setUp(() {
    mockUseCase = MockAuthUseCase();
    authBloc = AuthBloc(mockUseCase);
  });

  tearDown(() async {
    await authBloc.close();
  });

  group('AuthBloc Tests', () {
    // Google Sign-In success
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when GoogleSignInRequested succeeds',
      build: () {
        when(() => mockUseCase.googleSignIn())
            .thenAnswer((_) async => fakeUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(GoogleSignInRequested()),
      expect: () => [isA<AuthLoading>(), isA<AuthSuccess>()],
      verify: (_) {
        verify(() => mockUseCase.googleSignIn()).called(1);
      },
    );

    // Google Sign-In failure
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when GoogleSignInRequested fails',
      build: () {
        when(() => mockUseCase.googleSignIn()).thenThrow(Exception('error'));
        return authBloc;
      },
      act: (bloc) => bloc.add(GoogleSignInRequested()),
      expect: () => [isA<AuthLoading>(), isA<AuthFailure>()],
    );

    // Login success
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when LoginRequested succeeds',
      build: () {
        when(() => mockUseCase.login(any(), any()))
            .thenAnswer((_) async => fakeUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginRequested('test@test.com', '12345')),
      expect: () => [isA<AuthLoading>(), isA<AuthSuccess>()],
      verify: (_) {
        verify(() => mockUseCase.login('test@test.com', '12345')).called(1);
      },
    );

    // Login failure
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when LoginRequested fails',
      build: () {
        when(() => mockUseCase.login(any(), any()))
            .thenThrow(Exception('Login failed'));
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginRequested('bad@test.com', 'wrong')),
      expect: () => [isA<AuthLoading>(), isA<AuthFailure>()],
    );

    // Register Device success
    blocTest<AuthBloc, AuthState>(
      'emits [DeviceRegisterLoading, DeviceRegisterSuccess] when RegisterDeviceEvent succeeds',
      build: () {
        when(() => mockUseCase.registerDevice(any(), any()))
            .thenAnswer((_) async => fakeToken);
        return authBloc;
      },
      act: (bloc) => bloc.add(RegisterDeviceEvent(
        model: deviceModel,
        authToken: 'authToken_123',
      )),
      expect: () =>
          [isA<DeviceRegisterLoading>(), isA<DeviceRegisterSuccess>()],
      verify: (_) {
        verify(() => mockUseCase.registerDevice(any(), any())).called(1);
      },
    );

    // Register Device failure
    blocTest<AuthBloc, AuthState>(
      'emits [DeviceRegisterLoading, DeviceRegisterFailure] when RegisterDeviceEvent fails',
      build: () {
        when(() => mockUseCase.registerDevice(any(), any()))
            .thenThrow(Exception('register failed'));
        return authBloc;
      },
      act: (bloc) => bloc.add(RegisterDeviceEvent(
        model: deviceModel,
        authToken: 'authToken_123',
      )),
      expect: () =>
          [isA<DeviceRegisterLoading>(), isA<DeviceRegisterFailure>()],
    );
  });
}
