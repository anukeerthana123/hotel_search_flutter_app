import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mytravaly/core/utils/device_info_helper.dart';
import 'package:mytravaly/core/utils/shared_preference.dart';
import 'package:mytravaly/features/Dashboard/presentation/screens/dashboard_hotel_list_screen.dart';
import 'package:mytravaly/features/google_signIn_signUp/data/datasources/auth_data_source.dart';
import 'package:mytravaly/features/google_signIn_signUp/data/models/device_info_model.dart';
import 'package:mytravaly/features/google_signIn_signUp/data/repositories/auth_repo_impl.dart';
import 'package:mytravaly/features/google_signIn_signUp/domain/usecases/auth_usecase.dart';
import 'package:mytravaly/features/google_signIn_signUp/presentation/bloc/auth_bloc.dart';
import 'package:mytravaly/features/google_signIn_signUp/presentation/bloc/auth_event.dart';
import 'package:mytravaly/features/google_signIn_signUp/presentation/bloc/auth_state.dart';
import 'package:mytravaly/features/google_signIn_signUp/presentation/widgets/signin_button.dart';

class GoogleSigninScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final token = dotenv.env['AUTH_TOKEN'];

  GoogleSigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = AuthBloc(
      AuthUseCase(AuthRepositoryImpl(AuthLocalDataSourceImpl())),
    );

    return BlocProvider(
      create: (_) => bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            debugPrint('state: ${state.toString()}');
            if (state is DeviceRegisterSuccess) {
              TokenHelper.saveVisitorToken(state.visitorToken);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      DashboardPage(visitorToken: state.visitorToken),
                ),
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Icon(Icons.account_circle, size: 50),
                    const SizedBox(height: 20),
                    const Text(
                      'Sign into your account',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    GoogleSignInButton(
                      onPressed: () =>
                          context.read<AuthBloc>().add(GoogleSignInRequested()),
                    ),
                    const SizedBox(height: 20),
                    const Text('or'),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    state is AuthLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              var authToken = token;

                              final deviceInfo =
                                  await DeviceInfoHelper.getDeviceInfo();
                              final model =
                                  DeviceRegisterModel.fromMap(deviceInfo);

                              context.read<AuthBloc>().add(
                                    RegisterDeviceEvent(
                                      model: model,
                                      authToken: authToken!,
                                    ),
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF4285F4), // Google Blue
                              foregroundColor: Colors.white,
                              elevation: 3,
                              minimumSize: const Size(200, 50),
                            ),
                            child: const Text('Login'),
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
