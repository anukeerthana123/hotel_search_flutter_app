import 'package:mytravaly/features/google_signIn_signUp/data/models/device_info_model.dart';

import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signInWithGoogle();
  Future<UserEntity> login(String email, String password);
  Future<String> registerDevice(DeviceRegisterModel model, String authToken);
}
