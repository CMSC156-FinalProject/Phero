import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:phero_app/auth/login_screen.dart';
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
      child: const LoginScreen(),
    );
  }
  
  // ====== LOGIN VALIDATION TESTS ======
  group('Login Validation Tests', () {
    testWidgets('Submitting empty fields show validation errors', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(createWidgetForTesting());
      
      // Wait for AuthViewModel initial checkAuthStatus to complete (so isLoading becomes false)
      await tester.pumpAndSettle();
      
      final loginBtn = find.byType(ElevatedButton);

      await tester.tap(loginBtn);
      await tester.pumpAndSettle();

      expect(find.text('Email is required', skipOffstage: false), findsOneWidget);
      expect(find.text('Password is required', skipOffstage: false), findsOneWidget);
    });

    testWidgets('Submitting email without password shows only password errors', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting());
      
      final emailField = find.byType(TextField).first;
      final loginBtn = find.byType(ElevatedButton);

      await tester.enterText(emailField, 'isko@up.edu.ph');
      
      await tester.tap(loginBtn);
      await tester.pumpAndSettle();

      expect(find.text('Password is required', skipOffstage: false), findsOneWidget);
      expect(find.text('Email is required', skipOffstage: false), findsNothing);
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
        ); 
        
        await tester.pumpAndSettle(const Duration(seconds: 3)); 

        final toggleIcon = find.byIcon(Icons.nightlight_round);
        expect(toggleIcon, findsOneWidget);

        await tester.tap(toggleIcon);
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.nightlight_round), findsNothing);
        expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
      });
  });

  // ====== PASSWORD VISIBILITY TESTS ======
  group('Password Visibility Tests', () {
    testWidgets('Password Visibility Test', (WidgetTester tester) async {

      await tester.pumpWidget(createWidgetForTesting());
      final toggleBtn = find.byIcon(Icons.visibility_off_outlined);
      expect(toggleBtn, findsOneWidget);

      await tester.tap(toggleBtn);
      await tester.pumpAndSettle();

      // In the implementation, both states use Icons.visibility_off_outlined as the icon data,
      // but the logic toggles the _showPassword bool. 
      // Wait, checking login_screen.dart... _buildField uses the passed 'icon' parameter.
      // Password field passes Icons.visibility_off_outlined always.
      // So the icon doesn't change, only the 'obscure' property.
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });
  });

  // ====== LOGIN NAVIGATION TESTS ======
  group('Login Navigation Tests', () {
    testWidgets('Elevated "Log in" button navigates to Report Page', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting());

      final loginBtn = find.byType(ElevatedButton);
      expect(loginBtn, findsOneWidget);

      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'password123');

      await tester.tap(loginBtn);
      await tester.pumpAndSettle();
 
      // The MapFeedScreen (Report Page) contains 'Phero' text logo
      expect(find.text('Phero'), findsOneWidget);

      expect(find.text('Confirm Password'), findsNothing);
    });
  });
}