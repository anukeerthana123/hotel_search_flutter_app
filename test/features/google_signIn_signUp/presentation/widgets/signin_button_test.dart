import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mytravaly/features/google_signIn_signUp/presentation/widgets/signin_button.dart';
import 'package:network_image_mock/network_image_mock.dart'; // ✅ Prevents HTTP errors

void main() {
  testWidgets('renders GoogleSignInButton with logo and text',
      (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoogleSignInButton(
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsOneWidget);

      expect(find.byType(Image), findsOneWidget);

      expect(find.text('Sign in with Google'), findsOneWidget);

      // Tap and verify callback
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(pressed, isTrue);
    });
  });

  testWidgets('button has correct styling', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoogleSignInButton(onPressed: () {}), // disabled state
          ),
        ),
      );

      final ElevatedButton button =
          tester.widget(find.byType(ElevatedButton)) as ElevatedButton;

      final ButtonStyle style = button.style!;
      final WidgetStateProperty<Color?>? backgroundColor =
          style.backgroundColor;

      // Verify background color (Google Blue)
      expect(backgroundColor?.resolve({}), const Color(0xFF4285F4));

      // Verify shape has rounded corners
      final shape = style.shape?.resolve({});
      expect(shape, isA<RoundedRectangleBorder>());
      final RoundedRectangleBorder roundedShape =
          shape as RoundedRectangleBorder;
      expect(roundedShape.borderRadius, BorderRadius.circular(4));
    });
  });
}
