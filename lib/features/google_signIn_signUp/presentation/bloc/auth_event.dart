import 'package:equatable/equatable.dart';
import 'package:mytravaly/features/google_signIn_signUp/data/models/device_info_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class GoogleSignInRequested extends AuthEvent {
  const GoogleSignInRequested();

  @override
  List<Object?> get props => [];
}

class RegisterDeviceEvent extends AuthEvent {
  final DeviceRegisterModel model;
  final String authToken;

  const RegisterDeviceEvent({required this.model, required this.authToken});
}

// ✅ Optional: Logout event (if you want to expand later)
class LogoutRequested extends AuthEvent {}
