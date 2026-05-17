import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phero_app/auth/signin_screen.dart';
import 'package:phero_app/main.dart';

void main() {
  Widget createWidgetForTesting( { bool isDark = false, VoidCallback? onToggle } ) {
    return MaterialApp(
      home: SignInScreen(),
    );
  }
  
  // ====== SIGN IN VALIDATION TESTS ======
  group('Sign In Validation Tests', () {
    testWidgets('Submitting empty fields show validation errors', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting());
      
      final signInBtn = find.widgetWithText(ElevatedButton, 'sign in');

      await tester.tap(signInBtn);
      await tester.pumpAndSettle();

      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);

    });

    testWidgets('Submitting email without password shows only password errors', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting());
      
      final emailField = find.byType(TextField).first;
      final signInBtn = find.widgetWithText(ElevatedButton, 'sign in');

      await tester.enterText(emailField, 'isko@up.edu.ph');
      
      await tester.tap(signInBtn);
      await tester.pumpAndSettle();

      expect(find.text('Please enter your password'), findsOneWidget);
      expect(find.text('Please enter your email'), findsNothing);
    });

    testWidgets('Unmatching Password and Confirm Password show error', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting());
      
      final passwordField = find.byType(TextField).first;
      final confirmPasswordField = find.byType(TextField).last;
      final signInBtn = find.widgetWithText(ElevatedButton, 'sign in');

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
        final themeToggleBtn = find.byType(IconButton);

        await tester.pumpWidget(createWidgetForTesting(isDark: false));

        expect(themeToggleBtn, findsOneWidget);
      });

      testWidgets('Show sun icon in dark mode', (WidgetTester tester) async {
        final themeToggleBtn = find.byType(IconButton);

        await tester.pumpWidget(createWidgetForTesting(isDark: true));

        expect(themeToggleBtn, findsOneWidget);
      });

      testWidgets('Toggle theme button is triggered', (WidgetTester tester) async {
        await tester.pumpWidget(const PheroApp()); // Use the actual app to test theme toggle
        
        await tester.tap(find.byIcon(Icons.nightlight_round));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.nightlight_round), findsNothing); // Should show moon icon in light mode
        expect(find.byIcon(Icons.wb_sunny), findsOneWidget);  // Should show sun icon in dark mode
      });
  });

  // ====== PASSWORD VISIBILITY TESTS ======
  group('Password Visibility Tests', () {
    testWidgets('Password Visibility Test', (WidgetTester tester) async {

      await tester.pumpWidget(createWidgetForTesting());
      final toggleBtns = find.byIcon(Icons.visibility_off_outlined);
      expect(toggleBtns, findsNWidgets(2)); // Should find 2 toggle buttons for password and confirm password fields

      await tester.tap(toggleBtns.first);
      await tester.tap(toggleBtns.last);
      
      await tester.pumpAndSettle(); // Waits for the UI to rebuild after tapping the toggle buttons

      expect(toggleBtns, findsNWidgets(2));
    });
  });

  // ====== SIGN IN NAVIGATION TESTS ======
  group('Sign in Navigation Tests', () {
    testWidgets('Elevated "Sign In" button navigates to Report Page', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting());

      final signInBtn = find.widgetWithText(ElevatedButton, 'sign in');
      expect(signInBtn, findsOneWidget);

      await tester.tap(signInBtn);
      await tester.pumpAndSettle();
 
      expect(find.text('Report Issue'), findsOne); // Verifies that the Report page is shown

      // Verifies that the Sign in page is gone
      expect(find.text('Confirm Password'), findsNothing);
    });

    testWidgets('TextButton "Already have an account? Log in" navigates to Login Page', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting());
  
      final loginBtn = find.text('LOG IN');
      expect(loginBtn, findsOne);
  
      await tester.tap(loginBtn);
      await tester.pumpAndSettle();
  
      expect(find.text('LOG IN'), findsOne); // Verifies that the Login page is shown
  
      // Should verify that the Sign in page is gone
      expect(find.text('Confirm Password'), findsNothing);
    });
  });
}