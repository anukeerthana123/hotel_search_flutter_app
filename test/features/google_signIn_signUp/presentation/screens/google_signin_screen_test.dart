import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mytravaly/features/google_signIn_signUp/presentation/bloc/auth_bloc.dart';
import 'package:mytravaly/features/google_signIn_signUp/presentation/bloc/auth_state.dart';
import 'package:mytravaly/features/google_signIn_signUp/presentation/screens/google_signin_screen.dart';
import 'package:network_image_mock/network_image_mock.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  late MockAuthBloc mockBloc;

  setUp(() {
    mockBloc = MockAuthBloc();

    when(() => mockBloc.stream)
        .thenAnswer((_) => const Stream<AuthState>.empty());
    when(() => mockBloc.state).thenReturn(AuthInitial());
  });

  testWidgets('renders Google Sign-In button and text fields', (tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockBloc,
            child: GoogleSigninScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Sign into your account'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsWidgets);
    });
  });

  testWidgets('shows loading indicator when state is AuthLoading',
      (tester) async {
    whenListen(
      mockBloc,
      Stream<AuthState>.fromIterable([AuthLoading()]),
      initialState: AuthInitial(),
    );

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockBloc,
            child: GoogleSigninScreen(),
          ),
        ),
      );

      await tester.pump(); // rebuild

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  testWidgets('shows snackbar on AuthFailure', (tester) async {
    whenListen(
      mockBloc,
      Stream<AuthState>.fromIterable([AuthFailure('Login failed')]),
      initialState: AuthInitial(),
    );

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockBloc,
            child: GoogleSigninScreen(),
          ),
        ),
      );

      await tester.pump(); // for state change
      await tester.pump(const Duration(seconds: 1)); // allow snackbar animation

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Login failed'), findsOneWidget);
    });
  });
}
