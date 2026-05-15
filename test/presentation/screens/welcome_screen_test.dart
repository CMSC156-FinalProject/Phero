import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phero_app/presentation/screens/welcome_screen.dart';
import 'package:phero_app/main.dart';

void main() {
  Widget createWidgetForTesting( { bool isDark = false, VoidCallback? onToggle } ) {
    return MaterialApp(
      home: WelcomeScreen(isDark: isDark, onToggle: onToggle ?? () {},),
    );
  }

  group('Welcome Screen Widget Tests', (){
    // ====== UI TESTS ======
    group('Welcome Screen UI Tests', () {
      testWidgets('Displays "Welcome" text', (WidgetTester tester) async {
        
        final welcomeText = find.text('welcome!');

        await tester.pumpWidget(createWidgetForTesting());

        expect(welcomeText, findsOne);
      });

      testWidgets('Displays continue button', (WidgetTester tester) async {
        
        final continueButton = find.text('continue');

        await tester.pumpWidget(createWidgetForTesting());

        expect(continueButton, findsOneWidget);
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

    // ====== WELCOME NAVIGATION TESTS ======
    group('Welcome Navigation Tests', () {
      testWidgets('Continue button navigates to Sign In Page', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetForTesting());

        final continueButton = find.text('continue');
        expect(continueButton, findsOne);

        await tester.tap(continueButton);
        await tester.pumpAndSettle();

        expect(find.text('SIGN IN'), findsOne);
      });
    });
  });
}