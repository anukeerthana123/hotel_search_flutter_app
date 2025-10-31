import 'package:mytravaly/features/google_signIn_signUp/data/models/device_info_model.dart';
import 'package:mytravaly/features/google_signIn_signUp/domain/entities/user_entity.dart';
import 'package:mytravaly/features/google_signIn_signUp/domain/repositories/auth_repo.dart';

class AuthUseCase {
  final AuthRepository repository;
  AuthUseCase(this.repository);

  Future<UserEntity> googleSignIn() => repository.signInWithGoogle();

  Future<UserEntity> login(String email, String password) =>
      repository.login(email, password);

  Future<String> registerDevice(DeviceRegisterModel model, String authToken) =>
      repository.registerDevice(model, authToken);
}
