import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mytravaly/features/google_signIn_signUp/domain/usecases/auth_usecase.dart';
import 'package:mytravaly/features/google_signIn_signUp/presentation/bloc/auth_event.dart';
import 'package:mytravaly/features/google_signIn_signUp/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCase authUseCase;

  AuthBloc(this.authUseCase) : super(AuthInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignIn);
    on<LoginRequested>(_onLogin);
    on<RegisterDeviceEvent>((event, emit) async {
      emit(DeviceRegisterLoading());
      try {
        final token =
            await authUseCase.registerDevice(event.model, event.authToken);
        emit(DeviceRegisterSuccess(token));
      } catch (e) {
        emit(DeviceRegisterFailure(e.toString()));
      }
    });
  }

  Future<void> _onGoogleSignIn(
      GoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authUseCase.googleSignIn();
      emit(AuthSuccess(user));
    } catch (_) {
      emit(AuthFailure('Google Sign-In failed'));
    }
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authUseCase.login(event.email, event.password);
      emit(AuthSuccess(user));
    } catch (_) {
      emit(AuthFailure('Login failed'));
    }
  }
}
