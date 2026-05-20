import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:phero_app/auth/signin_screen.dart';
import 'package:phero_app/main.dart';
import '../test_utils.dart';
import 'package:phero_app/core/theme/theme_notifier.dart';

void main() {
  Widget createWidgetForTesting( { bool isDark = false, VoidCallback? onToggle } ) {
    final themeNotifier = ThemeNotifier();
    if (isDark) {
      themeNotifier.toggle();
    }
    return createTestableWidget(
      themeNotifier: themeNotifier,
      child: const SignInScreen(),
    );
  }
  
  // ====== SIGN IN VALIDATION TESTS ======
  group('Sign In Validation Tests', () {
    testWidgets('Submitting empty fields show validation errors', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting());
      
      // Wait for AuthViewModel initialization
      await tester.pumpAndSettle();
      
      final signInBtn = find.byType(ElevatedButton);

      await tester.tap(signInBtn);
      await tester.pumpAndSettle();

      expect(find.text('Email is required', skipOffstage: false), findsOneWidget);
      expect(find.text('Password is required', skipOffstage: false), findsOneWidget);

    });

    testWidgets('Submitting email without password shows only password errors', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting());
      
      final emailField = find.byType(TextField).first;
      final signInBtn = find.byType(ElevatedButton);

      await tester.enterText(emailField, 'isko@up.edu.ph');
      
      await tester.tap(signInBtn);
      await tester.pumpAndSettle();

      expect(find.text('Password is required', skipOffstage: false), findsOneWidget);
      expect(find.text('Email is required', skipOffstage: false), findsNothing);
    });

    testWidgets('Unmatching Password and Confirm Password show error', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting());
      
      final emailField = find.byType(TextField).at(0);
      final passwordField = find.byType(TextField).at(1);
      final confirmPasswordField = find.byType(TextField).at(2);
      final signInBtn = find.byType(ElevatedButton);

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(confirmPasswordField, 'differentpassword');

      await tester.tap(signInBtn);
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match. Please try again.'), findsOneWidget);
    });
  });
  
  // ====== THEME TOGGLE TESTS ======
  group('Theme Toggle Tests', () {
      testWidgets('Show moon icon in light mode', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetForTesting(isDark: false));

        expect(find.byIcon(Icons.nightlight_round), findsOneWidget);
      });

      testWidgets('Show sun icon in dark mode', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetForTesting(isDark: true));

        expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
      });

      testWidgets('Toggle theme button is triggered', (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ThemeNotifier()),
            ],
            child: const PheroApp(),
          ),
        ); // Use the actual app to test theme toggle
        
        // Wait for SplashScreen
        await tester.pumpAndSettle(const Duration(seconds: 3));

        await tester.tap(find.byIcon(Icons.nightlight_round));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.nightlight_round), findsNothing);
        expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
      });
  });

  // ====== PASSWORD VISIBILITY TESTS ======
  group('Password Visibility Tests', () {
    testWidgets('Password Visibility Test', (WidgetTester tester) async {

      await tester.pumpWidget(createWidgetForTesting());
      
      // Password and Confirm Password fields both use Icons.visibility_off_outlined
      expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(2));

      await tester.tap(find.byIcon(Icons.visibility_off_outlined).first);
      await tester.tap(find.byIcon(Icons.visibility_off_outlined).last);
      
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(2));
    });
  });

  // ====== SIGN IN NAVIGATION TESTS ======
  group('Sign in Navigation Tests', () {
    testWidgets('Elevated "Sign In" button navigates to Report Page', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting());

      final signInBtn = find.byType(ElevatedButton);
      expect(signInBtn, findsOneWidget);

      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.enterText(find.byType(TextField).at(2), 'password123');

      await tester.tap(signInBtn);
      await tester.pumpAndSettle();
      expect(find.text('Phero'), findsOneWidget); // Verifies that the Report page is shown

      // Verifies that the Sign in page is gone
      expect(find.text('Confirm Password'), findsNothing);
    });

    testWidgets('TextButton "Already have an account? Log in" navigates to Login Page', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting());
  
      // Find the "LOG IN" link text (not the header)
      final loginLink = find.descendant(
        of: find.byType(GestureDetector),
        matching: find.text('LOG IN'),
      );
      expect(loginLink, findsOneWidget);
  
      await tester.tap(loginLink);
      await tester.pumpAndSettle();
  
      // Should now be on the Login screen, which has the "LOG IN" elevated button
      expect(find.byType(ElevatedButton), findsOneWidget); 
  
      // Verifies that the Sign in page is gone
      expect(find.text('Confirm Password'), findsNothing);
    });
  });
}