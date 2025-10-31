import 'package:mytravaly/features/google_signIn_signUp/data/datasources/auth_data_source.dart';
import 'package:mytravaly/features/google_signIn_signUp/data/models/device_info_model.dart';
import 'package:mytravaly/features/google_signIn_signUp/domain/entities/user_entity.dart';
import 'package:mytravaly/features/google_signIn_signUp/domain/repositories/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.localDataSource);

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      return await localDataSource.signInWithGoogle();
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      return await localDataSource.login(email, password);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<String> registerDevice(DeviceRegisterModel model, String authToken) {
    return localDataSource.registerDevice(model, authToken);
  }
}
